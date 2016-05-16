# PDQ: Pretty Damn Quick 

PDQ is an analytic solver library for queueing-network models (QNM) of computer
systems, manufacturing systems, and data networks, that can be written
optionally in a variety of conventional programming languages (see below). 
Perl is the language used in the book 
[Analyzing Computer System Performance with Perl::PDQ](http://www.perfdynamics.com/iBook/ppa_new.html), 
which explains the fundamental queue-theoretic concepts with example PDQ models for computer system performance.

**Overview:**	[What is PDQ?](http://www.perfdynamics.com/Tools/PDQ.html)

**Languages:**	[C](https://en.wikibooks.org/wiki/C_Programming), 
[Perl](http://www.perfdynamics.com/Tools/PDQperl.html), 
[Python](http://www.perfdynamics.com/Tools/PDQpython.html), 
[R](http://www.perfdynamics.com/Tools/PDQ-R.html)

**Platforms:**	Linux, OS X, and Windows

**Maintainers:** Neil Gunther, Paul Puglia

**Contributors:** Denny Chen, Phil Feller, Neil Gunther, Peter Harding, Paul Puglia

**Copyright:** PDQ is distributed freely under the terms of the 
[MIT license](https://en.wikipedia.org/wiki/MIT_License#License_terms).

Here is a simple PDQ model of four bank tellers serving a single waiting-line of customers, 
written in the C language:
```C
#include <stdio.h>
#include "PDQ_Lib.h"

int main(void) {
	PDQ_Init("Bank Model");
	PDQ_CreateOpen("Customers", 0.75);
	PDQ_CreateMultiNode(4, "Tellers", CEN, FCFS);
	PDQ_SetDemand("Tellers", "Customers", 1.0);
	PDQ_SetWUnit("Customers");
	PDQ_SetTUnit("Minutes");
	PDQ_Solve(CANON);
	PDQ_Report();   
}
```
How long can a customer arriving at the bank expect to wait for a teller? Predicted performance metrics that result from solving a PDQ model can easily be displayed
using the generic `Report()` function:
```
                        PRETTY DAMN QUICK REPORT         
               ==========================================
               ***  on   Sat May 14 20:40:50 2016     ***
               ***  for  Bank Model                   ***
               ***  PDQ  Version 7.x.x Build 051116   ***
               ==========================================

               ==========================================
               ********    PDQ Model INPUTS      ********
               ==========================================

WORKLOAD Parameters:

Node Sched Resource   Workload   Class     Demand
---- ----- --------   --------   -----     ------
  4  MSQ   Tellers    Customers  Open      1.0000

Queueing Circuit Totals
Streams:   1
Nodes:     1

Arrivals       per Minute     Demand 
--------       --------     -------
Customers      0.7500        1.0000


               ==========================================
               ********   PDQ Model OUTPUTS      ********
               ==========================================

Solution Method: CANON

               ********   SYSTEM Performance     ********

Metric                     Value    Unit
------                     -----    ----
Workload: "Customers"
Number in system          0.7518    Customers
Mean throughput           0.7500    Customers/Minute
Response time             1.0024    Minute
Stretch factor            1.0024

Bounds Analysis:
Max throughput            4.0000    Customers/Minute
Min response              1.0000    Minute


               ********   RESOURCE Performance   ********

Metric          Resource     Work              Value   Unit
------          --------     ----              -----   ----
Capacity        Tellers      Customers             4   Servers
Throughput      Tellers      Customers        0.7500   Customers/Minute
In service      Tellers      Customers        0.7500   Customers
Utilization     Tellers      Customers       18.7500   Percent
Queue length    Tellers      Customers        0.7518   Customers
Waiting line    Tellers      Customers        0.0018   Customers
Waiting time    Tellers      Customers        0.0024   Minute
Residence time  Tellers      Customers        1.0024   Minute
```
Alternatively, customized reports can be created using [specific performance metrics](http://www.perfdynamics.com/Tools/PDQman.html) 
like, `GetUtilization()` or `GetThruput()`.

