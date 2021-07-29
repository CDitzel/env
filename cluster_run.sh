#!/bin/bash

desc=$4
desc=${desc##*=}  # extract part after '=' to yield through to python arg-parser for output directory creation as well as slurm job description cf. 'squeue' command output

ssh -t mrm-deep$1 "sbatch --gres=gpu:1 --mem=16G --job-name=$desc ~/rad/env/run_cluster_singularity.sh $2 $3 $4"

# ~/rad/env/run_cluster_singularity.sh $2 $3 $4

# $1: cluster identifier, i.e. 0 = mrm-20
# $2: 'python' as defined in .bashrc
# $3: path to .py file
# $4: optional cli arguments
