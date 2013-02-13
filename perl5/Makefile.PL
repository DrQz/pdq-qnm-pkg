#
# file : Makefile.PL
#
#  $Id$
#
my $os = $^O;

if ( $os =~ /MSWin/ )

  {

    $IMAGE_BASE='-Wl,--image-base,0x14080000';

  }

use ExtUtils::MakeMaker;
WriteMakefile(
   'FIRST_MAKEFILE' => 'Makefile',
   'NAME' => 'pdq',
   'VERSION' => '6.1.1',
   dynamic_lib=>{'OTHERLDFLAGS' => $IMAGE_BASE},
   'OBJECT' => 'MVA_Approx.o MVA_Canon.o MVA_Solve.o PDQ_Build.o PDQ_Exact.o PDQ_Globals.o PDQ_Report.o PDQ_Utils.o PDQ_MServer.o pdq_wrap.o'
);
