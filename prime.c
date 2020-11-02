/**
 * Author: Danilo C. Fuchs
 * Equivalent of program at ROM
 */

#include <stdio.h>

const int ARR_SIZE = 32;

int main(void) {
  int nums[ARR_SIZE + 1];

  for (int i = 1; i <= ARR_SIZE; i++) {
    nums[i] = 1;
  }

  for (int i = 4; i <= ARR_SIZE; i += 2) {
    nums[i] = 0;
  }

  for (int i = 9; i <= ARR_SIZE; i += 3) {
    nums[i] = 0;
  }

  for (int i = 25; i <= ARR_SIZE; i += 5) {
    nums[i] = 0;
  }

  for (int i = 2; i <= ARR_SIZE; i++) {
    printf("%d: %d\n", i, nums[i]);
  }

  return 0;
}