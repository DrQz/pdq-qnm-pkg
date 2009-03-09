library(pdq)

arrivRate    = 0.75
service_time = 1.0

#---- Initialize --------------------------------------------------------------

Init("OpenCircuit")
SetComment("A simple M/M/1 queue")

#---- Define the queueing center ----------------------------------------------

CreateNode("server", CEN, FCFS)

#---- Define the workload and circuit type ------------------------------------

CreateOpen("work", arrivRate)

SetWUnit("Customers")
SetTUnit("Seconds")

#---- Define service demand due to workload on the queueing center ------------

SetDemand("server", "work", service_time)

#---- Solve the model ---------------------------------------------------------
#  Must use the CANONical method for an open circuit

Solve(CANON)

#---- Generate a report -------------------------------------------------------

Report()
