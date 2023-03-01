# NanoGPT on the Cluster

## Environment setup

Create the conda environment and install the dependencies
```
conda create -n nanogpt python=3.9
conda activate nanogpt
pip install -r requirements.txt
```

Configure `vscode_remote_debugging\config.conf`

```
WORKDIR /path/to/your/nanogpt/repo
PORT 9001
LAUNCH_JSON /path/to/your/nanogpt/repo/.vscode/launch.json
CONDA_SOURCE /path/to/your/conda/source # E.g /path/to/user/.bash_profile
CONDA_ENV nanogpt # name of your environment
```


## Debugging setup (VSCode)
1. Install `Remote - SSH` extension on VSCode
1. `View` > `Command Palette` > `Remote-SSH: Connect to Host...` > `+ Add New SSH Host` > `ssh <your_user>@kislogin2.xx.xx.xxxxxx`
1. Once you're connected to remote, you should be able to navigate to the directory of your repo in the Explorer (Ctrl+Shift+E / Cmd+Shift+E / `View` > `Explorer`)
1. In `.vscode/launch.json`: `Add configuration` -> `Python` -> `Remote Attach`. You can add any host name and port number (the actual configuration will be read from `config.conf`). 
    - Remove `pathMappings` in `launch.json`
    - Also remove the comments

Your `.vscode/launch.json` should look like this (comments and pathMappings removed):
```
{
    "version": "0.2.0",
    "configurations": [
        {
            "name": "Python: Remote Attach",
            "type": "python",
            "request": "attach",
            "connect": {
                "host": "localhost",
                "port": 5678
            }
        }
    ]
}
```

## Preparing the Data
We will first prepare the data (Shakespeare, with GPT2 tokenization) that we will consume during training

```
sbatch ./jobs/prepare_data.sh
```

To prepare the OpenWebText data (can take over 12 hours):
```
sbatch ./jobs/prepare_data.sh openwebtext
```
## Debugging on the cluster
1. Start an interactive session:
   * `srun -p <partition_name> --pty bash`
2. Initialize `launch.json` with the details from `config.conf`
   *  `bash vscode_remote_debugging/init.sh`
3. Start the debugging session on
   * `bash ./jobs/debug/train.sh`
4. The code waits until the client is attached to run.
   * `View` > `Run` > `Python: Remote Attach`
5. Debug as if the code is running on your local machine!
