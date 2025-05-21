// write the terminal the code
// $gcc wiring_switch.c -o wiring_switch -l wiringPi
// ./wiring_switch

#include <stdio.h>
#include <time.h>   // check the time
#include <wiringPi.h>

//set the gpio pin where the C code, not input by user
#define LED 18  // LED is light element -> write
#define SW 24   // Switch is user input element -> read

int switchControl(void);

int main(void) {
    wiringPiSetupGpio(); // set pin number WiringPi -> BCM using the wiringPi library
    switchControl();

    return 0;            // exit success
}

int switchControl(void){
    time_t start, current;
    int count = 0;
    start = time(NULL); // criterion point, time(NULL) : current time

    pinMode(LED, OUTPUT);
    pinMode(SW, INPUT);

    while (difftime(time(NULL), start) < 60) { // prevent inf loop
            // it means current time - start time < 60
        if(digitalRead(SW) == LOW) {
            digitalWrite(LED, HIGH); // LED ON, HIGH = 1
            printf("Switch is pressed (count: %d)\r\n", ++count); // ++count is update the value count
        }
        else {
            digitalWrite(LED, LOW);  // LED OFF, LOW = 0
        }
        delay(10); // prevent the chattering(prevent the not purpose the increasement when not push the button)
    }
    
    return 0;
}