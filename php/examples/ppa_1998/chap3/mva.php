<?php
/*
 * mva.php - Mean Value Analysis algorithm for single class workload
 *
 *
 * PHP5 Translation by Samuel Zallocco - University of L'Aquila - ITALY
 * e-mail: samuel.zallocco@univaq.it
 *
 */

//-------------------------------------------------------------------------

$D = array();   // service demand at center k
$R = array();   // residence time at center k
$Q = array();   // no. customers at center k
$Z = 0.0;       // think time (0 for batch system)
$K = 0;         // no. of queueing centers 
$N = 0;         // no. of customers

//-------------------------------------------------------------------------

function mva()
{
	$k = 0;
	$n = 0;
	$s = 0.0;
	$X = 0.0;
	global $K, $N, $R, $D, $Q, $Z;

	for ($k = 1; $k <= $K; $k++)
		$Q[$k] = 0.0;

	for ($n = 1; $n <= $N; $n++) {
		for ($k = 1; $k <= $K; $k++)
			$R[$k] = $D[$k] * (1.0 + $Q[$k]);

		$s = $Z;

		for ($k = 1; $k <= $K; $k++)
			$s += $R[$k];

		$X = (double) ($n / $s);

		for ($k = 1; $k <= $K; $k++)
			$Q[$k] = $X * $R[$k];
	};

	printf(" k     R[k]    Q[k]   U[k]\n");
	printf("-----------------------------\n");

	for ($k = 1; $k <= $K; $k++)
		printf("%2d%9.3f%7.3f%7.3f\n", $k, $R[$k], $Q[$k], $X * $D[$k]);
	printf("-----------------------------\n");

	printf("X = %7.4f, R = %9.3f\n", $X, (double) ($N / $X - $Z));
};  // mva

function gets(&$s)
{
  $ta = array();
  $s = "";
  
  $ta = fscanf(STDIN, "%s\n");
  $s = $ta[0];
  return $ta[0];
};

function atof($s)
{
    $f = (float) $s;
    return $f;
};

function atoi($s)
{
  $i = (integer) $s;
  return $i;
};

//-------------------------------------------------------------------------

// main

    $noNodes = 0;
    $noStreams = 0;
	$k = 0;
	$tinput = array();
	$input = "";

    printf("\nMean Value Analysis algorithm for single class workload\n");
	while(TRUE) {                
		printf("\n(Hit RETURN to exit) ");
		printf("Enter no. of centers (K): ");
		gets($input);
		if ($input == "")
		{
          break;
		} else {
			$K = atoi($input);
		};
		for ($k = 1; $k <= $K; $k++) {
			printf("Enter demand at center %d (D[%d]): ", $k, $k);
			gets($input);
			$D[$k] = atof($input);
		};
		printf("Enter think time (Z):");
		gets($input);
		$Z = atof($input);

		while (TRUE) {
			printf("\n(Hit RETURN to stop) ");
			printf("Enter no. of terminals (N): ");
			gets($input);
			if ($input == "") {
				break;
			} else {
				$N =atoi($input);
				mva();
			};
		};

	};

// main
?>