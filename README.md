# Visor Geoportal

Para desplegar el proyecto en Ubuntu:
## Clonar los repositorios

```bash
git clone https://github.com/AgenciaImplementacion/Visor_Geoportal.git
git clone https://github.com/AgenciaImplementacion/webservices.git
git clone https://github.com/AgenciaImplementacion/http_proxy.git
git clone https://github.com/AgenciaImplementacion/xtf2json.git
git clone https://github.com/AgenciaImplementacion/print_server.git
```

## Pre-requisitos

Instalar Gradle, puedes seguir esta guía https://linuxize.com/post/how-to-install-gradle-on-ubuntu-18-04/

Instalar Maven, sudo apt-get install maven

Instalar Tomcat, puedes seguir esta guía https://linuxize.com/post/how-to-install-tomcat-8-5-on-ubuntu-18.04/
Se debe crear el rol de administración


Desplegar web services
```bash
cd webservices/
 ./build.sh 

java -jar ./build/libs/webservices.jar

```

Desplegar http_proxy
```bash
cd http_proxy/
 ./build.sh 
```

Entrar al manager de tomcat y se carga el war del http_proxy

Desplegar el xtf2json

```bash
cd xtf2json/
 ./build.sh 
```

Crear carpetas

/opt/ilivalidator/tmp/uploads
/opt/ilivalidator/tmp/downloads
/opt/ilivalidator/tmp/ili




./build/libs/webservices.jar
