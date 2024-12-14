/*** 
Write a function to print out an integer value in base 3 (using only the digits 0, 1, 2). 
Use this function to write a program that reads two integers in base 10/decimal from the 
keyboard and displays both numbers and their sum in base 3 on the screen. 
You only need to handle valid cases.

Example scenario (5 & 9 provided as input from user):

Welcome to 3-Base-10!
Enter First Number (in decimal): 5
Entre Second Number (in decimal): 9
Base 3 Results:
5 in decimal is 12 in base 3
9 in decimal is 100 in base 3
12 + 100 = 112 in base 3
***/

#include <stdio.h>
#include <math.h>

void base3(int n, int num1, int num2){
    int sum = 0;
    int sum_arr[n];
    int converted1[n];
    int converted2[n];
    int convertedInt1 = 0;
    int convertedInt2 = 0;
    int divide1 = num1;     // = decimal / 3;
    int divide2 = num2;
    int remainder1;  // = decimal % 3;
    int remainder2;
     
    for (int i = 0 ; i < n ; i ++) {
        remainder1 = divide1 % 3;  // 5 % 3 = 2
        remainder2 = divide2 % 3;
        converted1[i] = remainder1;               // [0, 0, 0, 0, 0, 0, 0, 1, 2]
        converted2[i] = remainder2;
        //printf("%d ", converted1[i]);
        //printf("%d ", converted2[i]);
        divide1 = divide1 / 3; //next divide       // 5 / 3 = 1    
        divide2 = divide2 / 3;
    }

    //printf("\n");
    for (int i = 0 ; i < n ; i ++){
        //printf("%d", converted[i]);
        convertedInt1 += converted1[i] * (int)pow(10.0, i);
        convertedInt2 += converted2[i] * (int)pow(10.0, i);
    }

    // calculate sum
    int carry = 0 ;
    for (int i = 0 ; i < n ; i ++) {
        // 2 1 0 0 0 0 0 0 0 + // 0 0 1 0 0 0 0 0 0
        int temp_sum  = 0;
        temp_sum = converted1[i] + converted2[i];
        if (temp_sum <= 2) {
            sum_arr[i] = temp_sum;
        } else if (temp_sum == 3){
            sum_arr[i] = sum_arr[i] + 0 + carry;
            carry = 1;
        } else if (temp_sum == 4) {
            sum_arr[i] = sum_arr[i] + 1 + carry;
            carry = 1;
        } else if (temp_sum == 5) {
            sum_arr[i] = sum_arr[i] + 2 + carry;
            carry = 2;
        }
    }

    // convert sum_arr to an integer 
    for (int i = 0 ; i < n ; i ++){
        //printf("%d", converted[i]);
        sum += sum_arr[i] * (int)pow(10.0, i);
    }

    printf("%d in decimal is %d in base 3\n", num1, convertedInt1);
    printf("%d in decimal is %d in base 3\n", num2, convertedInt2);
    printf("%d + %d = %d in base3", convertedInt1, convertedInt2, sum);

}

int main(void) {
    int num1;
    int num2;
    int n = 9;      // choose how many ternary digits // 9 digits

    printf("Welcome to 3-Base-10!\n");
    printf("Enter First Number (in decimal): ");
    scanf("%d[^\n]\n", &num1);
    printf("Enter Second Number (in decimal): ");
    scanf("%d[^\n]\n", &num2);

   printf("Base 3 Results:\n");
   base3(n, num1, num2);
}