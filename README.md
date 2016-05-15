# PDQ: Pretty Damn Quick 

PDQ is an analytic solver library for queueing-network models (QNM) of computer
systems, manufacturing systems, and data networks, that can be written
optionally in a variety of conventional programming languages (see below). 
Perl is the language used in the book 
[Analyzing Computer System Performance with Perl::PDQ](http://www.perfdynamics.com/iBook/ppa_new.html), 
which explains the fundamental concepts with example models for computer system performance.

Here is simple PDQ model of four bank tellers serving a single waiting-line of customers, 
written in the C language:
```C
#include <stdio.h>
#include "PDQ_Lib.h"

int main(void) {
	PDQ_Init("Bank Model");
	PDQ_CreateOpen("Customers", 0.75);
	PDQ_CreateMultiNode(4, "Tellers", CEN, FCFS);
	PDQ_SetDemand("Tellers", "Customers", 1.0);
	SetTUnit("Minutes");
	PDQ_Solve(CANON);
	PDQ_Report();   
}
```

Predicted performance metrics that result from solving a PDQ model can easily be displayed
using the generic `Report()` function:
```
                        PRETTY DAMN QUICK REPORT         
               ==========================================
               ***  on   Sat May 14 17:47:25 2016     ***
               ***  for  Bank Model                   ***
               ***  PDQ  Version 7.x.x Build 051116   ***
               ==========================================

               ==========================================
               ********    PDQ Model INPUTS      ********
               ==========================================

WORKLOAD Parameters:
Node Sched Resource   Workload   Class     Demand
---- ----- --------   --------   -----     ------
  4  MSQ   server     work       Open      1.0000

Queueing Circuit Totals
Streams:   1
Nodes:     1

Arrivals       per Sec       Demand 
--------       --------     -------
work           0.7500        1.0000

               ==========================================
               ********   PDQ Model OUTPUTS      ********
               ==========================================

Solution Method: CANON

               ********   SYSTEM Performance     ********

Metric                     Value    Unit
------                     -----    ----
Workload: "work"
Number in system          0.7518    Trans
Mean throughput           0.7500    Trans/Sec
Response time             1.0024    Sec
Stretch factor            1.0024

Bounds Analysis:
Max throughput            4.0000    Trans/Sec
Min response              1.0000    Sec


               ********   RESOURCE Performance   ********

Metric          Resource     Work              Value   Unit
------          --------     ----              -----   ----
Capacity        server       work                  4   Servers
Throughput      server       work             0.7500   Trans/Sec
In service      server       work             0.7500   Trans
Utilization     server       work            18.7500   Percent
Queue length    server       work             0.7518   Trans
Waiting line    server       work             0.0018   Trans
Waiting time    server       work             0.0024   Sec
Residence time  server       work             1.0024   Sec
```

or creating customized reports based on 
[specific performance metrics](http://www.perfdynamics.com/Tools/PDQman.html) 
like, `GetUtilization()` or `GetThruput()`.

**Overview:**	[What is PDQ?](http://www.perfdynamics.com/Tools/PDQ.html)

**Languages:**	[C](https://en.wikibooks.org/wiki/C_Programming), 
[Perl](http://www.perfdynamics.com/Tools/PDQperl.html), 
[Python](http://www.perfdynamics.com/Tools/PDQpython.html), 
[R](http://www.perfdynamics.com/Tools/PDQ-R.html)

**Platforms:**	Linux, OS X, and Windows

**Maintainers:** Neil Gunther, Paul Puglia

**Contributors:** Denny Chen, Phil Feller, Neil Gunther, Peter Harding, Paul Puglia

