#!/bin/bash

# GET DEVS PATHS #
ENVIRONMENT="venv"
FILE_PATH=$(dirname $(realpath $0))
ENVIRONMENT_PATH=${FILE_PATH}/${ENVIRONMENT}

# INSTALL ENVIRONMENT #
if [[ ! -d ${ENVIRONMENT_PATH} ]]; then
    echo -e "Creating environment $ENVIRONMENT_PATH...\n\n"
    python3 -m virtualenv ${ENVIRONMENT_PATH}
fi

# INSTALL REQUIREMENTS #
echo -e "Installing requirements...\n"
${ENVIRONMENT_PATH}/bin/pip3 install --upgrade -r ${FILE_PATH}/requirements.txt | grep -v 'already satisfied'

nohup ${ENVIRONMENT_PATH}/jupyter notebook --ip='0.0.0.0' --port='8888' --no-browser --NotebookApp.token='' --NotebookApp.password='' > /dev/null 2>&1 &

echo -e "Copy/paste this URL into your browser when you connect:\n\t"
echo -e "http:///localhost:8888"
