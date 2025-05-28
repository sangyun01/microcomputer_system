// write the terminal the code
// $gcc wiring_switch_mmap.c gpio.c -o wiring_switch_mmap
// sudo ./wiring_switch_mmap

#include <stdio.h>
#include <time.h>
#include <stdlib.h>
#include <unistd.h>
#include <fcntl.h>
#include <sys/mman.h>
#include "gpio.h"

#define LED 18  // LED is light element -> write
#define SW 24   // Switch is user input element -> read

int switchControl(void);

int main(void) {
    wiringPiSetupGpio();
    switchControl();

    return 0;
}

int switchControl(void) {
    time_t start, current;
    int cnt = 0;
    start = time(NULL);

    pinMode(LED, OUTPUT);
    pinMode(SW, INPUT);

    while (difftime(time(NULL), start) < 30) {
        if(digitalRead(SW) == LOW) {
            digitalWrite(LED, HIGH);     // LED ON, HIGH = 1
            printf("Switch is pressed (count : %d)\r\n", ++cnt);
        }
        else {
            digitalWrite(LED, LOW);     // LED OFF, LOW = 0
        }
        delay(1000);
    }
}