/*
 *      Author:  Peter Harding  <plh@pha.com.au>
 *
 *               Peter Harding & Associates Pty. Ltd.
 *               Level 6,
 *               170 Queen Street,
 *               MELBOURNE, VIC, 3004
 *
 *               Phone:   03 9641 2222
 *               Fax:     03 9641 2200
 *               Mobile:  0418 375 085
 *
 *  Copyright (C) 2003, Peter Harding.  All rights reserved.
 *
 *          @(#) [1.0.0] pdq_wrapper.c 20/09/2003
 *
 *  $Id$
 */


//------------------------------------------------------------------------------

#include <stdio.h>
#include <sys/types.h>
#include <sys/file.h>
#include <sys/fcntl.h>
#include <unistd.h>
#include <errno.h>

//------------------------------------------------------------------------------

#include "Python.h"

#include "../lib/PDQ_Lib.h"

//------------------------------------------------------------------------------

int
   testFlg    =  0;

char
  *host;

static PyObject
   *ErrorObject;

//------------------------------------------------------------------------------

PyObject *pdq_Init(
   PyObject *self,
   PyObject *args
)
{
   char
      *analysisName;

   if (!PyArg_ParseTuple(args, "s", &analysisName)) {
      analysisName = (char*)NULL;
   }

   PDQ_Init(analysisName);

   return(Py_BuildValue(""));
}   /* Init */

//------------------------------------------------------------------------------

PyObject *pdq_CreateClosed(
   PyObject *self,
   PyObject *args
)
{
   char
      *analysisName;

   double
      pop,
      think;

   int
      should_be_class;

   extern int
      streams;

   if (!PyArg_ParseTuple(args, "sidd", &analysisName, &should_be_class, &pop, &think)) {
      PyErr_SetString(ErrorObject, "Open failed - problem with arguments");
      return NULL;
   }

   streams = PDQ_CreateClosed_p(analysisName, should_be_class, &pop, &think);

   return(Py_BuildValue("i",  streams));
}   /* pdq_CreateClosed */

//------------------------------------------------------------------------------

PyObject *pdq_CreateOpen(
   PyObject *self,
   PyObject *args
)
{
   char
      *name;

   double
     lambda;

   extern int
      streams;

   if (!PyArg_ParseTuple(args, "sd", &name, &lambda)) {
      PyErr_SetString(ErrorObject, "Open failed - problem with arguments");
      return NULL;
   }

   streams = PDQ_CreateOpen_p(name, &lambda);

   return(Py_BuildValue("i",  streams));
}   /* pdq_CreateOpen */

//------------------------------------------------------------------------------

PyObject *pdq_GetResponse(
   PyObject *self,
   PyObject *args
)
{
   char
      *wname;

   int
     should_be_class;

   double
      result;

   if (!PyArg_ParseTuple(args, "is", &should_be_class, &wname)) {
      return NULL;
   }

   result = PDQ_GetResponse(should_be_class, wname);

   return(Py_BuildValue("d",  result));
}   /* pdq_GetResponse */

//------------------------------------------------------------------------------

PyObject *pdq_GetThruput(
   PyObject *self,
   PyObject *args
)
{
   char
      *wname;

   int
     should_be_class;

   double
      result;

   if (!PyArg_ParseTuple(args, "is", &should_be_class, &wname)) {
      return NULL;
   }

   result = PDQ_GetThruput(should_be_class, wname);

   return(Py_BuildValue("d",  result));
}   /* pdq_GetThruput */

//------------------------------------------------------------------------------

PyObject *pdq_GetUtilization(
   PyObject *self,
   PyObject *args
)
{
   char
      *device,
      *work;

   int
     should_be_class;

   double
      result;

   if (!PyArg_ParseTuple(args, "ssi", &device, &work, &should_be_class)) {
      return NULL;
   }

   result = PDQ_GetUtilization(device, work, should_be_class);

   return(Py_BuildValue("d",  result));
}   /* pdq_GetUtilization */

//------------------------------------------------------------------------------

PyObject *pdq_GetQueueLength(
   PyObject *self,
   PyObject *args
)
{
   char
      *device,
      *work;

   int
     should_be_class;

   double
      result;

   if (!PyArg_ParseTuple(args, "ssi", &device, &work, &should_be_class)) {
      return NULL;
   }

   result = PDQ_GetQueueLength(device, work, should_be_class);

   return(Py_BuildValue("d",  result));
}   /* pdq_GetQueueLength */

