/*******************************************************************************/
/*  Copyright (C) 1994 - 1996, Performance Dynamics Company                    */
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
 * repair.c
 * 
 * Exact solution for M/M/m/N/N repairmen model.
 * 
 * Created by NJG: 17:45:47  12-19-94 Updated by NJG: 16:45:35  02-26-96
 * 
 * $Id$
 */

//-------------------------------------------------------------------------

#include <stdio.h>
#include <stdlib.h>
#include <math.h>		/* needed for double types */

//-------------------------------------------------------------------------

int main(int argc, char *argv[])
{
   double          L;		/* mean number of broken machines in line */
   double          Q;		/* mean number of broken machines in
				 * system */
   double          R;		/* mean response time */
   double          S;		/* mean service time */
   double          U;		/* total mean utilization */
   double          rho;		/* per server utilization */
   double          W;		/* mean time waiting for repair */
   double          X;		/* mean throughput */
   double          Z;		/* mean time to failure (MTTF) */
   double          p;		/* temp variable for prob calc. */
   double          p0;		/* prob if zero breakdowns */

   long            m;		/* Number of servicemen */
   long            N;		/* Number of machines */
   long            k;		/* loop index */

#ifdef MAC
   argc = ccommand(&argv);
#endif

   if (argc < 5) {
      printf("Usage: %s m S N Z\n", *argv);
      exit(1);
   }
   m = atol(*++argv);
   S = atof(*++argv);
   N = atol(*++argv);
   Z = atof(*++argv);

   p = p0 = 1;
   L = 0;

   for (k = 1; k <= N; k++) {
      p *= (N - k + 1) * S / Z;

      if (k <= m) {
	 p /= k;
      } else {
	 p /= m;
      }
      p0 += p;

      if (k > m) {
	 L += p * (k - m);
      }
   }				/* loop */

   p0 = 1.0 / p0;
   L *= p0;
   W = L * (S + Z) / (N - L);
   R = W + S;
   X = N / (R + Z);
   U = X * S;
   rho = U / m;
   Q = X * R;

   printf("\n");
   printf("  M/M/%ld/%ld/%ld Repair Model\n", m, N, N);
   printf("  ----------------------------\n");
   printf("  Machine pop:      %4ld\n", N);
   printf("  MT to failure:    %9.4lf\n", Z);
   printf("  Service time:     %9.4lf\n", S);
   printf("  Breakage rate:    %9.4lf\n", 1 / Z);
   printf("  Service rate:     %9.4lf\n", 1 / S);
   printf("  Utilization:      %9.4lf\n", U);
   printf("  Per Server:       %9.4lf\n", rho);
   printf("  \n");
   printf("  No. in system:    %9.4lf\n", Q);
   printf("  No in service:    %9.4lf\n", U);
   printf("  No.  enqueued:    %9.4lf\n", Q - U);
   printf("  Waiting time:     %9.4lf\n", R - S);
   printf("  Throughput:       %9.4lf\n", X);
   printf("  Response time:    %9.4lf\n", R);
   printf("  Normalized RT:    %9.4lf\n", R / S);
   printf("  \n");

   return(0);
}  /* main */

//-------------------------------------------------------------------------

