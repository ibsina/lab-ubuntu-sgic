#!/bin/bash

# this script will loop to get the feed from urllist.txt in the same directory
useragent="Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/75.0.3770.100 Safari/537.36"

while true 
do 
# return a number in range [10-200]
    a=$RANDOM
    b=$(($a%200+11))
    src="$b.100.100.$b"
    xargs -n 1 curl --insecure --user-agent "$useragent" --header "X-FORWARDED-FOR: $src" --silent > /dev/null < urllist.txt
    echo Curl RUN X-FORWARDED-FOR $src
    sleep 1
done


# run this later with nohup ./loop_attach_curl.sh
#demouser@demouser-pc:~$ nohup ./loop_attack_curl.sh &
#[1] 30014
#demouser@demouser-pc:~$ nohup: ignoring input and appending output to 'nohup.out'


