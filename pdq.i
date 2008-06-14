
/*
 * File : pdq.i
 *
 *  $Id$
 */

%module pdq

%{
#include "../lib/PDQ_Lib.h"
#include "../lib/PDQ_Global.h"
%}

/* Let's just grab the header file here */

%rename (CreateClosed)     PDQ_CreateClosed;
%rename (CreateClosed_p)   PDQ_CreateClosed_p;
%rename (CreateNode)       PDQ_CreateNode;
%rename (CreateOpen)       PDQ_CreateOpen;
%rename (CreateOpen_p)     PDQ_CreateOpen_p;
%rename (GetResponse)      PDQ_GetResponse;
%rename (GetThruput)       PDQ_GetThruput;
%rename (GetUtilization)   PDQ_GetUtilization;
%rename (GetQueueLength)   PDQ_GetQueueLength;
%rename (Init)             PDQ_Init;
%rename (Report)           PDQ_Report;
%rename (SetDebug)         PDQ_SetDebug;
%rename (SetDemand)        PDQ_SetDemand;
%rename (SetDemand_p)      PDQ_SetDemand_p;
%rename (SetVisits)        PDQ_SetVisits;
%rename (SetVisits_p)      PDQ_SetVisits_p;
%rename (Solve)            PDQ_Solve;
%rename (SetWUnit)         PDQ_SetWUnit;
%rename (SetTUnit)         PDQ_SetTUnit;
%rename (SetComment)       PDQ_SetComment;
%rename (GetComment)       PDQ_GetComment;
%rename (PrintNodes)       print_nodes;
%rename (GetNode)          getnode;
%rename (GetSteamsCount)   PDQ_GetSteamsCount;
%rename (GetNodesCount)    PDQ_GetNodesCount;

%include "../lib/PDQ_Lib.h"
%include "../lib/PDQ_Global.h"

