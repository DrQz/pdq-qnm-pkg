/*******************************************************************************/
/*  Copyright (C) 1994 - 2015, Performance Dynamics Company                    */
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

/* 
 *	$Id$
 * 
 * mva.c - Mean Value Analysis algorithm for single class workload
 *
 */

#include <stdlib.h>
#include <stdio.h>
#include <math.h>

#define	MAXK	6		        // max. service centers + 1   
double          D[MAXK];        // service demand at center k
double          R[MAXK];        // residence time at center k
double          Q[MAXK];        // no. customers at center k
double          Z;              // think time (0 for batch system)
int             K;              // no. of queueing centers 
int             N;              // no. of customers


int main()
{
   int              noNodes;
   int              noStreams;
	int             k;
	char            input[8];
	double          atof();
	void			mva();

	while (1) {                
		printf("\n(Hit RETURN to exit)\n\n");
		printf("Enter no. of centers (K): ");
		gets(input);
		if (input[0] == '\0')
			break;
		else
			K = atoi(input);
		for (k = 1; k <= K; k++) {
			printf("Enter demand at center %d (D[%d]): ", k, k);
			gets(input);
			D[k] = atof(input);
		}
		printf("Enter think time (Z):");
		gets(input);
		Z = atof(input);

		while (1) {
			printf("\n(Hit RETURN to stop)\n");
			printf("Enter no. of terminals (N): ");
			gets(input);
			if (input[0] == '\0')
				break;
			else {
				N = atoi(input);
				mva();
			}
		}

	}

   return(0);
}  


void mva()
{
	int             k;
	int             n;
	double          s;
	double          X;

	for (k = 1; k <= K; k++)
		Q[k] = 0.0;

	for (n = 1; n <= N; n++) {
		for (k = 1; k <= K; k++)
			R[k] = D[k] * (1.0 + Q[k]);

		s = Z;

		for (k = 1; k <= K; k++)
			s += R[k];

		X = (double) n / s;

		for (k = 1; k <= K; k++)
			Q[k] = X * R[k];
	}

	printf(" k     Rk      Qk     Uk\n");

	for (k = 1; k <= K; k++)
		printf("%2d%9.3f%7.3f%7.3f\n", k, R[k], Q[k], X * D[k]);

	printf("\nX = %7.4f, R = %9.3f\n", X, (double) N / X - Z);
}  


