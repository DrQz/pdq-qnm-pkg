# PDQ: Pretty Damn Quick 
## Version 6.3.0

This is a **development** repository. 
The current release, **PDQ 6.2.0**, has its 
own [repository](http://www.perfdynamics.com/Tools/PDQcode.html) with separate download and installation instructions.

PDQ is a library of functions for solving queueing-network models of 
systems of resources such as, distributed computer systems, manufacturing systems, 
and packet networks. 
PDQ models can be written optionally in a variety of conventional programming languages. 
The book [Analyzing Computer System Performance with Perl::PDQ](http://www.perfdynamics.com/iBook/ppa_new.html) 
presents example applications for computer system performance analysis written in Perl. 
Another example below is written in Python. 

**Overview:**	[What is PDQ?](http://www.perfdynamics.com/Tools/PDQ.html)

**Languages:**	[C](https://en.wikibooks.org/wiki/C_Programming), 
[Perl](http://www.perfdynamics.com/Tools/PDQperl.html), 
[Python](http://www.perfdynamics.com/Tools/PDQpython.html), 
[R](http://www.perfdynamics.com/Tools/PDQ-R.html)

**Platforms:**	Linux, MacOS, Windows

**Maintainers:** Neil Gunther and Paul Puglia

**Contributors:** Denny Chen, Phil Feller, Neil Gunther, Peter Harding, Paul Puglia, Sam Zallocco

**License:** PDQ is distributed as OSS under the [MIT license](https://en.wikipedia.org/wiki/MIT_License#License_terms).

**Synopsis:** [PDQ library functions](http://www.perfdynamics.com/Tools/PDQman.html)

**Examples:** See the `examples/` [directory](https://github.com/DrQz/pdq-qnm-pkg/tree/master/examples).

The following PDQ code, written in C, is a  model of an AWS cloud application that uses the new `CreateMultiserverClosed` function:

```C
#include <string.h> 
#include <stdio.h> 
#include <stdlib.h> 
#include <math.h>
#include "PDQ_Lib.h"  

int main(void) {

	int      threads;
	int      requests;
	float    stime;
	float    think;
	
	threads  = 350;
	stime    = 0.444;
	requests = 500;
	think    = 0.0;

	PDQ_Init("AWS Cloud Model");  
	
	PDQ_CreateClosed("Requests", TERM, requests, think); 
	PDQ_CreateMultiserverClosed(350, "Threads", MSC, FCFS); 
        PDQ_SetDemand("Threads", "Requests", stime); 
	PDQ_SetWUnit("Reqs");
	PDQ_SetTUnit("Sec");
	PDQ_Solve(EXACT);
	PDQ_Report();

} // end main
```

In this model, the 350 Tomcat threads play the role of queueing servers.

```
                        PRETTY DAMN QUICK REPORT         
               ==========================================
               ***  on   Fri Nov 13 10:24:00 2020     ***
               ***  for  AWS-Tomcat Cloud Model       ***
               ***  PDQ  Version 6.3.0 Build 111220   ***
               ==========================================

               ==========================================
               ********    PDQ Model INPUTS      ********
               ==========================================

WORKLOAD Parameters:

Node Sched Resource   Workload   Class     Demand
---- ----- --------   --------   -----     ------
MSC  FCFS  Threads    Requests   Closed    0.4440000057

Queueing Circuit Totals
Streams:   1
Nodes:     1


Client       Number        Demand   Thinktime
------       ------        ------   ---------
Requests     500.00        0.4440     0.00


               ==========================================
               ********   PDQ Model OUTPUTS      ********
               ==========================================

Solution Method: EXACT

               ********   SYSTEM Performance     ********

Metric                   Value      Unit
------                  -------     ----
Workload: "Requests"
Mean concurrency          0.0000    Reqs
Mean throughput         788.2883    Reqs/Sec
Response time             0.6343    Sec
Round trip time           0.6343    Sec
Stretch factor            1.4286

Bounds Analysis:
Max throughput            2.2523    Reqs/Sec
Min response              0.4440    Sec
Max demand                0.4440    Sec
Total demand              0.4440    Sec
Think time                0.0000    Sec
Optimal clients           1.0000    Clients


               ********   RESOURCE Performance   ********

Metric          Resource     Work               Value    Unit
------          --------     ----              -------   ----
Capacity        Threads      Requests              350   Servers
Throughput      Threads      Requests         788.2883   Reqs/Sec
In service      Threads      Requests      122500.0000   Reqs
Utilization     Threads      Requests       35000.0000   Percent
Queue length    Threads      Requests         500.0000   Reqs
Waiting line    Threads      Requests         150.0000   Reqs
Waiting time    Threads      Requests           0.1903   Sec
Residence time  Threads      Requests           0.6343   Sec
```

