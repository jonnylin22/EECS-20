/*** 16.9 
Write a program to remove any duplicates from a sequence of numbers. 
For example, if the list consisted of the numbers 5, 4, 5, 5, and 3, 
the program would output 5, 4, 3. ***/

#include <stdio.h>
#define MAX_NUMS 5

void InsertionSort(int list[]) {
    int unsorted; // index marking beginning of unsorted part
    int sorted; // index for sorted part
    int unsortedItem; // temp value for moving value
    for (unsorted = 1; unsorted < MAX_NUMS; unsorted++) {
        unsortedItem = list[unsorted]; // item to be inserted
        // working backwards, shift sorted values to the right
        // until we make reach the position of the new item
        for (sorted = unsorted - 1;
            (sorted >=0) && (list[sorted] > unsortedItem);sorted--) {
            list[sorted+1] = list[sorted]; // shift to right
        }
        // after loop, sorted+1 is position where item should go
        list[sorted+1] = unsortedItem;
    }
}

void filter_duplicates(int numbers[], int repeats[]) {
    int sum_repeats = 0;
    int duplicates[MAX_NUMS];
    duplicates[0] = numbers[0];     // initialize to first element in list   
    int len_filtered = 0;
    for (int i = 0 ; i < MAX_NUMS ; i ++) {
        sum_repeats += repeats[i];
    }
    
    if (sum_repeats == 0 ) {    // no repeats
        InsertionSort(numbers);
        return;
    }

    for (int index = 0 ; index < MAX_NUMS ; index ++) {
        
        for (int i = 0 ; i < MAX_NUMS ; i ++ ) {
            if (duplicates[i] == numbers[index]) {
                numbers[index] = -1;
            } else {
                duplicates[i] = numbers[index];   
                len_filtered++;  
            }
        } 
    }

    // sort list of ints
    InsertionSort(numbers);
}

int main(void){
    int repIndex;
    int numbers[MAX_NUMS];
    int repeats[MAX_NUMS];
    // get numbers from user
    printf("Enter %d numbers.\n", MAX_NUMS);
    for (int index = 0; index < MAX_NUMS ; index++) {
        printf("Input number %d: ", index+1);
        scanf("%d", &numbers[index]);
    }
    for (int index = 0; index < MAX_NUMS ; index++) {
        repeats[index] = -1;
        for (repIndex = 0; repIndex < MAX_NUMS ; repIndex++){
            if (numbers[repIndex] == numbers[index]) {
                repeats[index] ++;
            }
        }
    }
    
    printf("Original list: ");
    for (int index = 0; index < MAX_NUMS; index++) {
        printf("%d ", numbers[index]);
    }

    printf("\nFiltered list: ");
    filter_duplicates(numbers, repeats);
    for (int index = 0; index < MAX_NUMS; index++) {
        if (numbers[index] != -1) {
            printf("%d ", numbers[index]);
        }
    }
}