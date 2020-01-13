#!/bin/bash
#
#
#Set your Variables Here Shuping!
export ORGID='00000000-4321-xxxx-1234-abcdefg12345'
export INVENTORY='2_UKServerFormatted.csv'
#export REGION='https://api-na.example.com'
export REGION='https://api-eu.example.com/'
#End of Variables Section
#

for VMNAME in $( cat $INVENTORY | grep -v ToDoAction | grep 'Revised Specs' | awk -F, '{print $2}' )
do export VMID=$(curl -s -X GET $REGION/caas/2.10/$ORGID/server/server?name=$VMNAME -H 'Accept: */*' -H 'Accept-Encoding: gzip, deflate' -H 'Authorization: Basic dXNlcm5hbWU6cGFzc3dvcmQK' -H 'Cache-Control: no-cache' -H 'Connection: keep-alive' -H 'cache-control: no-cache' | xmllint --format - | grep 'server id' | awk -F'"' '{print $2}' )
export REVISEDCPU=$(grep $VMNAME $INVENTORY | awk -F, '{print $7}' )
export REVISEDMEM=$(grep $VMNAME $INVENTORY | awk -F, '{print $9}' )
echo will resize $VMNAME 
curl -X POST \
$REGION/caas/2.10/$ORGID/server/reconfigureServer \
-H 'Accept: */*' \
-H 'Accept-Encoding: gzip, deflate' \
-H 'Authorization: Basic dXNlcm5hbWU6cGFzc3dvcmQK' \
-H 'Cache-Control: no-cache' \
-H 'Connection: keep-alive' \
-H 'Content-Type: application/json' \
-H 'cache-control: no-cache' \
-d '{
"memoryGb": '$REVISEDMEM',
"cpuCount": '$REVISEDCPU',
"id": "'$VMID'"
}'
sleep 5
done