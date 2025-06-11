    #include <stdio.h>
    #include <stdlib.h>
    #include <unistd.h>
    #include <fcntl.h>
    #include <sys/mman.h>
    #include "gpio.h"

    // Global variables
    volatile char* mmap_addr = NULL; // set the virtual address pointer is null initially
    int mmap_fd = -1; // return failed

    // Set GPIO pin as input
    void set_gpio_input(int gpio_no, char* mmap_addr) { //GPFSEL0 ~ 5
        volatile unsigned int* gpio_reg = NULL;
        int reg_idx = gpio_no / 10; // set one of the 0 ~ 5 register
        int bit = (gpio_no % 10) * 3; // set the bit of select register
        gpio_reg = (volatile unsigned int*)(mmap_addr + (reg_idx * 4)); // virtual address
        *gpio_reg &= ~(0b111 << bit);  // Set bits to 000 (input mode)
    }

    // Set GPIO pin as output
    void set_gpio_output(int gpio_no, char* mmap_addr) { //GPFSEL0 ~ 5
        volatile unsigned int* gpio_reg = NULL;
        int reg_idx = gpio_no / 10;
        int bit = (gpio_no % 10) * 3;
        gpio_reg = (volatile unsigned int*)(mmap_addr + (reg_idx * 4));
        *gpio_reg &= ~(0b111 << bit);  // Clear bits to 000
        *gpio_reg |= (0b001 << bit);  // Set bits to 001 (output mode)
    }

    // Read GPIO pin level
    int gpio_lev(int gpio_no, char* mmap_addr) { //GPLEV0 ~ 1
        volatile unsigned int* gpio_reg = NULL;
        int reg_idx = gpio_no / 32; // select 0 or 1 register
        int bit = gpio_no % 32; // select the bit
        gpio_reg = (volatile unsigned int*)(mmap_addr + GPLEV0_OFFSET + (reg_idx * 4));
        return *gpio_reg & (1 << bit); // read the value is high or low
    }

    // Set GPIO pin HIGH
    void gpio_set(int gpio_no, char* mmap_addr) { // GPSET0 ~ 1
        volatile unsigned int* gpio_reg = NULL;
        int reg_idx = gpio_no / 32; // select 0 or 1 register
        int bit = gpio_no % 32; // select the bit 0 ~ 30
        gpio_reg = (volatile unsigned int*)(mmap_addr + GPSET0_OFFSET + (reg_idx * 4));
        *gpio_reg = (1 << bit); // set the select bit value is high
    }

    // Set GPIO pin LOW
    void gpio_clear(int gpio_no, char* mmap_addr) { // GPCLR0 ~ 1
        volatile unsigned int* gpio_reg = NULL;
        int reg_idx = gpio_no / 32;
        int bit = gpio_no % 32;
        gpio_reg = (volatile unsigned int*)(mmap_addr + GPCLR0_OFFSET + (reg_idx * 4));
        *gpio_reg = (1 << bit); // set the select the bit value is low
    }

    // GPIO initialization
    int wiringPiSetupGpio(void) {
        mmap_fd = open("/dev/mem", O_RDWR | O_SYNC); // read or write and sync(동기)
        if (mmap_fd < 0) {  // 안열린다면
            printf("Error: Cannot open /dev/mem. Try running as root (e.g., $ sudo ./program).\n");
            return -1; // return failed
        }
        // when can open
        mmap_addr = (char*)mmap(NULL, GPIO_SIZE, PROT_READ | PROT_WRITE,
            MAP_SHARED, mmap_fd, GPIO_BASE);
            // NULL -> OS auto select
            // GPIO_SIZE -> 256(0x100)
            // PROT_READ | PROT_WRITE -> protect mode
            // MAP_SHARED -> mapping method
            // mmap_fd -> file directory
            // GPIO_BASE -> offset to using physical address
        if (mmap_addr == MAP_FAILED) {
            printf("Error: mmap failed\n");
            close(mmap_fd);
            return -1;
        }

        return 0;
    }

    // GPIO error check
    int checkGpioError(int pin_no) {
        if (mmap_addr == NULL) {
            printf("Error: GPIO not initialized. Call wiringPiSetupGpio() first.\n");
            return -1;
        }
        if (pin_no < 2 || pin_no > 28) { // only usally using the GPIO pin 2 ~ 27
            printf("Error: Invalid pin number %d. Use 2~26\n", pin_no);
            return -1;
        }
        return 0;
    }

    // GPIO pin mode
    int pinMode(int pin_no, int direction) {
        if (checkGpioError(pin_no)) return -1;
        // diff about offset address
        if (direction == INPUT) // input
            set_gpio_input(pin_no, (char*)mmap_addr); // GPFSEL0 ~ 5
        else if (direction == OUTPUT)
            set_gpio_output(pin_no, (char*)mmap_addr); // GPFSEL0 ~ 5
        else { // not using other mode in this code.
            printf("Error: Invalid direction. Use INPUT(0) or OUTPUT(1).\n");
            return -1;
        }

        return 0;
    }

    // Digital read
    int digitalRead(int pin_no) { // Read -> GPLEV0 ~ 1
        if (checkGpioError(pin_no)) return -1;
        return (gpio_lev(pin_no, (char*)mmap_addr) != 0) ? 1 : 0;
    } // when the read the value like 3.3(V) -> set High 1 / 0(V) -> set Low

    // Digital write
    int digitalWrite(int pin_no, int value) {
        if (checkGpioError(pin_no)) return -1;

        if (value == HIGH)
            gpio_set(pin_no, (char*)mmap_addr); // GPSET0 ~ 1
        else if (value == LOW)
            gpio_clear(pin_no, (char*)mmap_addr); // GPCLR0 ~ 1
        else {
            printf("Error: Invalid value. Use HIGH(1) or LOW(0).\n");
            return -1;
        }

        return 0;
    }

    // Millisecond delay
    void delay(int msec) {
        usleep(msec * 1000);
    }
