#ifndef GPIO_H
#define GPIO_H

// set the default value of input, output, low, high
#define INPUT 0
#define OUTPUT 1
#define LOW 0
#define HIGH 1

// set the address the virtual address(map address) about raspi
#define IO_BASE 0x3F000000
#define GPIO_BASE (IO_BASE + 0x200000)
#define GPIO_SIZE 256

// set register offset
#define GPFSEL0_OFFSET 0x0
#define GPSET0_OFFSET 0x1C
#define GPCLR0_OFFSET 0x28
#define GPLEV0_OFFSET 0x34

// define using the function
void set_gpio_input(int gpio_no, char *mmap_addr);
void set_gpio_output(int gpio_no, char *mmap_addr);
int gpio_lev(int gpio_no, char *mmap_addr);
void gpio_set(int gpio_no, char *mmap_addr);
void gpio_clear(int gpio_no, char *mmap_addr);
int wiringPiSetupGpio(void);
int checkGpioError(int pin_no);
int pinMode(int pin_no, int direction);
int digitalRead(int pin_no);
int digitalWrite(int pin_no, int value);
void delay(int msec);

extern volatile char *mmap_addr; // using the interrupt
extern int mmap_fd;

#endif