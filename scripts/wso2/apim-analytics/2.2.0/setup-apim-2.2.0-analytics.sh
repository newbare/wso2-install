CARBON_HOME="/opt/wso2/wso2am-analytics"
APIM_HOME="/opt/wso2/wso2am-analytics-2.2.0"
PRODUCT="apim-analytics"
VERSION="2.2.0"
RESOURCES_PATH="/tmp/resources.tar.gz"
RESOURCES_HOME="/tmp/resources"
_DATAHORA=`date +"%y%m%d_%H%M%S"`
# Essa variável contém o binário (.zip) que vai ser utilizado na instalação
LATEST=`ls -ltr ~/.wum-wso2/products/wso2am-analytics/2.2.0/ | tail -n1 | awk '{print $NF}'`
WSO2AM_INSTALL_PATH="/home/wso2/.wum-wso2/products/wso2am-analytics/2.2.0/$LATEST"
echo "$WSO2AM_INSTALL_PATH"
WSO2_INSTALL_PATH="/opt/wso2/install/wso2-install"

echo "(re)criando diretorio com os artefatos /tmp/resources"
rm -rf $RESOURCES_HOME
mkdir -p $RESOURCES_HOME
cp -av $WSO2_INSTALL_PATH/resources/* $RESOURCES_HOME/

echo "configurando variaveis de ambiente"
source $1

echo "substituindo variaveis nos arquivos configuracao template"
source $WSO2_INSTALL_PATH/resources/functions.sh
replaceVars $RESOURCES_HOME 

echo "removendo instalação anterior"
mv $APIM_HOME $CARBON_HOME.$_DATAHORA

echo "descompactando binario de instalacao"
cd /opt/wso2/
unzip -q $WSO2AM_INSTALL_PATH

echo "backup dos arquivos de configuracao original"
cp $CARBON_HOME/repository/conf/carbon.xml $CARBON_HOME/repository/conf/carbon.xml.orig.$_DATAHORA
cp $CARBON_HOME/repository/conf/registry.xml $CARBON_HOME/repository/conf/registry.xml.orig.$_DATAHORA
cp $CARBON_HOME/repository/conf/user-mgt.xml $CARBON_HOME/repository/conf/user-mgt.xml.orig.$_DATAHORA
cp $CARBON_HOME/repository/conf/identity/identity.xml $CARBON_HOME/repository/conf/identity/identity.xml.orig.$_DATAHORA
cp $CARBON_HOME/repository/conf/tomcat/catalina-server.xml $CARBON_HOME/repository/conf/tomcat/catalina-server.xml.orig.$_DATAHORA
cp $CARBON_HOME/repository/conf/datasources/master-datasources.xml $CARBON_HOME/repository/conf/datasources/master-datasources.xml.orig.$_DATAHORA
cp $CARBON_HOME/repository/conf/datasources/analytics-datasources.xml $CARBON_HOME/repository/conf/datasources/analytics-datasources.xml.orig.$_DATAHORA
cp $CARBON_HOME/repository/conf/datasources/stats-datasources.xml $CARBON_HOME/repository/conf/datasources/analytics-datasources.xml.orig.$_DATAHORA

echo "substituindo arquivos de configuracao"
cp $RESOURCES_HOME/$PRODUCT/$VERSION/conf/carbon.xml $CARBON_HOME/repository/conf/
cp $RESOURCES_HOME/$PRODUCT/$VERSION/conf/registry.xml $CARBON_HOME/repository/conf/registry.xml
cp $RESOURCES_HOME/$PRODUCT/$VERSION/conf/user-mgt.xml $CARBON_HOME/repository/conf/user-mgt.xml
cp $RESOURCES_HOME/$PRODUCT/$VERSION/conf/identity/identity.xml $CARBON_HOME/repository/conf/identity/identity.xml
cp $RESOURCES_HOME/$PRODUCT/$VERSION/conf/tomcat/catalina-server.xml $CARBON_HOME/repository/conf/tomcat/catalina-server.xml
cp $RESOURCES_HOME/$PRODUCT/$VERSION/conf/datasources/master-datasources-$DB.xml $CARBON_HOME/repository/conf/datasources/master-datasources.xml
cp $RESOURCES_HOME/$PRODUCT/$VERSION/conf/datasources/stats-datasources-$DB.xml $CARBON_HOME/repository/conf/datasources/stats-datasources.xml
cp $RESOURCES_HOME/$PRODUCT/$VERSION/conf/datasources/analytics-datasources-$DB.xml $CARBON_HOME/repository/conf/datasources/analytics-datasources.xml
cp $JDBC_DRIVER_PATH $CARBON_HOME/repository/components/lib/

echo "apagando arquivos desnecessários para o analytics"

if [ $1 = "mysql57" ]
then
    echo "atualizando scripts mysql-5.7"
    mv $CARBON_HOME/dbscripts/mysql.sql $CARBON_HOME/dbscripts/mysql5.x.sql
    mv $CARBON_HOME/dbscripts/mysql5.7.sql $CARBON_HOME/dbscripts/mysql.sql
    mv $CARBON_HOME/dbscripts/identity/mysql.sql $CARBON_HOME/dbscripts/apimgt/mysql5.x.sql
    mv $CARBON_HOME/dbscripts/identity/mysql5.7.sql $CARBON_HOME/dbscripts/apimgt/mysql.sql
fi