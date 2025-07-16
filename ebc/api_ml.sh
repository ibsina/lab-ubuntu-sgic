for k in {1..10}
do
 x=$((1 + $RANDOM % 3))
 if [ $x -eq 1 ] 
 then
  curldata="{\"login\":\"acbde$k\",\"password\":\"my_password$k\",\"loginid\":$RANDOM ,\"rights\": [ \"sales\", \"finance\"]}"
 fi
 if [ $x -eq 2 ] 
 then
  curldata="{\"login\":\"acbde$k\",\"password\":\"my_password$k\",\"loginid\":$RANDOM ,\"rights\": [ \"sales\"]}"
 fi
 if [ $x -eq 3 ] 
 then
  curldata="{\"login\":\"acbde$k\",\"password\":\"my_password$k\",\"loginid\":$RANDOM ,\"rights\": [ \"sales\", \"finance\", \"admin\" ]}"
 fi
 curl http://api-ml-demo:8090/sales/ -k -H "Content-Type: application/json" --data-raw "$curldata"
done



daftarid=("1 2 3 4 5 6 7 8 10 11 12 13 14 15 16 17 18 19 20")
for idku in ${daftarid[@]};
do
curl -k http://api-ml-demo:8090/news?id=$idku -H "Content-Type: application/json"
done


for k in {1..11}
do
curldata="{\"user\":\"ahmad $k\"}"
curl http://api-ml-demo:8090/love/food -k -H "Content-Type: application/json" -d "$curldata"
curl http://api-ml-demo:8090/love/drink -k -H "Content-Type: application/json" -d "$curldata"
done



curl http://api-ml-demo:8090/101/ -k -H "Content-Type: application/json"
curl http://api-ml-demo:8090/102/ -k -H "Content-Type: application/json"
curl http://api-ml-demo:8090/1101/ -k -H "Content-Type: application/json"
curl http://api-ml-demo:8090/1102/ -k -H "Content-Type: application/json"
curl http://api-ml-demo:8090/1201/ -k -H "Content-Type: application/json"
curl http://api-ml-demo:8090/1202/ -k -H "Content-Type: application/json"
curl http://api-ml-demo:8090/1011/ -k -H "Content-Type: application/json"
curl http://api-ml-demo:8090/1012/ -k -H "Content-Type: application/json"
curl http://api-ml-demo:8090/11011/ -k -H "Content-Type: application/json"
curl http://api-ml-demo:8090/11012/ -k -H "Content-Type: application/json"
curl http://api-ml-demo:8090/12011/ -k -H "Content-Type: application/json"
curl http://api-ml-demo:8090/12012/ -k -H "Content-Type: application/json"



