Instructions
============

In this directory is a file, "template.file". This file needs to be distributed to N systems, with the following portion replaced with dynamic content based on the contents of the output of the command 'facter -p widget' on the given target system:

    # Replace this
    widget_type X
    # ... with this:
    # widget_type (output from facter -p widget)

The included solution for deploying this file assumes the following:
* All target systems are managed by puppet, at least v2.7
* Infrastructure for puppet already exists
* Puppet generally works correctly on these systems
* Puppet is being invoked on demand, not running as a daemon
* The custom fact for "widget" already exists on all target systems
* The original requirement unintentionally requested a commented-out widget_type line

Included in the "widget" subdirectory is a simple puppet manifest that includes a single class "widget". This class accepts a parameter to specify the location of the output file, with a default value of /etc/widgetfile, and uses the value of the top-level variable "widget" as supplied by facter for later subsitution into a ruby template that populates this file.

Additionally, there is a shell script named "run.sh", which will:

* Across N number of linux systems (where N is a number from 0-positive infinity):
 * Run puppet to place the template file on the system in /etc/widgetfile with the appropriate portions of the file replaced with the actual widget value
* Reports the number of systems from N that were successfully templated
* Reports the number of systems from N that failed to template

This shell script assumes the following:
* It is being executed by a user that has ssh access to all remote systems as the root user using public key authentication
* There exists some shell command that will generate a list of all desired target systems
* The included puppet module has already been deployed to the target environment(s)

In addition to reporting success or failure of the puppet run, it invokes a validation step that directly examines the widget file for appropriate content.

