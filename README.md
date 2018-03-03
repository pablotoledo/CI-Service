# CI-Service

Este es un pequeño proyecto en el que busco ejemplificar un sistema de integración continua mediante la interacción de herramientas open source al alcance de todos.

## Arquitectura
En CI-Service están implicadas las siguientes tecnologías:

 - **Vagrant**: Para definir la máquina Centos donde correrán los contenedores, está preparado para montar toda la arquitectura tras un proxy corporativo en caso de ser necesario.
 - **Docker Compose**: De cara a ejecutar cada uno de los contenedores, se ha definido la instanciación de los contedores y los volúmenes donde estos operan.
 - **Docker** para ejecutar las distintas aplicaciones implicadas y crear los esclavos necesarios:
	 - GitLab
	 - Jenkins
		 - Agente o esclavo Centos donde ejecutar las tareas de CI
	 - Nexus
	 - SonarQube
		 - Postgresql
	 - Portainer: Portal que nos permitirá administrar y monitorizar desde un dashboard todo el Docker Engine en ejecución.

## Funcionamiento de CI 
Esta arquitectura de CI contiene un proyecto de ejemplo definido para demostrar la lógica de funcionamiento:

 - En GitLab tenemos un proyecto "scala-maven" donde se ha definido en un Jenkinsfile la lógica a ejecutar por Jenkins
 - Jenkins monitoriza los cambios en el repositorio de Gitlab para el Job "scala-maven"
	 - Si se detectasen cambios se procede a:
		 - Descargar el repositorio
		 - Compilar
		 - Hacer pruebas unitarias
		 - Hacer un análisis de código estático (SonarQube)
		 - Publicar el artefacto en Nexus


----------


# Detalles de arquitectura
Los servicios que se instancian son los siguientes:

 - Vagrant: Define una máquina Centos que correrá Docker CE
	 - Docker Engine
		 - Portainer: Gestión de Docker CE mediante el dashboard
		 - GitLab: Gestión del código fuente con Git
		 - Jenkins: Orquestados
		 - Nexus: Repositorio de artefactos
		 - Postgresql: BBDD para almacenar los informes publicados en Sonar
		 - SonarQube: Portal para representar los informes de calidad de código

## Listado de servicios y puertos

|Servicio|Ruta Host:Puerto|
|--|--|
|Portainer|http://192.168.50.10:9000/|
|GitLab|http://192.168.50.10:8030/|
|Jenkins|http://192.168.50.10:8080/|
|Nexus|http://192.168.50.10:8081/nexus/|
|SonarQube|http://192.168.50.10:8020/|

## Usuarios y contraseñas

Los usuarios siempre son de administración y puede ser: **root** ó **admin**
Las contraseñas siempre es la misma: **ciservice**

En el caso de Sonar el token creado para acceder a este servicio desde otras aplicaciones es: 5f94f7762e88a8559fbc618abc02d4685dabc4b9


----------


# Como empezar

## Requisitos

### Requisitos de HW

 - CPU compatible con HiperV
 - La máquina virtual en Vagrant ha sido definida con 5 GB de RAM, por lo que un equipo de al menos 8GB es necesario

### Requisitos de SW

 - Virtualbox : Como software de virtualización
 - Vagrant : De cara a definir la máquina virtual que ejecutará los distintos contenedores

## Iniciar CI-Service

Tenemos 4 script para iniciar CI-Service según las siguientes circunstancias:
### Sistema Operativo Windows

 - En el caso estandar ejecutamos "install-windows.bat"
 -  En caso de estár tras un firewall corporativo useramos "install-windows-withproxy.bat"
	 - Editamos el fichero incluyendo los datos del proxy corporativo
	 - Ejecutamos el script

### Sistema Operativo tipo Unix

 - En el caso estandar ejecutamos "install-unix.sh"
 -  En caso de estár tras un firewall corporativo useramos "install-unix-withproxy.sh"
	 - Editamos el fichero incluyendo los datos del proxy corporativo
	 - Ejecutamos el script


----------

### Autor
    Pablo Toledo