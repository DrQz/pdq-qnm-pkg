/*
 * PDQ_MServer.c
 * 
 * Created by NJG on Mon, Apr 2, 2007
 *
 * A collection of subroutines to solve multi-server queues.
 * (only one function so far)
 * 		- ErlangR returns the residence for an M/M/m queue.
 *
 *  $Id$
 */
 
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h> 
#include "PDQ_Lib.h"
 
 
double 
ErlangR(double arrivrate, double servtime, int servers) {

	extern int        PDQ_DEBUG;
	extern char       s1[];
	extern JOB_TYPE  *job;

	double		erlangs;
	double		erlangB;
	double		erlangC;
	double		rho;
	double		eb;
	double		wtE;
	double		rtE;
	int		    mm;
	char        *p = "ErlangR()";

	
	erlangs  = arrivrate * servtime;
	
	if (erlangs >= servers) {
		sprintf(s1, "%4.2lf Erlangs saturates %d servers", erlangs, servers);
	    errmsg(p, s1);
	}
	
	rho     = erlangs / servers;
	erlangB = erlangs / (1.0 + erlangs);
	for (mm = 2; mm <= servers; mm++) {
		eb  = erlangB;
		erlangB = eb * erlangs / (mm + (eb * erlangs));
	}
	
	erlangC  = erlangB / (1.0 - rho + (rho * erlangB));
	
	wtE = servtime * erlangC / (servers * (1.0 - rho));
	rtE = servtime + wtE;
	
	if (PDQ_DEBUG) {
		sprintf(s1, "Erlang R: %6.4lf", rtE);
		errmsg(p, s1);
	}
	
	return(rtE);

} // ErlangR
