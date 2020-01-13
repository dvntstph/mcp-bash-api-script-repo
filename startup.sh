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

for VMNAME in $( cat $INVENTORY | grep -v ToDoAction | grep -v 'Decomission' | awk -F, '{print $2}' )
do export VMID=$(curl -s -X GET $REGION/caas/2.10/$ORGID/server/server?name=$VMNAME -H 'Accept: */*' -H 'Accept-Encoding: gzip, deflate' -H 'Authorization: Basic dXNlcm5hbWU6cGFzc3dvcmQK' -H 'Cache-Control: no-cache' -H 'Connection: keep-alive' -H 'cache-control: no-cache' | xmllint --format - | grep 'server id' | awk -F'"' '{print $2}' )
if  [[ $(grep $VMNAME $INVENTORY | awk -F, '{print $4}') = '0' ]]
then echo $VMNAME was shutdown... skipping
elif [[ $(grep $VMNAME $INVENTORY | awk -F, '{print $4}') = '1' ]]
then echo $VMNAME appears to have been running will start...
echo starting up $VMNAME 
curl -s -X POST \
$REGION/caas/2.10/$ORGID/server/startServer \
-H 'Accept: */*' \
-H 'Accept-Encoding: gzip, deflate' \
-H 'Authorization: Basic dXNlcm5hbWU6cGFzc3dvcmQK' \
-H 'Cache-Control: no-cache' \
-H 'Connection: keep-alive' \
-H 'Content-Type: application/json' \
-H 'cache-control: no-cache' \
-d '{
 "id": "'$VMID'"
}'
fi

done