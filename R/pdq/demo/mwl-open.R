# mwl-open.r
# Created by NJG on Sunday, February 24, 2013
#
# Multiclass workload model with a single server.
# I don't have this example in either the PPA book or the Perl::PDQ book.
# The parameters are taken the Client/Server model in Chap. 8 of PPA book.
# http://www.perfdynamics.com/iBook/ppa.html
# See also ~/pdq-qnm-pkg/examples/ppa_1998/chap8/baseline.rpt
#
# The particular node modeled here is the File Server handling all 6 client streams.
# There are 3 request streams from an individual PC and 3 other streams coming 
# from the aggregated background due to the other 124 PCs on the network.
#
# $Id$

library(pdq)

Init("Multiclass File Server")
SetComment("This model is based on the FS node in Chap. 8 of PPA book")

CreateNode("FileSvr", CEN, FCFS)

# Arrival (or throughput) rates from the PPA PDQ Report are:-
# Throughput      FSERVR       CatDisplay       0.0667   Trans/Sec
# Throughput      FSERVR       RemotQuote       0.1333   Trans/Sec
# Throughput      FSERVR       StatUpdate       0.0167   Trans/Sec
# Throughput      FSERVR       CatDispAgg       8.2667   Trans/Sec
# Throughput      FSERVR       RemQuotAgg      16.5333   Trans/Sec
# Throughput      FSERVR       StatUpdAgg       2.0667   Trans/Sec
# Collect in the following vector
Xk <- c(0.0667,0.1333,0.0167,8.2667,16.5333,2.0667)

# Service demands from the PPA PDQ Report are:-
#   1  FCFS  FSERVR     CatDisplay Open      0.0055
#   1  FCFS  FSERVR     RemotQuote Open      0.0043
#   1  FCFS  FSERVR     StatUpdate Open      0.0011
#   1  FCFS  FSERVR     CatDispAgg Open      0.0055
#   1  FCFS  FSERVR     RemQuotAgg Open      0.0043
#   1  FCFS  FSERVR     StatUpdAgg Open      0.0011
# Collect in the following vector
Dk <- c(0.0055,0.0043,0.0011,0.0055,0.0043,0.0011)

wname <- c("CatDisplay", "RemotQuote", "StatUpdate", "CatDispAgg", "RemQuotAgg", "StatUpdAgg")

# Create the workloads and set service times
for(w in 1:length(Dk)) {
	CreateOpen(wname[w], Xk[w])
	SetDemand("FileSvr", wname[w], Dk[w]) 
}

Solve(CANON)
Report()

# For comparison, the individual utilizations should be:-
# Utilization     FSERVR       CatDisplay       0.0366   Percent
# Utilization     FSERVR       RemotQuote       0.0569   Percent
# Utilization     FSERVR       StatUpdate       0.0018   Percent
# Utilization     FSERVR       CatDispAgg       4.5366   Percent
# Utilization     FSERVR       RemQuotAgg       7.0569   Percent
# Utilization     FSERVR       StatUpdAgg       0.2268   Percent
# and the total utilization of the File Server is 11.92%


