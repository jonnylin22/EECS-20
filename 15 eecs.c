#include <stdio.h>
#include <stdbool.h>

#define MAX_NUMS 5

int main(void)
{
    int repIndex;
    int numbers[MAX_NUMS];  //for ex: 1 1 8 4 1
    int repeats[MAX_NUMS];
    int printed[MAX_NUMS] = {0};


    printf("Enter %d numbers.\n", MAX_NUMS);
    for (int index = 0; index < MAX_NUMS; index++) {
        printf("Input number %d: ", index+1);
        scanf("%d", &numbers[index]); // note: address of element
    }

    for (int index = 0; index < MAX_NUMS; index++) {            // 0 --> 5
        repeats[index] = 0;
        for (repIndex = 0; repIndex < MAX_NUMS; repIndex++) {   // 0 --> 5
            if (numbers[repIndex] == numbers[index]) {      
                repeats[index]++;       // repeats = [3, 3, 1, 1, 3]
            }   
        } 
    }
    
    for (int index = 0; index < MAX_NUMS; index++) {    // loops through 1 1 8 4 1
        // check if it was already printed 
        if (!printed[index]) {  // print only if number hasnt been printed yet
            printf("Original number %d. Number of repeats %d.\n",
            numbers[index], repeats[index]);
            printed[index] = numbers[index];    
        } 

        // mark all those occurances of current number printed in the printed array
        for (int i = 0 ; i < MAX_NUMS ; i ++) {
            if (printed[index] == numbers[i]) {
                printed[i] = numbers[index];
                printf("%d %d\n", i, numbers[index]);
            }
            
        }
        

    }
    

    return 0;
}