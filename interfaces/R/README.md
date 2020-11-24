# What is PDQ-R
PDQ-R is an R package that allows R users to run pdq from inside the R statistics environment.
# Where Do I Get The Software
If you do not have R installed, you can download it from [CRAN](http://cran.r-project.org/)
Windows users can build PDQ-R need for the Windows version of R by downloading 
and installing Rtools for Windows.  This is also on [CRAN](http://cran.r-project.org/)

# Demos
This package includes the following demos which can be accessed via:

<code>demo(_demo_,package='pdq')
</code>

Where _demo_ can be one of the following:

* *bookstore*

	This PDQ model uses TWO multiserver nodess in tandem:  
	1. A delay center to represent browsing time without queueing
	2. A checkout center that has a single waiting line.

* *DBcluster*

	This is a PDQ model of a parallel DSS database cluster.
	See [PPDQ book](http://www.perfdynamics.com/books.html)
	Section 9.4.1 Parallel Query Cluster
	and Listing 9.2. Cluster model in PDQ

* *diskoptim*

	An performance gem. 
	Optimize the flow ratio of IO requests between a fast and a slow disk.
	This code also produces a plot of the solution.

* *ebiz*

	PDQ model of a 3-tier business application.
	See [PPDQ book](http://www.perfdynamics.com/books.html)
	Section 12.4.4 Preliminary PDQ Model

* *httpd*

	See [PPDQ book](http://www.perfdynamics.com/books.html)
	Section 12.2.2 HTTP Analysis Using PDQ
	and Listing 12.3 httpd.pl

* *mm1*

	Single server single open queue (waiting line).
	M/M/1 queue in PDQ. See [PPDQ book](http://www.perfdynamics.com/books.html)
	Section 4.6.1 Single Cashier Queue
	Section 8.5.2 M/M/1 in PDQ

* *mm1n*

	Single server single closed queue (waiting line).
	See [PPDQ book](http://www.perfdynamics.com/books.html)
	Section 4.8 Limited Request (Closed) Queues

* *mmm*

	Multiserver single open queue (waiting line). 
	M/M/m in [PPDQ book](http://www.perfdynamics.com/books.html)
	Section 4.7 Multiserver Queue

* *moreq*

	Plot thruput curves for closed QNM with fixed Z and more queues.
	cf. PDQ demo: 'morez.r'
	See [PPDQ book](http://www.perfdynamics.com/books.html)
	Section 4.8 Limited Request (Closed) Queues

* *morez*

	Plot thruput curves for closed QNM with fixed number of queues 
	while increasing think time Z. cf. PDQ demo: 'moreq.r'
	See [PPDQ book](http://www.perfdynamics.com/books.html)
	Section 4.8 Limited Request (Closed) Queues.

* *passport*

	This model is a Jackson network with feedback.
	See [PPDQ book](http://www.perfdynamics.com/books.html)
	Section 5.5.4 Parallel Queues in Series
	and Listing 5.1. Passport renewal model

* *spamcan*

	This simple M/M/4 model was developed at AOL.com and gave results 
	that were in surprisingly good agreement with monitored queue lengths.
	See [PPDQ book](http://www.perfdynamics.com/books.html)
	Section 1.6 How Long Should My Queue Be?
	and Listing 1.1. Spam farm model in PDQ

* *vmware*

	Share allocation performance model based on measurements
	of VMWare ESX Server 2 running the SPEC CPU2000 gzip benchmark on 
	a single physical CPU with each VM guest defaulted to 1000 shares.
	See [PPDQ book](http://www.perfdynamics.com/books.html)
	Section 5.9.2 Fair-Share Scheduler

* *allen*  

   Example of multiple workloads in CLOSED network.
   Based on Arnold Allen's book Example 6.3.4, p.413
   
* *multiwo*

  Example of multiple open workloads in PDQ 7.0
  Taken from Example 7.2 in QSP book p.138
   

