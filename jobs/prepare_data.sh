#!/bin/bash
#SBATCH -p ml_gpu-rtx2080
#SBATCH --gres=gpu:1
#SBATCH -t 1-00:00:00 # time (D-HH:MM)
#SBATCH -c 2 # number of cores
#SBATCH -o logs/%j.%x.%N.out # STDOUT  (the folder log has to be created prior to running or this won't work)
#SBATCH -e logs/%j.%x.%N.err # STDERR  (the folder log has to be created prior to running or this won't work)
#SBATCH -J PrepareData # sets the job name. If not specified, the file name will be used as job name

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

if [[ $# -eq 0 ]]; then
    echo "No flag provided, preparing shakespeare data (GPT2 tokenization)"
    python data/shakespeare/prepare.py
elif [[ $1 == "shakespeare_char" ]]; then
    echo "Preparing shakespeare data (character tokenization)"
    python data/shakespeare_char/prepare.py
elif [[ $1 == "openwebtext" ]]; then
    echo "Preparing openwebtext data (GPT2 tokenization)"
    python data/openwebtext/prepare.py
else
    echo "Invalid flag provided, running file3"
fi
