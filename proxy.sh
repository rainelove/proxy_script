#!/bin/bash

#######################################################################################
# Author: ZhangBin                                                                    #
# Department: Xuji Electrical Co.,Ltd. Protection and Automation System Branch After- #
# sales Service Department                                                            #
# Script Name: proxy.sh                                                               #
# Script Usage: In the integrated automation system of substations in some area, in   #
# order to save and facilitate the management of IP addresses, at this time, it is    #
# necessary to use the Second Area Data Gaeway Machine to proxy certain services in   #
# in the substation, such as fault recorder, protection information slave station,    #
# etc. This script is used to simplify the configure progress of NAT iptables regular.#
#######################################################################################


# read configuration file
proxy_dir="/usrdsk/CSU8000/update"

if test -f ${proxy_dir}/proxy.conf; then

    # filter legal argument line from configuration file by regular expression
    ip_addr_regx="(?:[0-9]{1,3}\.){3}[0-9]{1,3}:\d+"
    arg_regx="(tcp|upd),${ip_addr_regx},${ip_addr_regx}"

    for line in `grep -E ${arg_regx} ${proxy_dir}/proxy.conf | awk '{print $1}'`; do
        # prase all relate parameters from line
         IFS=',' read -r -a argument_array <<< "${line}"
         protocol=${argument_array[0]}
         outter_socket=${argument_array[1]}
         inner_socket=${argument_array[2]}
         IFS=':' read -r -a outter_parameter_array <<< "${outter_socket}"
         outter_ip=${outter_parameter_array[0]}
         outter_port=${outter_parameter_array[1]}
         IFS=':' read -r -a inner_parameter_array <<< "${outter_socket}"
         inner_ip=${inner_parameter_array[0]}
         inner_port=${inner_parameter_array[1]}

        # test port number is validate or not
        if [ "${inner_port}" -le "0" ] && [ "${inner_port}" -ge "65535" ]; then
            echo inner port number is not valid!
            exit -1
        fi
        if [ "{outter_port}" -le "0" ] && [ "outter_port" -ge "65535" ]; then
            echo outter port number is not valid!
            exit -1
        if

        # add iptables regular line by line
        iptables -t nat -A PREROUTING -d ${outter_ip} -p ${protocol} --dport ${outter_port} -j DNAT --to ${inner_socket}
        iptables -t nat -A POSTROUTING -s ${inner_ip} -p ${protocol} --sport ${inner_port} -j SNAT --to ${outter_ip}

    done
else
    echo Configuration File Not Exist!
    exit -1
fi