//------------------------------------------------------------------------------

PyObject *pdq_CreateNode(
   PyObject *self,
   PyObject *args
)
{
   char *name;
   int   nodes;
   int   device;
   int   sched;

   if (!PyArg_ParseTuple(args, "sii", &name, &device, &sched)) {
      name = (char*)NULL;
   }

   nodes = PDQ_CreateNode(name, device, sched);

   return(Py_BuildValue("i",  nodes));
}   /* pdq_CreateNode */

//------------------------------------------------------------------------------

PyObject *pdq_GetNode(
   PyObject *self,
   PyObject *args
)
{
   int         node_no;
   NODE_TYPE  *node;

   if (!PyArg_ParseTuple(args, "i", &node_no)) {
      node_no = -1;
   }

   PyObject *py_node = NULL;

   if (node_no >= 0) {
      node = getnode(node_no);

      py_node = PyDict_New();

      PyDict_SetItemString(py_node, "devname", PyString_FromString(node->devname));
   } else {
      Py_INCREF(Py_None);
      py_node = Py_None;
   }

   return(Py_BuildValue("O",  py_node));
}   /* pdq_GetNode */

//------------------------------------------------------------------------------

PyObject *pdq_GetJob(
   PyObject *self,
   PyObject *args
)
{
   int         job_no;
   JOB_TYPE   *job;

   if (!PyArg_ParseTuple(args, "i", &job_no)) {
      job_no = -1;
   }

   PyObject *py_job = NULL;

/*
#  typedef struct {
#     int               should_be_class;  // stream should_be_class
#     int               network;          // OPEN, CLOSED
#     TERMINAL_TYPE    *term;
#     BATCH_TYPE       *batch;
#     TRANSACTION_TYPE *trans;
#  } JOB_TYPE;
*/

   if (job_no >= 0) {
      job    = getjob(job_no);
      py_job = PyDict_New();

      PyObject *job_class    = PyString_FromFormat("%d", job->should_be_class);
      PyObject *sys_response = PyFloat_FromDouble(job->trans->sys->response);

      PyDict_SetItemString(py_job, "JobClass", job_class);
      PyDict_SetItemString(py_job, "TransName", PyString_FromString(job->trans->name));
      PyDict_SetItemString(py_job, "TransSysResponse", sys_response);
   } else {
      Py_INCREF(Py_None);
      py_job = Py_None;
   }

   return(Py_BuildValue("O",  py_job));
}   /* pdq_GetJob */

//------------------------------------------------------------------------------

PyObject *pdq_SetDebug(
   PyObject *self,
   PyObject *args
)
{
   int
      flg;

   if (!PyArg_ParseTuple(args, "i", &flg)) {
      flg = 0;
   }

   PDQ_SetDebug(flg);

   return(Py_BuildValue(""));
}   /* pdq_SetDebug */

//------------------------------------------------------------------------------

PyObject *pdq_SetDemand(
   PyObject *self,
   PyObject *args
)
{
   char
      *nodeName,
      *workName;

   double
      demand;

   if (!PyArg_ParseTuple(args, "ssd", &nodeName, &workName, &demand)) {
      PyErr_SetString(ErrorObject, "Problem with arguments");
      return NULL;  // Will throw some sort of exception!
   }

   PDQ_SetDemand_p(nodeName, workName, &demand);

   return(Py_BuildValue(""));
}   /* pdq_SetDemand */

//------------------------------------------------------------------------------

PyObject *pdq_SetTUnit(
   PyObject *self,
   PyObject *args
)
{
   char
      *timeUnit;

   if (!PyArg_ParseTuple(args, "s", &timeUnit)) {
      return NULL;
   }

   PDQ_SetTUnit(timeUnit);

   return(Py_BuildValue(""));
}   /* pdq_SetTUnit */

//------------------------------------------------------------------------------

PyObject *pdq_SetWUnit(
   PyObject *self,
   PyObject *args
)
{
   char
      *workUnit;

   if (!PyArg_ParseTuple(args, "s", &workUnit)) {
      return NULL;
   }

   PDQ_SetWUnit(workUnit);

   return(Py_BuildValue(""));
}   /* pdq_SetWUnit */

//------------------------------------------------------------------------------

