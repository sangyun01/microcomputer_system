// write the terminal the code
// $gcc wiring_led.c -o wiring_led -l wiringPi
// ./wiring_led 18 -> using the gpio pin 18
// -l wiringPi -> using thd library wiringPi file

#include <stdio.h>
#include <stdlib.h>
#include <wiringPi.h>

// gpio = 18 why the ./wiring_led 18
int ledControl(int gpio); // define the function ledControl why the C

int main(int argc, char** argv) {   //argc -> the number of argument, argv -> array of argument
    int gno;

    // when user less input the argument then print the number pin
    if(argc < 2) {
        printf("Usage: %s GPIO_NO\n", argv[0]);
        return -1;  // error exit
    }

    gno = atoi(argv[1]); // change the input value about char -> int
    wiringPiSetupGpio(); // set pin number WiringPi -> BCM using the wiringPi library
    ledControl(gno);     // gno = 18

    return 0;            // exit success
}

int ledControl(int gpio){

    pinMode(gpio, OUTPUT);  // OUTPUT : because the using the led, led is light output element
    for (int i = 0; i < 5; i++) { // i = 0 ~ 4 // repeat 5 times
        digitalWrite(gpio, HIGH); // LED ON, HIGH = 1
        delay(1000);              // maintain 1s
        digitalWrite(gpio, LOW);  // LED OFF, LOW = 0
        delay(1000);              // maintain 1s
    }
    return 0;
}