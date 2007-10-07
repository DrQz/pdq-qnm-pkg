<?php
/*
 * httpd.php
 * 
 * HTTP daemon performance model
 *
 * PHP5 Translation by Samuel Zallocco - University of L'Aquila - ITALY
 * e-mail: samuel.zallocco@univaq.it
 *
 */

require_once "..\..\..\Lib\PDQ_Lib.php";

//-------------------------------------------------------------------------

define("STRESS",0);
define("HOMEPG",1);
define("PREFORK",TRUE);

function main()
{
   global $job;

   /****************************
	* Model specific variables *
	****************************/

    $noNodes = 0;
	$noStreams = 0;
    $pop = 0;
    $servers = 2;
    $s = 0;
	$w = HOMEPG;

    $work = array(0 => "stress",1 => "homepg");
    
                  /* stress */   /* homepg */
    $time = array(0 => 0.0044,  1 => 0.0300 );

    $slave = array( 0 => "slave0", 
                         "slave1", 
                         "slave2", 
                         "slave3", 
                         "slave4", 
                         "slave5", 
                         "slave6", 
                         "slave7", 
                         "slave8",
	                     "slave9",
	                     "slave10",
	                     "slave11",
	                     "slave12",
	                     "slave13",
	                     "slave14",
	                     "slave15");



    if (PREFORK) {
	   printf("Pre-Fork Model under \"%s\" Load (m = %d)\n", ($w == STRESS) ? $work[STRESS] : $work[HOMEPG], $servers);
    } else {
	   printf("Forking  Model under \"%s\" Load \n",($w == STRESS) ? $work[STRESS] : $work[HOMEPG]);
    };

	printf("N\tX\tR\n");

	for ($pop = 1; $pop <= 10; $pop++) {

		PDQ_Init("HTTPd_Server");

		$noStreams = PDQ_CreateClosed($work[$w], TERM, 1.0 * $pop, 0.0);
		$noNodes = PDQ_CreateNode("master", CEN, FCFS);

        if (PREFORK) {
    		for ($s = 0; $s < $servers; $s++) {
    			$noNodes = PDQ_CreateNode($slave[$s], CEN, FCFS);
    		};

    		PDQ_SetDemand("master", $work[$w], 0.0109);

    		for ($s = 0; $s < $servers; $s++) {
    			PDQ_SetDemand($slave[$s], $work[$w], $time[$w] / $servers);
    		};
        } else {				/* FORKING */
    	   $noNodes = PDQ_CreateNode("forks", CEN, ISRV);
    	   PDQ_SetDemand("master", $work[$w], 0.0165);
    	   PDQ_SetDemand("forks", $work[$w], $time[$w]);
        };

    	PDQ_Solve(EXACT);

    	printf("%3.2f\t%3.4f\t%3.4f\n",getjob_pop(getjob_index($work[$w])),PDQ_GetThruput(TERM, $work[$w]),PDQ_GetResponse(TERM, $work[$w]));
   };

};  // main

main();

?>