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

Here is a simple PDQ model of a Call Center serving a single waiting-line of customers, written in Python:
```
#!/usr/bin/env python

import pdq

agents  = 4     # available to take calls
aRate   = 0.35  # customers per minute
sTime   = 10.0  # minutes per customer

pdq.Init("Call Center")
pdq.CreateMultiNode(agents, "Agents", pdq.CEN, pdq.FCFS)
pdq.CreateOpen("Customers", aRate)
pdq.SetDemand("Agents", "Customers", sTime)
pdq.SetWUnit("Customers")
pdq.SetTUnit("Minute")
pdq.Solve(pdq.CANON)
pdq.Report()
```
How long can a calling customer expect to wait to speak with an agent?  To answer that question, you simply run the PDQ model. 
All the resulting queueing metrics are displayed in a default format using the `Report()` function:
```
                        PRETTY DAMN QUICK REPORT         
               ==========================================
               ***  on  Mon Nov  9 06:06:34 PST 2020     ***
               ***  for  Call Center  model             ***
               ***  PDQ  Version 6.3.0 Build 110920   ***
               ==========================================

               ==========================================
               ********    PDQ Model INPUTS      ********
               ==========================================

WORKLOAD Parameters:

Node Sched Resource   Workload   Class     Demand
---- ----- --------   --------   -----     ------
  4  MSQ   Agents    Customers  Open     10.0000

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
Capacity        Agents      Customers             4   Servers
Throughput      Agents      Customers        0.3500   Customers/Minute
In service      Agents      Customers        3.5000   Customers
Utilization     Agents      Customers       87.5000   Percent
Queue length    Agents      Customers        8.6650   Customers
Waiting line    Agents      Customers        5.1650   Customers
Waiting time    Agents      Customers       14.7572   Minute
Residence time  Agents      Customers       24.7572   Minute
```
PDQ predicts the average customer waiting time will be 14.7572 minutes.

Optionally, you can create customized reports by retrieving [specific performance metrics](http://www.perfdynamics.com/Tools/PDQman.html) 
like, `GetUtilization()` or `GetThruput()`.

