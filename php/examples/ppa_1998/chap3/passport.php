<?php
/*
 * passport.php
 * 
 * Illustration of an open queueing circuit with feedback.
 *
 * PHP5 Translation by Samuel Zallocco - University of L'Aquila - ITALY
 * e-mail: samuel.zallocco@univaq.it
 *
 */

require_once "..\..\..\Lib\PDQ_Lib.php";

//-------------------------------------------------------------------------

function main()
{
    $noNodes = 0;
    $noStreams = 0;
    // the following is defined in the original C version but never used.
    $arrivals = 16.0 / 3600;	/* 16 applications per hour */

   /* Branching probabilities and weights */

   $p12 = 0.30;
   $p13 = 0.70;
   $p23 = 0.20;
   $p32 = 0.10;

   $w3 = ($p13 + $p23 * $p12) / (1 - $p23 * $p32);
   $w2 = $p12 + $p32 * $w3;

   /* Initialize and solve the model */

   PDQ_Init("Passport Office");

   $noStreams = PDQ_CreateOpen("Applicant", 0.00427);

   $noNodes = PDQ_CreateNode("Window1", CEN, FCFS);
   $noNodes = PDQ_CreateNode("Window2", CEN, FCFS);
   $noNodes = PDQ_CreateNode("Window3", CEN, FCFS);
   $noNodes = PDQ_CreateNode("Window4", CEN, FCFS);

   PDQ_SetDemand("Window1", "Applicant", 20.0);
   PDQ_SetDemand("Window2", "Applicant", 600.0 * $w2);
   PDQ_SetDemand("Window3", "Applicant", 300.0 * $w3);
   PDQ_SetDemand("Window4", "Applicant", 60.0);

   PDQ_Solve(CANON);

   PDQ_Report();

}; // main

main();

?>