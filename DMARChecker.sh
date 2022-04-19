#!/bin/bash

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

regex_reject="p\s*=\s*reject"
regex_quarantine="p\s*=\s*quarantine"
regex_none="p\s*=\s*none"

help () {
	echo "Parameter:"
	echo "[+] Use -d with a domain name\n"

	echo "[*] Example: sh DMARChecker.sh -d domain.com"
}

dmarc () {
	domain=$1

	retval=0
	output=$(nslookup -type=txt _dmarc."$domain")

	case "$output" in
		*p=reject*)
			echo "$domain is ${GREEN}NOT vulnerable${NC}"
		;;
		*p=quarantine*)
			echo "$domain ${YELLOW}can be vulnerable${NC} (email will be sent to spam)"
		;;
		*p=none*)
			echo "$domain is ${RED}vulnerable${NC}"
			retval=1
		;;
		*)
			echo "$domain is ${RED}vulnerable${NC} (No DMARC record found)"
			retval=1
		;;
	esac
	return $retval
}

main () {

	while getopts d: flag
        do
                case "${flag}" in
                        d) domain=${OPTARG};;
                esac
        done

        if [ -n "$domain" ]; then
                dmarc $domain
        else
                help
        fi

}

echo "
######  #     #    #    ######   #####
#     # ##   ##   # #   #     # #     # #    # ######  ####  #    # ###### #####
#     # # # # #  #   #  #     # #       #    # #      #    # #   #  #      #    #
#     # #  #  # #     # ######  #       ###### #####  #      ####   #####  #    #
#     # #     # ####### #   #   #       #    # #      #      #  #   #      #####
#     # #     # #     # #    #  #     # #    # #      #    # #   #  #      #   #
######  #     # #     # #     #  #####  #    # ######  ####  #    # ###### #    # by @carloscast1llo
"

if [ $# != 2  ];then
        echo "Wrong execution\n"
        help
        exit 0
fi

main $@
