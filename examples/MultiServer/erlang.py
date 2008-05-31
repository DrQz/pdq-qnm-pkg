#! /usr/bin/env python
#
# erlang.py
#
# Created by NJG on Mon, Aug 27, 2007


def ErlangR(arate, stime, servers):
	"Calculate the exact response time for an M/M/m node"
	erlangs  = arate * stime
	if (erlangs >= servers):
		print "Error: %4.2f Erlangs > %d servers" % (erlangs, servers)
		sys.exit()

	rho     = erlangs / servers
	erlangB = erlangs / (1 + erlangs)
	
	for mm in range(2, servers+1):
		eb  = erlangB
		erlangB = eb * erlangs / (mm + (eb * erlangs))
	
	erlangC  = erlangB / (1 - rho + (rho * erlangB))	
	wtE = stime * erlangC / (servers * (1 - rho))
	rtE = stime + wtE	
	return(rtE)
	


