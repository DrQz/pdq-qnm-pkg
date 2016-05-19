\begin{verbatim}
#! /usr/bin/perl
# groxq.pl

use pdq;

#------------------------- INPUTS ---------------------
$ArrivalRate = 3/4; # customers per second
$ServiceRate = 1.0; # customers per second
$SeviceTime  = 1/$ServiceRate;
$ServerName  = "Cashier";
$Workload    = "Customers";

#------------------------ PDQ Model -------------------
# Initialize PDQ internal variables
pdq::Init("Grocery Store Checkout");

# Change the units used by PDQ::Report()
pdq::SetWUnit("Cust");
pdq::SetTUnit("Sec");

# Create the PDQ service node (Cashier) 
$pdq::nodes = pdq::CreateNode($ServerName, $pdq::CEN, $pdq::FCFS);

# Create the PDQ workload with arrival rate
$pdq::streams = pdq::CreateOpen($Workload, $ArrivalRate);

# Define service rate per customer at the cashier
pdq::SetDemand($ServerName, $Workload, $SeviceTime);

#------------------------ OUTPUTS ---------------------
# Solve the PDQ model 
pdq::Solve($pdq::CANON);
pdq::Report(); # Generate a full PDQ report 
\end{verbatim}