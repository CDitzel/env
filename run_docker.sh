#!/bin/bash
container_name='capsule'
# image_name='sewing31/encapsulation:latest'
image_name='sewing31/encaps:latest'
if [ ! -z "$DOCKER_MACHINE_NAME" ]; then
	>&2 echo "Error: You probably are already inside a docker container!"
	exit 1
elif [ ! -e /var/run/docker.sock ]; then
	>&2 echo "Error: Either docker is not installed or you are already inside a docker container!"
	exit 1
fi

#if [ $(docker ps | grep $container_name | wc -l) -gt 0 ]
#then
#    echo $container_name "already Running! (docker exec" $container_name "sh) to attach"
#	exit 1
#else
#    echo "Starting up " $container_name
#fi

# kill and restart container if it has been running before
#CONTAINER_ID=$(docker inspect --format="{{.Id}}" ${container_name} 2> /dev/null)
#if [[ "${CONTAINER_ID}" ]]; then
#  echo 'RUNNING'
#  docker kill $container_name
#else
#  echo "NOT RUNNING"
#fi

MAC_ADDRESS=$(ip link | grep -m1 ether | cut -d " " -f6)
IP_ADDRESS=$(ip -4 addr show scope global | grep -m1 inet | awk "{print \$2}" | cut -d / -f 1)

SBX_DIR=$(realpath $(dirname $0))

CONTAINER_NAME=$(uuidgen | md5sum | awk '{ print $1 }' | cut -c -12)

if [ $# -eq 0 ]; then
    ARGS=$SHELL
else
    ARGS=$@
fi

docker_ver=`docker --version | sed -e 's/.*version \([^\.]\+\)\..*/\1/'`

if [ $docker_ver -lt 19 ]; then
  DOCKER="nvidia-docker run"
else
  DOCKER="docker run --gpus all"
fi

# docker pull $IMAGE_NAME
DOCKER_ARGS=(
  --name $container_name
  -v $HOME:$HOME # entire HOME DIR
  -v "$SBX_DIR":"$SBX_DIR"
  -v /tmp:/tmp:rw
  -v /tmp/.X11-unix:/tmp/.X11-unix:rw
  -v /etc/group:/etc/group:ro
  -v /etc/passwd:/etc/passwd:ro
  -v /etc/shadow:/etc/shadow:ro
  -e DISPLAY=unix$DISPLAY
  -e DOCKER_MACHINE_NAME="$IMAGE_NAME_SHORT:$TAG"
  -e CONTAINER_NAME="$CONTAINER_NAME"
  --network=host
  --ulimit core=99999999999:99999999999
  --ulimit nofile=10240 # makes forking processes faster, see https://github.com/docker/for-linux/issues/502
  --privileged
  --add-host=localhost:$IP_ADDRESS
  --add-host=$(cat /etc/hostname):$IP_ADDRESS
  #$HOSTS
  --rm
  --user $(id -u):$(id -g)
  --group-add sudo
  --group-add dialout
  --ipc=host # enable shared memory between host and container
  --device /dev/dri
  -w $SBX_DIR
  -it $image_name
  # -dit $image_name
  $ARGS
)

$DOCKER ${DOCKER_ARGS[@]}
