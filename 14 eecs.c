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

void base3(int num){
    if (num == 0) {
        return ;
    } else {
        base3(num / 3);
        printf("%d", num % 3);
    }

}

int main(void) {
    int num1;
    int num2;

    printf("Welcome to 3-Base-10!\n");
    printf("Enter First Number (in decimal): ");
    scanf("%d[^\n]\n", &num1);
    printf("Enter Second Number (in decimal): ");
    scanf("%d[^\n]\n", &num2);

    printf("Base 3 Results:\n");
    printf("%d in base3 is ", num1 ); base3(num1);
    printf("\n%d in base3 is ", num2 ); base3(num2); printf("\n");
    base3(num1); printf(" + "); base3(num2); printf(" = "); base3(num1+num2);
}