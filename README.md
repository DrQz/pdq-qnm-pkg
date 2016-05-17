# PDQ: Pretty Damn Quick 

PDQ is an analytic solver library for queueing-network models (QNM) of computer
systems, manufacturing systems, and data networks, that can be written
optionally in a variety of conventional programming languages (see below). 
Perl is the language used in the book 
[Analyzing Computer System Performance with Perl::PDQ](http://www.perfdynamics.com/iBook/ppa_new.html), 
which explains the fundamental queue-theoretic concepts with example PDQ models for 
computer performance analysis.

**Overview:**	[What is PDQ?](http://www.perfdynamics.com/Tools/PDQ.html)

**Languages:**	[C](https://en.wikibooks.org/wiki/C_Programming), 
[Perl](http://www.perfdynamics.com/Tools/PDQperl.html), 
[Python](http://www.perfdynamics.com/Tools/PDQpython.html), 
[R](http://www.perfdynamics.com/Tools/PDQ-R.html)

**Platforms:**	Linux, OS X, Windows

**Maintainers:** Neil Gunther and Paul Puglia

**Contributors:** Denny Chen, Phil Feller, Neil Gunther, Peter Harding, Paul Puglia

**License:** PDQ is distributed freely under the [MIT license](https://en.wikipedia.org/wiki/MIT_License#License_terms).

**Example:**

Here is a simple PDQ model of four bank tellers serving a single waiting-line of customers, 
written in the C language:
```C
#include <stdio.h>
#include "PDQ_Lib.h"

int main() {
    int tellers = 4;
    double aRate = 0.35;
    double sTime = 10.0;

    PDQ_Init("Bank Model");
    PDQ_CreateMultiNode(tellers, "Tellers", CEN, FCFS);
    PDQ_CreateOpen("Customers", aRate);
    PDQ_SetDemand("Tellers", "Customers", sTime);
    PDQ_SetWUnit("Customers");
    PDQ_SetTUnit("Minute");
    PDQ_Solve(CANON);
    PDQ_Report();
}
```
How long can a customer arriving at the bank expect to wait for a teller? Predicted performance metrics that result from solving a PDQ model can easily be displayed
using the generic `Report()` function:
```
                        PRETTY DAMN QUICK REPORT         
               ==========================================
               ***  on   Tue May 17 13:23:24 2016     ***
               ***  for  Bank Model                   ***
               ***  PDQ  Version 7.x.x Build 051116   ***
               ==========================================

               ==========================================
               ********    PDQ Model INPUTS      ********
               ==========================================

WORKLOAD Parameters:

Node Sched Resource   Workload   Class     Demand
---- ----- --------   --------   -----     ------
  4  MSQ   Tellers    Customers  Open     10.0000

Queueing Circuit Totals
Streams:   1
Nodes:     1

Arrivals       per Minute     Demand 
--------       --------     -------
Customers      0.3500       10.0000


               ==========================================
               ********   PDQ Model OUTPUTS      ********
               ==========================================

Solution Method: CANON

               ********   SYSTEM Performance     ********

Metric                     Value    Unit
------                     -----    ----
Workload: "Customers"
Number in system          8.6650    Customers
Mean throughput           0.3500    Customers/Minute
Response time            24.7572    Minute
Stretch factor            2.4757

Bounds Analysis:
Max throughput            0.4000    Customers/Minute
Min response             10.0000    Minute


               ********   RESOURCE Performance   ********

Metric          Resource     Work              Value   Unit
------          --------     ----              -----   ----
Capacity        Tellers      Customers             4   Servers
Throughput      Tellers      Customers        0.3500   Customers/Minute
In service      Tellers      Customers        3.5000   Customers
Utilization     Tellers      Customers       87.5000   Percent
Queue length    Tellers      Customers        8.6650   Customers
Waiting line    Tellers      Customers        5.1650   Customers
Waiting time    Tellers      Customers       14.7572   Minute
Residence time  Tellers      Customers       24.7572   Minute
```
Alternatively, customized reports can be created using [specific performance metrics](http://www.perfdynamics.com/Tools/PDQman.html) 
like, `GetUtilization()` or `GetThruput()`.

