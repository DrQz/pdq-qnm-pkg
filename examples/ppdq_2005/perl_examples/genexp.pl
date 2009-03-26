#! /usr/bin/perl 
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

# genexp.pl

$x = 1; # Seed the RNG

# Generate 20 EXP variates with mean = 5
for ($i = 1; $i <= 20; $i++) {
    printf("%2d\t%6.4f\n", $i, exp_variate(5.0));
}

sub exp_variate { 
# Return an exponential variate. 
# log == Ln in Perl.
    my ($mean) = @_;
    return(-log(rand_num() / $mean));
}

sub rand_num {
# Portable RNG
# Return a (pseudo) random number between 0.0 and 1.0
    use integer; 
    use constant ac =>      16807;  # Multiplier
    use constant mc => 2147483647;  # Modulus
    use constant qc =>     127773;  # m div a
    use constant rc =>       2836;  # m mod a
    my $x_div_q;                    # x divided by q
    my $x_mod_q;                    # x modulo q
    my $x_new;                      # New x value
    $x_div_q = $x / qc;
    $x_mod_q = $x % qc;
    $x_new = (ac * $x_mod_q) - (rc * $x_div_q);
    if ($x_new > 0) { $x = $x_new; }
    else { $x = $x_new + mc; }
    no integer;
    return($x / mc);
}