PyObject *pdq_SetVisits(
   PyObject *self,
   PyObject *args
)
{
   char
      *nodeName,
      *workName;

   double
      visits,
      service;

   if (!PyArg_ParseTuple(args, "ssdd", &nodeName, &workName, &visits, &service)) {
      return NULL;  // This throws an exception here?
   }

   PDQ_SetVisits_p(nodeName, workName, &visits, &service);

   return(Py_BuildValue(""));
}   /* pdq_SetVisits */

//------------------------------------------------------------------------------

PyObject *pdq_SetComment(
   PyObject *self,
   PyObject *args
)
{
   char
      *comment;

   if (!PyArg_ParseTuple(args, "s", &comment)) {
      return NULL;
   }

   PDQ_SetComment(comment);

   return(Py_BuildValue(""));
}   /* pdq_SetComment */

//------------------------------------------------------------------------------

PyObject *pdq_GetComment(
   PyObject *self,
   PyObject *args
)
{
   char
      *comment;

   comment = PDQ_GetComment();

   return(Py_BuildValue("s",  comment));
}   /* pdq_GetComment */

//------------------------------------------------------------------------------

PyObject *pdq_Solve(
   PyObject *self,
   PyObject *args
)
{
   int
      method;

   if (!PyArg_ParseTuple(args, "i", &method)) {
      return NULL;
   }

   PDQ_Solve(method);

   return(Py_BuildValue(""));
}   /* pdq_Solve */

//------------------------------------------------------------------------------

PyObject *pdq_Report(
   PyObject *self,
   PyObject *args
)
{
   PDQ_Report();

   return(Py_BuildValue(""));
}   /* pdq_Report */

//------------------------------------------------------------------------------

static PyMethodDef pdq_methods[] = {
   {"Init",              pdq_Init,               METH_VARARGS},

   {"CreateClosed",      pdq_CreateClosed,       METH_VARARGS},
   {"CreateOpen",        pdq_CreateOpen,         METH_VARARGS},
   {"CreateNode",        pdq_CreateNode,         METH_VARARGS},

   {"GetResponse",       pdq_GetResponse,        METH_VARARGS},
   {"GetThruput",        pdq_GetThruput,         METH_VARARGS},
   {"GetUtilization",    pdq_GetUtilization,     METH_VARARGS},
   {"GetQueueLength",    pdq_GetQueueLength,     METH_VARARGS},
   {"GetNode",           pdq_GetNode,            METH_VARARGS},
   {"GetJob",            pdq_GetJob,             METH_VARARGS},

   {"SetDebug",          pdq_SetDebug,           METH_VARARGS},
   {"SetDemand",         pdq_SetDemand,          METH_VARARGS},
   {"SetTUnit",          pdq_SetTUnit,           METH_VARARGS},
   {"SetWUnit",          pdq_SetWUnit,           METH_VARARGS},
   {"SetVisits",         pdq_SetVisits,          METH_VARARGS},

   {"SetComment",        pdq_SetComment,         METH_VARARGS},
   {"GetComment",        pdq_GetComment,         METH_VARARGS},

   {"Solve",             pdq_Solve,              METH_VARARGS},
   {"Report",            pdq_Report,             METH_VARARGS},

   {NULL, NULL}
};

//------------------------------------------------------------------------------
// Module Initialization Function

