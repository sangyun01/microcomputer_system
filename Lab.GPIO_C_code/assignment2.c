#include <stdio.h>
#include <time.h>
#include <stdlib.h>
#include <unistd.h>
#include <fcntl.h>
#include <sys/mman.h>
#include "gpio.h"  // custom GPIO control

// Constants
#define SW_NUM     4 // switch 개수
#define SW_ON      26 // red button
#define SW_OFF     19 // blue 
#define SW1        13 // white button
#define SW2        6 // green button

#define LED_NUM    3 // LED 개수
#define LED0       21 // y -> always
#define LED1       20 // when the SW1 -> input digit -> convert signal
#define LED2       16 // when the SW2 -> input digit -> convert signal

#define RUNTIME    30  // seconds

// Type Definitions
typedef struct {
    const int* pins;
    int count;
} GpioList;

// Function Prototypes
void setGPIO(GpioList inputs, GpioList outputs);
void handleInputs(GpioList inputs, int state[]);
void handleStatus(int pin_no);
void clearOutputs(GpioList outputs);

// ---------------------- Main Function ----------------------

int main(void) {
    // Switch state tracking (initially HIGH)
    int prev_states[SW_NUM] = { HIGH, HIGH, HIGH, HIGH };

    // Define pin arrays
    const int switch_pins[SW_NUM] = { SW_ON, SW_OFF, SW1, SW2 };
    const int led_pins[LED_NUM] = { LED0, LED1, LED2 };

    // Wrap arrays into GpioList structs
    GpioList inputs = { switch_pins, SW_NUM };
    GpioList outputs = { led_pins, LED_NUM };

    // Initialize GPIO and turn on status LED
    setGPIO(inputs, outputs);
    digitalWrite(LED0, HIGH);

    // Main runtime loop
    time_t start = time(NULL);
    while (difftime(time(NULL), start) < RUNTIME) {
        handleInputs(inputs, prev_states);
    }

    // Cleanup
    clearOutputs(outputs);
    return 0;
}

// ---------------------- Function Definitions ----------------------

void setGPIO(GpioList inputs, GpioList outputs) {
    wiringPiSetupGpio();

    for (int i = 0; i < inputs.count; i++)
        pinMode(inputs.pins[i], INPUT);

    for (int i = 0; i < outputs.count; i++)
        pinMode(outputs.pins[i], OUTPUT);
}

void clearOutputs(GpioList outputs) {
    for (int i = 0; i < outputs.count; i++)
        digitalWrite(outputs.pins[i], LOW);
}

void handleInputs(GpioList inputs, int state[]) {
    for (int i = 0; i < inputs.count; i++) {
        int curr = digitalRead(inputs.pins[i]);
        if (state[i] == HIGH && curr == LOW) {
            handleStatus(inputs.pins[i]);  // rising edge detection
        }
        state[i] = curr;
    }
    delay(50);  // debounce
}

void handleStatus(int pin_no) {
    if (pin_no == SW_ON) {
        digitalWrite(LED1, HIGH);
        digitalWrite(LED2, HIGH);
    }
    else if (pin_no == SW_OFF) {
        digitalWrite(LED1, LOW);
        digitalWrite(LED2, LOW);
    }
    else if (pin_no == SW1) {
        digitalWrite(LED1, !digitalRead(LED1));
    }
    else if (pin_no == SW2) {
        digitalWrite(LED2, !digitalRead(LED2));
    }
}
