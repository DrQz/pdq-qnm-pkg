// burncpu.c

#include<stdio.h>
#include<stdlib.h>
#include<math.h>

#define MAXARRAY    100
long int        m[MAXARRAY];
double          a[MAXARRAY];

//--------------------------------------------------------------------

int main(void) {
  int             i;
  void            StuffMatrices();
  StuffMatrices();
  for (i = 0; i < MAXARRAY; i++) {
    a[i] = a[100 - i] * m[i];
    if (i == MAXARRAY - 1) {
      i = 0;
    }
  }

  return(0);
}   // end of main

//--------------------------------------------------------------------

void StuffMatrices () {
  int             k;
  for (k = 0; k < MAXARRAY; k++) {
    a[k] = (double) random ();
    m[k] = random ();
  }  
}   //end of StuffMatrices

//--------------------------------------------------------------------

