<?php
/*
 * shadowcpu.php
 *
 * Taken from p.254 of "Capacity Planning and Performance Modeling," 
 * by Menasce, Almeida, and Dowdy, Prentice-Hall, 1994. 
 *
 * PHP5 Translation by Samuel Zallocco - University of L'Aquila - ITALY
 * e-mail: samuel.zallocco@univaq.it
 *
 */

require_once "..\..\..\Lib\PDQ_Lib.php";

//-------------------------------------------------------------------------

define("PRIORITY", FALSE); // Turn priority on or off here


//-------------------------------------------------------------------------

function GetProdU() 
{
   $noNodes = 0;
   $noStreams = 0;

   PDQ_Init("");

   $noStreams = PDQ_CreateClosed("Production", TERM, 20.0, 20.0);
   $noNodes = PDQ_CreateNode("CPU", CEN, FCFS);
   $noNodes = PDQ_CreateNode("DK1", CEN, FCFS);
   $noNodes = PDQ_CreateNode("DK2", CEN, FCFS);

   PDQ_SetDemand("CPU", "Production", 0.30);
   PDQ_SetDemand("DK1", "Production", 0.08);
   PDQ_SetDemand("DK2", "Production", 0.10);

   PDQ_Solve(APPROX); 

   return(PDQ_GetUtilization("CPU", "Production", TERM));
}  // GetProdU

//-------------------------------------------------------------------------


function main()
{

   $noNodes = 0;
   $noStreams = 0;

   $noPri = "CPU Scheduler - No Pri";
   $priOn = "CPU Scheduler - Pri On";

   $Ucpu_prod = 0.0;

   if (PRIORITY) { 
   	$Ucpu_prod = GetProdU();
   };

   PDQ_Init(PRIORITY ? $priOn : $noPri);

   // workloads ...

   $noStreams = PDQ_CreateClosed("Production", TERM, 20.0, 20.0);
   $noStreams = PDQ_CreateClosed("Developmnt", TERM, 15.0, 15.0);

   // queueing noNodes ...

   $noNodes = PDQ_CreateNode("CPU", CEN, FCFS);

   if (PRIORITY) { 
   	$noNodes = PDQ_CreateNode("shadCPU", CEN, FCFS);
   };

   $noNodes = PDQ_CreateNode("DK1", CEN, FCFS);
   $noNodes = PDQ_CreateNode("DK2", CEN, FCFS);

   // service demands at each node ...

   PDQ_SetDemand("CPU", "Production", 0.30);

   if (PRIORITY) { 
   	PDQ_SetDemand("shadCPU", "Developmnt", 1.00/(1 - $Ucpu_prod));
   } else { 
   	PDQ_SetDemand("CPU", "Developmnt", 1.00);
   };

   PDQ_SetDemand("DK1", "Production", 0.08);
   PDQ_SetDemand("DK1", "Developmnt", 0.05);

   PDQ_SetDemand("DK2", "Production", 0.10);
   PDQ_SetDemand("DK2", "Developmnt", 0.06);

   // We use APPROX rather than EXACT to match the numbers in the book

   PDQ_Solve(APPROX); 

   PDQ_Report();
}; // main

main();

?>