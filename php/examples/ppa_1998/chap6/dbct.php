<?php
/*
 * dbc.c - Teradata DBC-10/12 performance model
 * 
 * PDQ calculation of optimal parallel configuration.
 *
 * PHP5 Translation by Samuel Zallocco - University of L'Aquila - ITALY
 * e-mail: samuel.zallocco@univaq.it
 *
 */

require_once "..\..\..\Lib\PDQ_Lib.php";

//-------------------------------------------------------------------------
function itoa($n, &$s)
{
    $s = (string) $n;
}  /* itoa */
//-------------------------------------------------------------------------

function main()
{
   global $nodes, $streams; // this are global to PDQ_Lib
   
   $k = 0; // Warning!! k is a global name in the PDQ_Lib!!!!
   $name = "";
   $nstr = "";

   /* input parameters */
   $think = 10.0;
   $users = 300; // 800;
   $Sifp = 0.10;
   $Samp = 0.60;
   $Sdsu = 1.20;
   $Nifp = 15;
   $Namp = 50;
   $Ndsu = 100;

   // PDQ_SetDebug(TRUE);
   PDQ_Init("Teradata DBC-10/12");

   /* Create parallel centers */

   for ($k = 0; $k < $Nifp; $k++) {
      itoa($k, $nstr);
      $name = "IFP".$nstr;
      $nodes = PDQ_CreateNode($name, CEN, FCFS);
   };

   for ($k = 0; $k < $Namp; $k++) {
      itoa($k, $nstr);
      $name = "AMP".$nstr;
      $nodes = PDQ_CreateNode($name, CEN, FCFS);
   };

   for ($k = 0; $k < $Ndsu; $k++) {
      itoa($k, $nstr);
      $name = "DSU".$nstr;
      $nodes = PDQ_CreateNode($name, CEN, FCFS);
   };

   $streams = PDQ_CreateClosed("query", TERM, (double)$users, $think);

   /*PDQ_SetGraph("query", 100); - unsupported call */

   for ($k = 0; $k < $Nifp; $k++) {
      itoa($k, $nstr);
      $name = "IFP".$nstr;
      PDQ_SetDemand($name, "query", $Sifp / $Nifp);
   };

   for ($k = 0; $k < $Namp; $k++) {
      itoa($k, $nstr);
      $name = "AMP".$nstr;
      PDQ_SetDemand($name, "query", $Samp / $Namp);
   };

   for ($k = 0; $k < $Ndsu; $k++) {
      itoa($k, $nstr);
      $name = "DSU".$nstr;
      PDQ_SetDemand($name, "query", $Sdsu / $Ndsu);
   };

   /* 300 nodes takes about a minute to solve on a PowerMac */

   printf("Solving ... ");

   PDQ_Solve(APPROX);

   printf("Done.\n");

   /* PDQ_PrintXLS(); */

   PDQ_Report();

}; // main

main();

?>