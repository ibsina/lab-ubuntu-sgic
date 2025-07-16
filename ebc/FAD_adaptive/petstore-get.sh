#!/bin/bash
# Curl commands to create API Protection Model
# FWB V7.0.1 written by Roy Scotford
# 2023032801 - Ferry Kemps : API building fix (XFF) and output improvements + HTTP status code
# 2023051901 - Ferry Kemps : Modified for use on both FWB and FWB-Cloud
# 2024013001 - Ferry Kemps : Modified for use for FortiADC WAF workshop

####################
# FortiADC section #
####################
URL="http://petstore.fortinet.demo"

echo "------------------------------------------------------------------------"
echo "Sending API GET requests to ${URL}/"
echo "------------------------------------------------------------------------"

for ((i=1; i<100; i++))
do
  echo -n "GET : http://petstore${ATT}.fortinet.demo - HTTP status = "
  IPADDRESS=$(dd if=/dev/urandom bs=4 count=1 2>/dev/null | od -An -tu1 | sed -e 's/^ *//' -e 's/  */./g')
  curl  -k -H "X-Forwarded-For: ${IPADDRESS}" -A WAF-Requester -s -o /dev/null -X 'GET' -w "%{http_code}" \
  "${URL}/api/pet/findByStatus?status=available" \
  -H 'accept: application/json' \
  -H 'content-type: application/json'
  echo ""

  echo -n "GET : http://petstore${ATT}.fortinet.demo - HTTP status = "
  IPADDRESS=$(dd if=/dev/urandom bs=4 count=1 2>/dev/null | od -An -tu1 | sed -e 's/^ *//' -e 's/  */./g')
  curl -k -H "X-Forwarded-For: ${IPADDRESS}" -A WAF-Requester -s -o /dev/null -X 'GET' -w "%{http_code}" \
  "${URL}/api/pet/findByStatus?status=pending" \
  -H 'accept: application/json' \
  -H 'content-type: application/json'
  echo ""

  echo -n "GET : http://petstore${ATT}.fortinet.demo - HTTP status = "
  IPADDRESS=$(dd if=/dev/urandom bs=4 count=1 2>/dev/null | od -An -tu1 | sed -e 's/^ *//' -e 's/  */./g')
  curl -k -H "X-Forwarded-For: ${IPADDRESS}" -A WAF-Requester -s -o /dev/null -X 'GET' -w "%{http_code}" \
  "${URL}/api/pet/findByStatus?status=sold" \
  -H 'accept: application/json' \
  -H 'content-type: application/json'
  echo ""
done

echo "-------------------------------------------------------------------------------------------"
echo "FortiADC API Discovery with GET method on ${URL}/"
echo "-------------------------------------------------------------------------------------------"
