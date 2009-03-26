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

#
# getHTML.pl - fetch HTML from a URL 

use HTTP::Request::Common qw(GET);
use LWP::UserAgent;
use POSIX;

$url = "http://www.neilgunther.com/";

# Set up and issue the GET ...
my $ua = new LWP::UserAgent;
my $request = new HTTP::Request('GET',$url);
$request->content_type('application/x-www-form-urlencoded');
printf("%s\n", $request->as_string);

# Print the result ... 
my $result = $ua->request($request);  
if (!$result->is_success) { print $result->error_as_HTML; }
printf("%s\n", $result->as_string);
