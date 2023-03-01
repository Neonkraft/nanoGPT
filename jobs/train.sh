#!/bin/bash
#SBATCH -p ml_gpu-rtx2080
#SBATCH --gres=gpu:1
#SBATCH -t 1-00:00:00 # time (D-HH:MM)
#SBATCH -c 2 # number of cores
#SBATCH -o logs/%j.%x.%N.out # STDOUT  (the folder log has to be created prior to running or this won't work)
#SBATCH -e logs/%j.%x.%N.err # STDERR  (the folder log has to be created prior to running or this won't work)
#SBATCH -J TrainGPT # sets the job name. If not specified, the file name will be used as job name

# Read environment variables from config.conf
SCRIPT_DIR="./vscode_remote_debugging"
while read var value
do
    export "$var"="$value"
done < $SCRIPT_DIR/config.conf

cd $WORKDIR

# Activate conda environment
source $CONDA_SOURCE
conda activate $CONDA_ENV

python $WORKDIR/train.py --dtype=float16 --compile=False --dataset=shakespeare --batch_size=8 --block_size=256 --n_layer=6 --n_head=6 --n_embd=384

conda deactivate