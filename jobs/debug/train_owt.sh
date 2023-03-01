#!/bin/bash

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

echo Waiting for debugger to attach...

# Run script
python -m debugpy --listen 0.0.0.0:$PORT --wait-for-client $WORKDIR/train.py --dtype=float16 --compile=False --dataset=openwebtext --batch_size=8 --block_size=256 --n_layer=6 --n_head=6 --n_embd=384

conda deactivate