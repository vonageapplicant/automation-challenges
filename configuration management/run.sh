#!/bin/bash
#
# Run puppet across all N number of linux systems
# Reports the number of systems from N that were successfully templated
# Reports the number of systems from N that failed to template


# Flags/syntax appropriate for your environment
LOCAL_PUPPET_OPTS="apply --verbose --modulepath /usr/share/puppet/modules"
TOTAL_COUNT=0
PUPPET_SUCCESS_COUNT=0
PUPPET_FAILED_COUNT=0
VALIDATE_PASS_COUNT=0
VALIDATE_FAIL_COUNT=0




function list_hosts() {
    # Implied site-specific magic to generate a listing of your host inventory
    echo "server1 server2 server3 server4 server5"
}


function run_puppet() {

    local target="$1"
    echo -n "Running puppet on ${target}... "
    puppet_command="puppet $LOCAL_PUPPET_OPTS --detailed-exit-codes >/dev/null 2>&1"

    ssh -q -l root $target "$puppet_command"
    local puppet_retval="$?"

    case $puppet_retval in
        0) (( PUPPET_SUCCESS_COUNT++ )) ; echo "success." ;;
        2) (( PUPPET_SUCCESS_COUNT++ )) ; echo "success." ;;
        4) (( PUPPET_FAILED_COUNT++  )) ; echo "failed."  ;;
        6) (( PUPPET_FAILED_COUNT++  )) ; echo "failed."  ;;
        *) (( PUPPET_FAILED_COUNT++  )) ; echo "failed."
    esac
}


function validate_widget() {

    local $target="$1"
    echo -n "Validating /etc/widgetfile on ${target}.... "
    validate_command='egrep -q "^[[:space:]]*widget_type[[:space:]]+$(facter -p widget)" /etc/widgetfile'

    ssh -q -l root $target "$validate_command"
    local validate_retval="$?"

    if [ "$validate_retval" == "0" ] ; then
        (( VALIDATE_PASS_COUNT++ ))
        echo "passed."
    else
        (( VALIDATE_FAIL_COUNT++ ))
        echo "failed."
    fi
}


for target_host in list_hosts ; do

    (( TOTAL_COUNT++ ))

    run_puppet $target_host

    validate_widget $target_host

done


echo "Attempted puppet runs on $TOTAL_COUNT systems."
echo "It completed successfully on $PUPPET_SUCCESS_COUNT of them, and failed on $PUPPET_FAILED_COUNT of them."
echo "The contents of /etc/widgetfile were validated as correct on $VALIDATE_PASS_COUNT systems, and as incorrect on $VALIDATE_FAIL_COUNT systems."

exit

