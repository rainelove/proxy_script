#!/bin/bash

############################################################################
# Author: ZhangBin                                                         #
# Department: Xuji Electrical Co.,Ltd. Protection and Automation System    #
# Branch After-sales Service Department                                    #
# Script Name: proxy.sh                                                    #
# Script Usage: In the integrated automation system of substations in some #
# area, in order to save and facilitate the management of IP addresses, at #
# this time , it is necessary to use the Second Area Data Gaeway Machine   #
# to proxy certain services in the station, such as fault recorder, prote- #
# ction information slave station, etc. This script is used to simplify    #
# the configure progress of NAT iptables regular.                          #
############################################################################


# read configuration file
proxy_dir="/usrdsk/CSU8000/update"

if test -f ${proxy_dir}/proxy.conf; then
    . ${proxy_dir}/proxy.conf
else
    echo Configuration File Not Exist!
fi

# use ifconfig to find all netcards in the system and their ip address
declare -A netcard_ip_map
ifconfig