// write the terminal the code
// $gcc wiring_switch_interrupt.c -o wiring_switch_interrupt -l wiringPi
// ./wiring_switch_interrupt

// why using the interrupt code, when the execute the during while loop, not execute other code.
// so we using interrupt code, then execute like parallel code

#include <stdio.h>
#include <wiringPi.h>

#define LED 18  // LED is light element -> write
#define SW 24   // Switch is user input element -> read

void isr_sw(void);

int main(void) {

    unsigned int sec = 0; // why not using the time.h -> In this code like parallel code so only using the delay(1000) & repeat 30 times

    wiringPiSetupGpio(); // set pin number WiringPi -> BCM using the wiringPi library
    pinMode(LED, OUTPUT);
    pinMode(SW, INPUT);
    wiriringPiISR(SW, INT_EDGE_BOTH, isr_sw);
    // when variation the SW falling or rising then execute function
    // during the declare the wiriringPiISR to end of main code

    while(sec < 0) {
        printf("%d sec. \r\n", sec);
        sec = sec + 1;
        delay(1000);
    }

    return 0;            // exit success
}

void isr_sw(void) {
    if(digitalRead(SW) == LOW) {
        digitalWrite(LED, HIGH);     // LED ON, HIGH = 1
    }
    else {
        digitalWrite(LED, LOW);     // LED OFF, LOW = 0
    }
}