#!/bin/bash -ex

# rationale: set a default DEPLOY_SECRETS
if [ -z "$JENKINS_DEPLOY" ]; then
  JENKINS_DEPLOY='no'
fi

if [ "$JENKINS_DEPLOY" == "yes" ]
then
  # Opcional, configura la aplicación descifrando secretos.
  rsaconfigcipher -P $JENKINS_SECRET_KEY src/main/resources/hibernate.cfg.xml.rsa
  rsaconfigcipher -P $JENKINS_SECRET_KEY src/main/resources/geoportal.properties.rsa
fi

mvn -Dmaven.test.failure.ignore clean package # artefacto en: target/geoportal.war
