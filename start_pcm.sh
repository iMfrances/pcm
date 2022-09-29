#!/bin/sh
CONTAINER_NAME=pcm-raw
docker run -d --name $CONTAINER_NAME -p 9736:9736 --privileged -v $PWD/event_file.txt:/pcm_ep/event_file.txt proxy_cloud_workload_pcm
sleep 1 
docker exec -it $CONTAINER_NAME bash -c "cd /pcm ; echo y| ./build/bin/pcm-raw -ep /pcm_ep -el /pcm_ep/event_file.txt";

docker exec -it $CONTAINER_NAME bash -c "cd /pcm ; ./build/bin/pcm-raw -ep /pcm_ep -el /pcm_ep/event_file.txt";
