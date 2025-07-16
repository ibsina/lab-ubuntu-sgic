#!/bin/bash
# Curl commands to create API Protection Model
# FWB V7.0.1 written by Ricky Voong
# 2023032801 - Ferry Kemps : Fixed the ML-API learning, optimized the output + status code
# 2023051901 - Ferry Kemps : Modified for use on both FWB and FWB-Cloud
# 2024013001 - Ferry Kemps : Modified for use for FortiADC WAF workshop

####################
# FortiADC section #
####################
URL="http://petstore.fortinet.demo"

NAMES=(FortiPuma FortiFish FortiSpider FortiTiger FortiLion FortiShark FortiSnake FortiMonkey FortiFox FortiRam FortiEagle FortiBee FortiCat FortiDog FortiAnt FortiWasp FortiPanter FortiGator FortiOwl FortiWildcats)
PETS=(Puma Fish Spider Tiger Lion Shark Snake Monkey Fox Ram Eagle Bee Cat Dog Ant Wasp Panter Gator Owl Wildcats)
STATUS=(available pending sold available pending sold available pending sold available pending sold available pending sold available pending sold available pending)

ID=400

echo "-------------------------------------------------------------------------------------------------------------------"
echo "Sending API POST requests to ${URL}/ to populate pets entries with FortiPets"
echo "-------------------------------------------------------------------------------------------------------------------"

for ((i=0; i<150; i++))
do
  IPADDRESS=$(dd if=/dev/urandom bs=4 count=1 2>/dev/null | od -An -tu1 | sed -e 's/^ *//' -e 's/  */./g')
  echo -n "POST : http://petstore${ATT}.fortinet.demo - HTTP status = "
  curl -k -H "X-Forwarded-For: ${IPADDRESS}" -A WAF-Requester -s -o /dev/null -w "%{http_code}" -X 'POST' \
    "${URL}/api/pet" \
    -H 'accept: application/json' \
    -H 'Content-Type: application/json' \
  -d "{\
    \"id\": $ID,\
    \"category\": {\
      \"id\": $ID,\
      \"name\": \"${PETS[$i]}\"\
    },\
    \"name\": \"${NAMES[$i]}\",\
    \"photoUrls\": [\
      \"Willupdatelater\"\
    ],\
    \"tags\": [\
      {\
        \"id\": $ID,\
        \"name\": \"${NAMES[$i]}\"\
      }\
    ],\
    \"status\": \"${STATUS[$i]}\"\
    }"
    echo ""

  ID=$((ID+1))
done

echo ""
