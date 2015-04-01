#!/bin/bash
#
# Apache log file analysis script for Vonage.
# Provide the path to the log file to be analyzed as its single arg.


set -e


if [ -z "$1" ] ; then
    echo "USAGE: $0 <logfile>"
    exit 1
else
    logfile="$1"
fi


gawk '
BEGIN {
    uri1                        = "/production/file_metadata/modules/ssh/sshd_config";
    uri1_count                  = 0;
    uri1_not_200_count          = 0;
    uri2                        = "/dev/report/";
    uri2_count                  = 0;
    all_responses_not_200_count = 0;
}

{
    # Basic log format:
    # 10.39.111.203 - - [05/Nov/2013:19:52:21 +0000] "PUT /dev/report/ec2-54-211-240-78.compute-1.amazonaws.com HTTP/1.1" 200 33 "-" "-"
    ip       = $1;
    method   = $6;
    uri      = $7;
    response = $9;

    gsub("\"", "", method);     # Strip quotation mark from HTTP method
    gsub("?.*$", "", uri);      # Strip query string from requested URI
    
    # How many times the URL "/production/file_metadata/modules/ssh/sshd_config" was fetched
    #   Of those requests, how many times the return code from Apache was not 200
    if( uri == uri1 ) {
        uri1_count++;
        if( response != "200" ) { uri1_not_200_count++; }
    }

    # The total number of times Apache returned any code other than 200
    if( response != "200" ) { all_responses_not_200_count++; }

    # The total number of times that any IP address sent a PUT request to a path under "/dev/report/"
    #   A breakdown of how many times such requests were made by IP address
    if( (method == "PUT") && ( match(uri, uri2 )) ) {
        ip_uri2_array[$1]++;
        uri2_count++;
    }

} 

END {
    print "Requests for " uri1 ": " uri1_count;
    print "Requests for " uri1 " without a 200 response: " uri1_not_200_count;
    print "Total non-200 responses: " all_responses_not_200_count;
    print "Total PUT requests for " uri2 ": " uri2_count;
    print "IP addresses that made PUT requests for " uri2 ":";
    for ( ip in ip_uri2_array ) { print ip " (" ip_uri2_array[ip] " times)"; }
}
' "$logfile"

