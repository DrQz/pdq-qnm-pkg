/*******************************************************************************/
/*  Copyright (C) 1994 - 2013, Performance Dynamics Company                    */
/*                                                                             */
/*  This software is licensed as described in the file COPYING, which          */
/*  you should have received as part of this distribution. The terms           */
/*  are also available at http://www.perfdynamics.com/Tools/copyright.html.    */
/*                                                                             */
/*  You may opt to use, copy, modify, merge, publish, distribute and/or sell   */
/*  copies of the Software, and permit persons to whom the Software is         */
/*  furnished to do so, under the terms of the COPYING file.                   */
/*                                                                             */
/*  This software is distributed on an "AS IS" basis, WITHOUT WARRANTY OF ANY  */
/*  KIND, either express or implied.                                           */
/*******************************************************************************/

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

