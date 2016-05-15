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
using the generic `Report()` function or creating customized reports based on 
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

