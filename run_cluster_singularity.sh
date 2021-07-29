#!/bin/bash

#SBATCH --output=/home/ditzel/%x.out

# CMD="cd ~/rad/refObj/ && /usr/local/bin/docker-entrypoint.sh $@"
# CMD="cd ~/rad/transformer/ && /usr/local/bin/docker-entrypoint.sh $@"

# CMD="cd ~/rad/discreteVAE/ && /usr/local/bin/docker-entrypoint.sh $@"
CMD="cd ~/rad/genRadar/ && /usr/local/bin/docker-entrypoint.sh $@"
singularity exec --nv ~/old_capsule.simg bash -c "$CMD"
RET=$?
echo "Execution finished with status $RET."
