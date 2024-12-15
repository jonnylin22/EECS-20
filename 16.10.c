/*** 16.10
Write a program to find the median of a set of numbers. 
Recall that the median is a number within the set in which half the numbers are larger and half are smaller. 
Hint: To perform this, you may need to sort the list first.
***/

#include <stdio.h>
#define MAX_SIZE 100

void InsertionSort(int list[], int size) {
    int unsorted;       // index marking beginning of unsorted part
    int sorted;         // index for sorted part
    int unsortedItem;   // temp value for moving value
    for (unsorted = 1; unsorted < size; unsorted++) {
        unsortedItem = list[unsorted];  // item to be inserted
        // working backwards, shift sorted values to the right
        // untill we reach the position of the new item
        for (sorted = unsorted - 1;
            (sorted >= 0) && (list[sorted] > unsortedItem); sorted--){
                list[sorted+1] = list[sorted];  //shift item to right
        }
        // after loop, sorted +1 is position where item should go
        list[sorted+1] = unsortedItem;
    }
}

int main(void) {
    printf("Enter a set of numbers (x) to quit:\n");
    int num;
    int index = 0;
    int numbers[MAX_SIZE];
    int count = 0;
    char ch;

    while ( (index<MAX_SIZE)  ) {
        printf("Num %d: ", index+1);
        if ( scanf("%d[^\n]\n", &num) == 1) {
            numbers[index] = num;       // append to list of numbers
            count++;
        } else {
            // scanf to an int failed, exit loop
            scanf(" %c", &ch);      // handle entered character
            if ( ((int)ch == 88) || ((int)ch == 120) ){ // if it matches X or x, break
                printf("%d items in list.\n", count );
                break;
            } else {
                printf("Ente 'X' to terminate.\n");
            }
        }
        index++;
    } 

    // done taking in input from list
    // copy numbers to resized list
    int sorted[count];
    for (int i = 0 ; i < count ; i ++) {
        sorted[i] = numbers[i];
    }
    InsertionSort(sorted, count);

    int location;
    float median;
    if (count % 2 == 0) {
        location = (count / 2) - 1;
        median = (sorted[location] + sorted[location+1]) / 2.0 ;
    } else {
        location = (count / 2) ;
        median = sorted[location];
    }

    printf("Sorted list is:\n");
    for (int i = 0 ; i < count ; i ++) {
        printf("%d ", sorted[i] );
    }
    printf("\nMedian is %.2f", median);
    
}