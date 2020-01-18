#!/bin/bash

# Configure Jupyter
yes | sudo runuser -l ubuntu -c 'jupyter notebook --generate-config' &&
    sed -i -e "s/#c.NotebookApp.ip = 'localhost'/c.NotebookApp.ip = '"$(curl http://169.254.169.254/latest/meta-data/public-hostname)"'/g" /home/ubuntu/.jupyter/jupyter_notebook_config.py &&
    sed -i -e "s/#c.NotebookApp.allow_origin = ''/c.NotebookApp.allow_origin = '*'/g" /home/ubuntu/.jupyter/jupyter_notebook_config.py &&
    sed -i -e "s/#c.NotebookApp.open_browser = True/c.NotebookApp.open_browser = False/g" /home/ubuntu/.jupyter/jupyter_notebook_config.py
