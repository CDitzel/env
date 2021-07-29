container_name='capsule'
# image_name='sewing31/encapsulation:latest'
# image_name='sewing31/encaps:latest'
image_name='capsule'
# image_name='naja:latest'
docker run \
	   -v /var/run/docker.sock:/var/run/docker.sock \
	   -v /tmp:/output \
	   --privileged -t --rm \
	   singularityware/docker2singularity:v3.3.0 \
	   --name $container_name $image_name

# transfer singularity image to both blusters
# TODO: even necessary with SSHFS-mounted dir?
scp /tmp/$container_name.simg mrm-deep0:~
scp /tmp/$container_name.simg mrm-deep1:~
scp /tmp/$container_name.simg mrm-deep2:~
