/*** 16.9 
A program to remove any duplicates from a sequence of numbers. 
For example, if the list consisted of the numbers 5, 4, 5, 5, and 3, 
the program would output 5, 4, 3. ***/

#include <stdio.h>
#define MAX_NUMS 10

void InsertionSort(int list[], int size) {
    int unsorted; // index marking beginning of unsorted part
    int sorted; // index for sorted part
    int unsortedItem; // temp value for moving value
    for (unsorted = 1; unsorted < size; unsorted++) {
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

int filter_duplicates(int numbers[], int size) {
    int filtered[MAX_NUMS];   
    int len_filtered = 0;
    
    for (int index = 0 ; index < size ; index ++) {
        int is_duplicate = 0;
        for (int i = 0 ; i < len_filtered ; i ++ ) {
            if (numbers[index] == filtered[i]) {  
                is_duplicate = 1;        // if a match is found, set to -1
                break;
            } 
        }
        if (!is_duplicate) {
            filtered[len_filtered++] = numbers[index];
        } 
    }

    //copy filtered list back to original array
    for (int i = 0; i < len_filtered ; i ++) {
        numbers[i] = filtered[i];
    }
    return len_filtered;    // return new size of array
}

int main(void){
    int numbers[MAX_NUMS];

    // get numbers from user
    printf("Enter %d numbers.\n", MAX_NUMS);
    for (int index = 0; index < MAX_NUMS ; index++) {
        printf("Input number %d: ", index+1);
        scanf("%d", &numbers[index]);
    }
    
    // Display original list
    printf("Original list: ");
    for (int index = 0; index < MAX_NUMS; index++) {
        printf("%d ", numbers[index]);
    }

    // Filter duplicates and get new size
    int new_size = filter_duplicates(numbers, MAX_NUMS);
    // Sort filitered list
    InsertionSort(numbers, new_size);
    printf("\nFiltered list: ");
    for (int index = 0; index < new_size; index++) {
        printf("%d ", numbers[index]);
    }
    printf("\n");
    
    return 0;
}