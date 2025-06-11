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
    int prev_states[SW_NUM] = { HIGH, HIGH, HIGH, HIGH }; // 초기상태 다 HIGH -> 다 꺼진 상태

    // Define pin arrays
    const int switch_pins[SW_NUM] = { SW_ON, SW_OFF, SW1, SW2 };
    const int led_pins[LED_NUM] = { LED0, LED1, LED2 };

    // Wrap arrays into GpioList structs
    GpioList inputs = { switch_pins, SW_NUM };
    GpioList outputs = { led_pins, LED_NUM };

    // Initialize GPIO and turn on status LED
    setGPIO(inputs, outputs); // input pin -> input mode, output pin -> output mode
    digitalWrite(LED0, HIGH); // LED0 is always On when the code is execute

    // Main runtime loop
    time_t start = time(NULL); // start time
    while (difftime(time(NULL), start) < RUNTIME) {// currrent time - start time  > 30 -> break
        handleInputs(inputs, prev_states); // < 30 -> check the all sw_button is push or not 
    }

    // Cleanup
    clearOutputs(outputs); // all led off
    return 0;
}

// ---------------------- Function Definitions ----------------------

void setGPIO(GpioList inputs, GpioList outputs) {
    wiringPiSetupGpio(); // decide error 

    for (int i = 0; i < inputs.count; i++) // 0 ~ SW_NUM -1 -> index 0 ~ 3 
        pinMode(inputs.pins[i], INPUT); // set 0 ~ 3 -> input

    for (int i = 0; i < outputs.count; i++) // 0 ~ LED_NUM - 1 -> index 0 ~ 2 
        pinMode(outputs.pins[i], OUTPUT); // set 0 ~ 2 -> output
}

void clearOutputs(GpioList outputs) {
    for (int i = 0; i < outputs.count; i++)
        digitalWrite(outputs.pins[i], LOW); // Led1 & Led2 off
}

void handleInputs(GpioList inputs, int state[]) {
    for (int i = 0; i < inputs.count; i++) { // sw 0 ~ 3
        int curr = digitalRead(inputs.pins[i]); // read cuurent state button push
        if (state[i] == HIGH && curr == LOW) { // push the button num is low(눌린 상태) before state is high(기본 상태)
            handleStatus(inputs.pins[i]);  // rising edge detection
        }
        state[i] = curr;
    }
    delay(50);  // debounce
}

void handleStatus(int pin_no) {
    if (pin_no == SW_ON) { // 둘다 킴
        digitalWrite(LED1, HIGH);
        digitalWrite(LED2, HIGH);
    }
    else if (pin_no == SW_OFF) { // 둘다 끔
        digitalWrite(LED1, LOW);
        digitalWrite(LED2, LOW);
    }
    else if (pin_no == SW1) { // 1만 상태 변화
        digitalWrite(LED1, !digitalRead(LED1));
    }
    else if (pin_no == SW2) { // 2만 상태 변화
        digitalWrite(LED2, !digitalRead(LED2));
    }
}
