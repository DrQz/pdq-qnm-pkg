/*
 * PDQ_Globals.c
 * 
 * Copyright (c) 1995-2004 Performance Dynamics Company
 * 
 * Revised by NJG: 17:56:22  07-18-96
 * 
 *  $Id$
 */

#include "PDQ_Lib.h"

//-------------------------------------------------------------------------

char                model[MAXCHARS];  /* Model name */
char                wUnit[10];        /* Work unit string */
char                tUnit[10];        /* Time unit string */

int                 DEBUG              = FALSE;
int                 prev_init          = FALSE;
int                 demand_ext;
int                 nodes;
int                 streams;
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
char                Comment[MAXBUF];

NODE_TYPE          *node;
JOB_TYPE           *job;
TERMINAL_TYPE      *tm;
BATCH_TYPE         *bt;
TRANSACTION_TYPE   *tx;
SYSTAT_TYPE        *sys;

char                fname[MAXBUF];

//-------------------------------------------------------------------------

