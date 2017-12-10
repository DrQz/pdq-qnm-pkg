bookstore.R
	This PDQ model uses TWO multi-server nodess in tandem:
	1. A delay center tp represent browsing time without queueing
	2. A checkout center that has a waiting line.

DBcluster.R
	This is a PDQ model of a parallel DSS database cluster.
	See PPDQ book http://www.perfdynamics.com/books.html
	Section 9.4.1 Parallel Query Cluster
	and Listing 9.2. Cluster model in PDQ

diskoptim.R
	An performance gem. 
	Optimizate the flow of IO requests between a fast and a slow disk.
	This code also produces a plot of the solution.

ebiz.R
	PDQ model of a 3-tier business application.
	See PPDQ book http://www.perfdynamics.com/books.html
	Section 12.4.4 Preliminary PDQ Model

httpd.R
	See PPDQ book http://www.perfdynamics.com/books.html
	Section 12.2.2 HTTP Analysis Using PDQ
	and Listing 12.3 httpd.pl

mm1.R
	Single server single open queue (waiting line).
	M/M/1 queue in PDQ. See PPDQ book
	http://www.perfdynamics.com/books.html
	Section 4.6.1 Single Cashier Queue
	Section 8.5.2 M/M/1 in PDQ

mm1n.R
	Single server single closed queue (waiting line).
	See PPDQ book http://www.perfdynamics.com/books.html
	Section 4.8 Limited Request (Closed) Queues

mmm.R
	Multiserver single open queue (waiting line). 
	M/M/m in PPDQ book http://www.perfdynamics.com/books.html
	Section 4.7 Multiserver Queue

moreq.R
	Plot thruput curves for closed QNM with fixed Z and more queues.
	cf. PDQ demo: 'morez.r'
	See PPDQ book http://www.perfdynamics.com/books.html
	Section 4.8 Limited Request (Closed) Queues

morez.R
	Plot thruput curves for closed QNM with fixed number of queues 
	while increasing think time Z. cf. PDQ demo: 'moreq.r'
	See PPDQ book http://www.perfdynamics.com/books.html
	Section 4.8 Limited Request (Closed) Queues.

passport.R
	This model is a Jackson network with feedback.
	See PPDQ book http://www.perfdynamics.com/books.html
	Section 5.5.4 Parallel Queues in Series
	and Listing 5.1. Passport renewal model

spamcan.R
	This simple M/M/4 model was developeat AOL.com and gave results 
	that were in surprisingly good agreement with monitored queue lengths.
	See PPDQ book http://www.perfdynamics.com/books.html
	Section 1.6 How Long Should My Queue Be?
	and Listing 1.1. Spam farm model in PDQ

vmware.R
	Share allocation performance model based on measurements
	of VMWare ESX Server 2 running the SPEC CPU2000 gzip benchmark on 
	a single physical CPU with each VM guest defaulted to 1000 shares.
	See PPDQ book http://www.perfdynamics.com/books.html
	Section 5.9.2 Fair-Share Scheduler
