#!/bin/bash

CARBON_HOME="/opt/wso2/wso2apim"
APIM_HOME="/opt/wso2/wso2am-2.2.0"
PRODUCT="apim"
VERSION="2.2.0"
RESOURCES_HOME="/tmp/resources"
_DATAHORA=`date +"%y%m%d_%H%M%S"`
# Essa variável contém o binário (.zip) que vai ser utilizado na instalação
WUM_HOME="/home/wso2/.wum3"
LATEST=`ls -ltr $WUM_HOME/products/wso2am/2.2.0/full/ | tail -n1 | awk '{print $NF}'`
WSO2AM_INSTALL_PATH="$WUM_HOME/products/wso2am/2.2.0/full/$LATEST"
echo "$WSO2AM_INSTALL_PATH"
WSO2_INSTALL_PATH="/opt/wso2/install/wso2-install"