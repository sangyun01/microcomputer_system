#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <fcntl.h>
#include <sys/mman.h>
#include "gpio.h"

// Global variables(전역 변수 선언)
volatile char* mmap_addr = NULL; // dereferencing element of value can variation where the physical addr -> So only change hardware change the value volatile(실시간으로만 변경)
int mmap_fd = -1; // -1 -> not open

// Set GPIO pin as input
void set_gpio_input(int gpio_no, char* mmap_addr) { // argument gpio_no(BCM), value of mmap_addr
    volatile unsigned int* gpio_reg = NULL; // set register value is null 
    int reg_idx = gpio_no / 10; // GPIO function selct has 10 index :ex. 19 -> GPSEL1
    int bit = (gpio_no % 10) * 3; // each pin is consist of 3 bit, so * 3 : ex. 19 -> 27 bit
    gpio_reg = (volatile unsigned int*)(mmap_addr + (reg_idx * 4)); // if SEL1 -> 0x04
    *gpio_reg &= ~(0b111 << bit);  // Set bits to 000 (input mode) -> 29 28 27 -> set 0 0 0 -> input mode
}

// Set GPIO pin as output
void set_gpio_output(int gpio_no, char* mmap_addr) {
    volatile unsigned int* gpio_reg = NULL;
    int reg_idx = gpio_no / 10;
    int bit = (gpio_no % 10) * 3;
    gpio_reg = (volatile unsigned int*)(mmap_addr + (reg_idx * 4));
    *gpio_reg &= ~(0b111 << bit);  // Clear bits to 000 -> 1st set 0 0 0
    *gpio_reg |= (0b001 << bit);  // Set bits to 001 (output mode) -> 2nd set 29 28 27 -> 0 0 1 -> output mode
}

// Read GPIO pin level
int gpio_lev(int gpio_no, char* mmap_addr) {
    volatile unsigned int* gpio_reg = NULL;
    int reg_idx = gpio_no / 32; // other description function is has 32 bit
    int bit = gpio_no % 32; // thus using 32bit and mod 32
    gpio_reg = (volatile unsigned int*)(mmap_addr + GPLEV0_OFFSET + (reg_idx * 4));
    return *gpio_reg & (1 << bit); // return the the bit is 1(high) -> true(1), 0-> false(0)
}

// Set GPIO pin HIGH
void gpio_set(int gpio_no, char* mmap_addr) {
    volatile unsigned int* gpio_reg = NULL;
    int reg_idx = gpio_no / 32;
    int bit = gpio_no % 32;
    gpio_reg = (volatile unsigned int*)(mmap_addr + GPSET0_OFFSET + (reg_idx * 4));
    *gpio_reg = (1 << bit); // set the bit value 1
}

// Set GPIO pin LOW
void gpio_clear(int gpio_no, char* mmap_addr) {
    volatile unsigned int* gpio_reg = NULL;
    int reg_idx = gpio_no / 32;
    int bit = gpio_no % 32;
    gpio_reg = (volatile unsigned int*)(mmap_addr + GPCLR0_OFFSET + (reg_idx * 4));
    *gpio_reg = (1 << bit); // set the bit value 1
}

// GPIO initialization
int wiringPiSetupGpio(void) {
    mmap_fd = open("/dev/mem", O_RDWR | O_SYNC); // access to physical address
    if (mmap_fd < 0) {
        printf("Error: Cannot open /dev/mem. Try running as root (e.g., $ sudo ./program).\n");
        return -1;
    } // file has write or read , sync I/O , only access using the sudo

    mmap_addr = (char*)mmap(NULL, GPIO_SIZE, PROT_READ | PROT_WRITE,
        MAP_SHARED, mmap_fd, GPIO_BASE); // virtual address
    if (mmap_addr == MAP_FAILED) {
        printf("Error: mmap failed\n");
        close(mmap_fd);
        return -1;
    }

    return 0;
}

// GPIO error check
int checkGpioError(int pin_no) {
    if (mmap_addr == NULL) { // not has virtual address
        printf("Error: GPIO not initialized. Call wiringPiSetupGpio() first.\n");
        return -1;
    }
    if (pin_no < 2 || pin_no > 28) { // using the gpio pin 2 ~ 28(BCM)
        printf("Error: Invalid pin number %d. Use 2~26\n", pin_no);
        return -1;
    }
    return 0;
}

// GPIO pin mode
int pinMode(int pin_no, int direction) { // pin num and output or input
    if (checkGpioError(pin_no)) return -1;

    if (direction == INPUT)
        set_gpio_input(pin_no, (char*)mmap_addr); // set input mode, bit is 000
    else if (direction == OUTPUT)
        set_gpio_output(pin_no, (char*)mmap_addr); // set output mode, bit is 001
    else {
        printf("Error: Invalid direction. Use INPUT(0) or OUTPUT(1).\n");
        return -1;
    }

    return 0;
}

// Digital read
int digitalRead(int pin_no) {
    if (checkGpioError(pin_no)) return -1;
    return (gpio_lev(pin_no, (char*)mmap_addr) != 0) ? 1 : 0; // return lev가 high -> true -> digitalRead -> 1
}

// Digital write
int digitalWrite(int pin_no, int value) {
    if (checkGpioError(pin_no)) return -1;

    if (value == HIGH)
        gpio_set(pin_no, (char*)mmap_addr); // set High
    else if (value == LOW)
        gpio_clear(pin_no, (char*)mmap_addr); // set Low
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
