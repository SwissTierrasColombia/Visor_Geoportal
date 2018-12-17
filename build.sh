#!/bin/bash -ex

# rationale: set a default DEPLOY_SECRETS
if [ -z "$JENKINS_DEPLOY" ]; then
  JENKINS_DEPLOY='no'
fi

if [ -z "$IGAC_DEPLOY" ]; then
  IGAC_DEPLOY='no'
fi

if [ "$JENKINS_DEPLOY" == "yes" ]
then
  # Opcional, configura la aplicación descifrando secretos.
  rsaconfigcipher -P $JENKINS_SECRET_KEY src/main/resources/hibernate.cfg.xml.rsa
  rsaconfigcipher -P $JENKINS_SECRET_KEY src/main/resources/geoportal.properties.rsa
fi

if [ "$IGAC_DEPLOY" == "yes" ]
then
    cp -rf ../config/geoportal.properties src/main/resources
    cp -rf ../config/hibernate.cfg.xml src/main/resources
fi

mvn -Dmaven.test.failure.ignore clean package # artefacto en: target/geoportal.war

if [ "$IGAC_DEPLOY" == "yes" ]
then
  scp target/geoportal.war web:/opt/tomcat8/webapps
fi
