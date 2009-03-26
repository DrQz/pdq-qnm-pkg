#!/usr/bin/env perl
###############################################################################
#  Copyright (C) 1994 - 2009, Performance Dynamics Company                    #
#                                                                             #
#  This software is licensed as described in the file COPYING, which          #
#  you should have received as part of this distribution. The terms           #
#  are also available at http://www.perfdynamics.com/Tools/copyright.html.    #
#                                                                             #
#  You may opt to use, copy, modify, merge, publish, distribute and/or sell   #
#  copies of the Software, and permit persons to whom the Software is         #
#  furnished to do so, under the terms of the COPYING file.                   #
#                                                                             #
#  This software is distributed on an "AS IS" basis, WITHOUT WARRANTY OF ANY  #
#  KIND, either express or implied.                                           #
###############################################################################

#
#  $Id$
#

if ( $#ARGV != 0 ) {
   printf "Enter basename of file to convert (i.e. no extension!)\n";
   exit(0);
}

$file = $ARGV[0];

print $file;


@Vars = (
   "scenario",
   "FS_DISKS",
   "MF_DISKS",
   "PC_MIPS",
   "FS_MIPS",
   "GW_MIPS",
   "MF_MIPS",
   "TR_Mbps",
   "TR_fact",
   "MAXPROC",
   "MAXDEV",
   "CD_Req",
   "CD_Rpy",
   "RQ_Req",
   "RQ_Rpy",
   "SU_Req",
   "SU_Rpy",
   "Req_CD",
   "Req_RQ",
   "Req_SU",
   "CD_Msg",
   "RQ_Msg",
   "SU_Msg",
   "GT_Snd",
   "GT_Rcv",
   "MF_CD",
   "MF_RQ",
   "MF_SU",
   "LAN_Tx",
   "MIPS",
   "Mbps",
   "USERS",
   "PC",
   "FS",
   "GW",
   "MF",
   "TR",
   "FDA",
   "MDA",
   "CD",
   "RQ",
   "SU",
   "K",
   "DEBUG",
   "PCarray",
   "FDarray",
   "MDarray",
   "X",
   "demand",
   "dev",
   "i",
   "j",
   "job",
   "node",
   "nodes",
   "streams",
   "txCD",
   "txRQ",
   "txSU",
   "dumCD",
   "dumRQ",
   "dumSU",
   "udasd",
   "udsk",
   "ufs",
   "ugw",
   "ulan",
   "umf",
   "util",
   "uws",
   "work"
);

$c   = $file . ".c";
$pl  = $file . ".pl";
$tmp = $file . ".tmp";

open IN,  "<$c";
open OUT, ">$tmp";

printf OUT "#!/usr/bin/perl\n\nuse pdq;\n\n";

while (<IN>) {
   chop();

   $_ =~ s///;

   $_ =~ s/	/   /g;

   $_ =~ s/ *\/\*/# /g;
   $_ =~ s/^ *\*/# /g;
   $_ =~ s/ *\*\///g;

   $_ =~ s/\/\//# /g;

   $_ =~ s/PDQ_/pdq::/g;
   $_ =~ s/\bCEN\b/\$pdq::CEN/g;
   $_ =~ s/\bFCFS\b/\$pdq::FCFS/g;
   $_ =~ s/\bCANON\b/\$pdq::CANON/g;
   $_ =~ s/\bEXACT\b/\$pdq::EXACT/g;
   $_ =~ s/\bTRANS\b/\$pdq::TRANS/g;

   $_ =~ s/\(float\)//g;

   /#define/ && do {
      $_ =~ s/#define[ 	]*/\$/g;
      $_ =~ s/  *$//;
      $_ =~ s/  */	=   /;
      /#/ && do {
         $_ =~ s/  *#/;  #/;
      };
      $_ =~ s/$/;/;
   };


   if ($. > 88) {
      foreach $x (@Vars) {
         $_ =~ s/\b$x\b/\$$x/g;
      }

      #  These are from C structs!

      $_ =~ s/\.id/->{id}/g;
      $_ =~ s/\.label/->{label}/g;
   }

   /strcpy/ && do {
      $_ =~ s/strcpy\(//;
      $_ =~ s/\);/;/;
      $_ =~ s/, */  = /;
   };

   /strcmp/ && do {
      $_ =~ s/strcmp\(//;
      $_ =~ s/, */ == /;
      $_ =~ s/\) *== *0\)/\)/;
   };

   printf OUT "%s\n", $_;
}

close IN;
close OUT;

system("expand -t 20 $tmp > $pl");
system("/bin/rm $tmp");
system("chmod +x $pl");