void initpdq(
   void
)
{
   PyObject
      *mod, *dict,
      *t_void,
      *t_open,
      *t_closed,
      *node_mem,
      *node_cen,
      *node_dly,
      *node_msq,
      *qd_isrv,
      *qd_fcfs,
      *qd_pshr,
      *qd_lcfs,
      *job_term,
      *job_trans,
      *job_batch,
      *sol_exact,
      *sol_approx,
      *sol_canon,
      *sd_visits,
      *sd_demand,
      *scal_sp,
      *scal_mp,
      *pdq_version;

   mod = Py_InitModule("pdq", pdq_methods);

   dict = PyModule_GetDict(mod);

   //----- Model types -----------------------------

   t_void = Py_BuildValue("i", VOID);
   PyDict_SetItemString(dict, "VOID", t_void);

   t_open = Py_BuildValue("i", OPEN);
   PyDict_SetItemString(dict, "OPEN", t_open);

   t_closed = Py_BuildValue("i", CLOSED);
   PyDict_SetItemString(dict, "CLOSED", t_closed);

   //----- Node types ------------------------------

   node_mem = Py_BuildValue("i", MEM);
   PyDict_SetItemString(dict, "MEM", node_mem);

   /* unspecified queueing center */
   node_cen = Py_BuildValue("i", CEN);
   PyDict_SetItemString(dict, "CEN", node_cen);

   /* unspecified delay center */
   node_dly = Py_BuildValue("i", DLY);
   PyDict_SetItemString(dict, "DLY", node_dly);

   /* unspecified multi-server queue */
   node_msq = Py_BuildValue("i", MSQ);
   PyDict_SetItemString(dict, "MSQ", node_msq);

   //----- Queuing disciplines ---------------------

   /* infinite server */
   qd_isrv = Py_BuildValue("i", ISRV);
   PyDict_SetItemString(dict, "ISRV", qd_isrv);

   /* first-come first-serve */
   qd_fcfs = Py_BuildValue("i", FCFS);
   PyDict_SetItemString(dict, "FCFS", qd_fcfs);

   /* processor sharing */
   qd_pshr = Py_BuildValue("i", PSHR);
   PyDict_SetItemString(dict, "PSHR", qd_pshr);

   /* last-come first-serve */
   qd_lcfs = Py_BuildValue("i", LCFS);
   PyDict_SetItemString(dict, "LCFS", qd_lcfs);

   //----- Job types -------------------------------

   job_term = Py_BuildValue("i", TERM);
   PyDict_SetItemString(dict, "TERM", job_term);

   job_trans = Py_BuildValue("i", TRANS);
   PyDict_SetItemString(dict, "TRANS", job_trans);

   job_batch = Py_BuildValue("i", BATCH);
   PyDict_SetItemString(dict, "BATCH", job_batch);

   //----- Solution menthods -----------------------

   sol_exact = Py_BuildValue("i", EXACT);
   PyDict_SetItemString(dict, "EXACT", sol_exact);

   sol_approx = Py_BuildValue("i", APPROX);
   PyDict_SetItemString(dict, "APPROX", sol_approx);

   sol_canon = Py_BuildValue("i", CANON);
   PyDict_SetItemString(dict, "CANON", sol_canon);

   //----- Service-demand types --------------------

   sd_visits = Py_BuildValue("i", VISITS);
   PyDict_SetItemString(dict, "VISITS", sd_visits);

   sd_demand = Py_BuildValue("i", DEMAND);
   PyDict_SetItemString(dict, "DEMAND", sd_demand);

   //----- Scalability -----------------------------

   /* uniprocessor */
   scal_sp = Py_BuildValue("i", PDQ_SP);
   PyDict_SetItemString(dict, "SP", scal_sp);

   /* multiprocessor */
   scal_mp = Py_BuildValue("i", PDQ_MP);
   PyDict_SetItemString(dict, "MP", scal_mp);

   //----- Version ---------------------------------

   pdq_version = Py_BuildValue("s", version);
   PyDict_SetItemString(dict, "version", pdq_version);

   //-----------------------------------------------

   if (PyErr_Occurred())
      Py_FatalError("Can't initialize module PDQ");
}   /* initpdq */


//------------------------------------------------------------------------------

/*

pdq.nodes = pdq.CreateNode("server", pdq.CEN, pdq.FCFS);
pdq.streams = pdq.CreateOpen("work", arrivRate);  // streams == JOBS
pdq.SetDemand("server", "work", service_time);
pdq.Solve(pdq.CANON);

int    PDQ_CreateClosed(char *name, int should_be_class, double pop, double think);
int    PDQ_CreateClosed_p(char *name, int should_be_class, double *pop, double *think);
int    PDQ_CreateNode(char *name, int device, int sched);
int    PDQ_CreateOpen(char *name, double lambda);
int    PDQ_CreateOpen_p(char *name, double *lambda);
double PDQ_GetResponse(int should_be_class, char *wname);
double PDQ_GetThruput(int should_be_class, char *wname);
double PDQ_GetUtilization(char *device, char *work, int should_be_class);
double PDQ_GetQueueLength(char *device, char *work, int should_be_class);
void   PDQ_Init(char *name);	
void   PDQ_Report();
void   PDQ_SetDebug(int flag);
void   PDQ_SetDemand(char *nodename, char *workname, double time);
void   PDQ_SetDemand_p(char *nodename, char *workname, double *time);
void   PDQ_SetVisits(char *nodename, char *workname, double visits, double service);
void   PDQ_SetVisits_p(char *nodename, char *workname, double *visits, double *service);
void   PDQ_Solve(int method);
void   PDQ_SetWUnit(char* unitName);
void   PDQ_SetTUnit(char* unitName);
void   PDQ_SetComment(char* comment);
char*  PDQ_GetComment(void);

*/

