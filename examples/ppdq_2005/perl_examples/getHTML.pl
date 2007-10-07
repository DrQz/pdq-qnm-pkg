#! /usr/bin/perl
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
