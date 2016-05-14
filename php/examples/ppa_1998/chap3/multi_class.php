<?php
/*
 * multi_class.php
 * 
 * Illustrate use of PDQ solver for multiclass workload.
 *
 * PHP5 Translation by Samuel Zallocco - University of L'Aquila - ITALY
 * e-mail: samuel.zallocco@univaq.it
 *
 */

require_once "..\..\..\Lib\PDQ_Lib.php";

//-------------------------------------------------------------------------

function main()
{

   /****************************
    * Model specific variables *
    ****************************/

   $noNodes = 0;
   $noStreams = 0;
   $tech = APPROX; // EXACT
   $pop = 0;
   $think = 0.0;

   /************************
    * Initialize the model *
    ************************/

   /* Give model a name */
   printf("**** %s ****:\n", $tech == EXACT ? "EXACT" : "APPROX");
   printf("%s\t\t%s\t\t%s\t\t%s\t\t%s\n","POP", "N:w1", "RESP:w1", "N:w2","RESP:w2");
   printf("-----------------------------------------------------------------------------\n");

   for ($pop = 1; $pop < 10; $pop++) {
      PDQ_Init("Test_Exact_calc");

      /* Define the workload and circuit type */
      $noStreams = PDQ_CreateClosed("w1", TERM, 1.0 * $pop, $think);
      $noStreams = PDQ_CreateClosed("w2", TERM, 1.0 * $pop, $think);

      /* Define the queueing center */
      $noNodes = PDQ_CreateNode("node", CEN, FCFS);

      /* Define service demand */
      PDQ_SetDemand("node", "w1", 1.0);
      PDQ_SetDemand("node", "w2", 0.5);

      /*******************
       * Solve the model *
       *******************/
      PDQ_Solve($tech);

      printf("%d\t\t%d\t\t%3.4f\t\t%d\t\t%3.4f\n",$pop, getjob_pop(getjob_index("w1")), PDQ_GetResponse(TERM, "w1"), getjob_pop(getjob_index("w1")), PDQ_GetResponse(TERM, "w2"));
   };

};// main

main();

?>