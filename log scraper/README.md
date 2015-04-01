Instructions
============

In this directory there is an Apache logfile with several entries, "puppet_access_ssl.log". There is also a script named
"log_scraper.sh" which is something that will print to the screen:

* How many times the URL "/production/file_metadata/modules/ssh/sshd_config" was fetched
 * Of those requests, how many times the return code from Apache was not 200
* The total number of times Apache returned any code other than 200
* The total number of times that any IP address sent a PUT request to a path under "/dev/report/"
 * A breakdown of how many times such requests were made by IP address

This script takes one argument, that of a path to the logfile to be parsed.

Example output when run on the provided log file:

Requests for /production/file_metadata/modules/ssh/sshd_config: 6
Requests for /production/file_metadata/modules/ssh/sshd_config without a 200 response: 0
Total non-200 responses: 6
Total PUT requests for /dev/report/: 9
IP addresses that made PUT requests for /dev/report/:
10.80.174.42 (1 times)
10.101.3.205 (1 times)
10.204.211.99 (1 times)
10.80.146.96 (1 times)
10.39.111.203 (1 times)
10.114.199.41 (1 times)
10.204.150.156 (1 times)
10.34.89.138 (1 times)
10.80.58.67 (1 times)

