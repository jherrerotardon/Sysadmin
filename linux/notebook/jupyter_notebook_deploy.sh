#!/bin/bash

# GET DEVS PATHS #
SCRIPT_PATH="$( cd "$(dirname "$0")" ; pwd -P )"

cd $SCRIPT_PATH
PROJECT_PATH=$PWD

ROOT_PATH=$PROJECT_PATH/statistics
ENVIRONMENTS_FOLDER=$PROJECT_PATH/python-environments
ENVIROMENT="jupyter-notebook"

# INSTALL ENVIROMENT #
echo -e "Installing dependencies...\n\n"

cd $PROJECT_PATH


[[ -d $ENVIRONMENTS_FOLDER ]] || mkdir $ENVIRONMENTS_FOLDER
cd $ENVIRONMENTS_FOLDER

echo -e "Creating enviroment $ENVIROMENT...\n\n"
python3 -m virtualenv $ENVIROMENT

echo -e "Activating enviroment $ENVIROMENT...\n\n"
source $ENVIRONMENTS_FOLDER/$ENVIROMENT/bin/activate

# INSTALL REQUERIMENTS #
echo -e "Installing requirements...\n"
pip install -r $ROOT_PATH/requirements.txt | grep -v 'already satisfied'

cd $ROOT_PATH
nohup jupyter notebook --ip='0.0.0.0' --port='8888' --no-browser --NotebookApp.token='' --NotebookApp.password='' > /dev/null 2>&1 &

echo -e "Copy/paste this URL into your browser when you connect:\n\t"
echo -e "http:///localhost:8888"
