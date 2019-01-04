/*******************************************************************************/
/*  Copyright (C) 1994 - 2019, Performance Dynamics Company                    */
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
 * PDQ_Globals.c
 * 
 * Revised by NJG: 17:56:22  07-18-96
 * Edited by NJG on Thursday, December 27, 2018  Added FESC submodel thruput sm_x[] 
 * 
 */

#include "PDQ_Lib.h"

//-------------------------------------------------------------------------

char                model[MAXCHARS];  /* Model name */
char                wUnit[10];        /* Work unit string */
char                tUnit[10];        /* Time unit string */

int                 PDQ_DEBUG          = FALSE;
int                 prev_init          = FALSE;
int                 demand_ext;
int                 nodes;
int                 streams;
int                 demands; // Set to 0 by Init() & 1 by SetDemand()
int                 iterations;
int                 method;
int                 memdata;
double              sumD;
double              tolerance;

/* temp string buffers  */

char                s1[MAXBUF];
char                s2[MAXBUF];
char                s3[MAXBUF];
char                s4[MAXBUF];
char                Comment[1024];

NODE_TYPE          *node;
JOB_TYPE           *job;
TERMINAL_TYPE      *tm;
BATCH_TYPE         *bt;
TRANSACTION_TYPE   *tx;
SYSTAT_TYPE        *sys;

char                fname[MAXBUF];



// Added by NJG on Thursday, December 27, 2018
double  sm_x[MAX_USERS + 1]; // FESC submodel thruput


//-------------------------------------------------------------------------

