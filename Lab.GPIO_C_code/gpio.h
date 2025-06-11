#ifndef GPIO_H
#define GPIO_H

// set the default value of input, output, low, high
#define INPUT 0 // input을 0으로 set
#define OUTPUT 1 // output을 1로 set
#define LOW 0 // LOW를 0으로 set
#define HIGH 1 // HIGH를 1로 set

// set the address the virtual address(map address) about raspi
#define IO_BASE 0x3F000000 // raspi Input/Output base(physical) address
#define GPIO_BASE (IO_BASE + 0x200000) // gpio physical address is 0x3F200000
#define GPIO_SIZE 256 //register block size maybe like 0x100

// set register offset
#define GPFSEL0_OFFSET 0x0 //0x7E20 0000
#define GPSET0_OFFSET 0x1C //0x7E20 001C
#define GPCLR0_OFFSET 0x28 //0x7E20 0028
#define GPLEV0_OFFSET 0x34 //0x7E20 0034

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

extern volatile char *mmap_addr; // volatile -> using the interrupt, *mmap_addr is virtual address
extern int mmap_fd;

#endif