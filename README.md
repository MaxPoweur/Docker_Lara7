# Docker image PHP 7.1.3 et Mysql 5.7 (environnement iso Lara7)

Déployer un containeur (image Docker que l'on exécute), c'est s'assurer de retrouver un environnement de développement iso avec les autres environnements (autres développeurs, pré-production, production...).

L'image Lara7 propose les services suivants :

- Un serveur web tournant sous Apache et avec Php 7.1.3
- Un serveur Mysql 5.7
- Une interface web pour gérer la base de données : PhpMyadmin

Ainsi, cette image est adaptée pour les projets Lara7. Pour les projets Lara ou Lara7-2, merci de vous référer au dépôt correspondant.

> Si vous n'avez encore jamais utilisé Docker, c'est le moment de vous lancer. Consultez la section [Débuter avec Docker](#DébuteravecDocker)

# Configuration et utilisation de l'image

Pour pouvoir commencer à travailler sur l'image, il faut d'abord que vous compreniez son fonctionnement. Nous relevons 2 répertoires à la racine du projet :

- **/src** : c'est dans ce répertoire que vous publierez vos sources (laravel). Ce répertoire sera copié en temps réel dans le container Apache et sera donc disponible sur le serveur web
- **/docker** : c'est le dossier de configuration de l'image Docker

## Configurer l'image Docker

En premier lieu, il vous faut copier le fichier **/docker/.env.example** dans **/docker/.env**.

Basiquement, il vous suffira d'éditer le fichier **/docker/.env** pour adapter l'image à votre système (notamment si vous avez déjà des services similaires sur votre machine). Ce fichier devrait être suffisamment documenté.

Pour une utilisation un peu plus avancée, vous pouvez toujours éditer les fichiers de configuration présents dans **/docker/config**. Vous pouvez ainsi éditer le **php.ini** et les **virtual hosts**.

## Construire l'image Docker

1) En invite de commande, se positionner dans le répertoire docker.
2) Lancer la commande `docker-compose up -d`

Ça y est, les containeurs/services tournent en arrière-plan !

## Travailler avec l'image Docker

Il est important de comprendre que le répertoire **/src** sur votre machine est reliée en temps réel au dossier **/var/www/html/src** du containeur.

Et le dossier */var/www/html/src* correspond à la racine du serveur web, ainsi, tout ce qui sera dans votre dossier */src* sera disponible à la racine du site web **localhost:{ENV.HTTP_PORT}**.

Vous pouvez donc directement coder dans le répertoire */src*.

Pour initialiser le projet via un git clone, vous devez (pour des soucis de permissions) le faire sur votre machine, à l'intérieur du dossier */src*.

Néanmoins, pour le reste des commandes, il est largement recommandé et conseillé de le faire **à l'intérieur du containeur** (surtout pour commandes **artisan**):

```docker exec -it webapp-7.1.3 bash```

Cette commande vous connectera en **ssh** sur votre container, dans lequel vous pourrez taper toutes les commandes dont vous aurez besoin.

Et voilà ! Vous voilà fin prêt pour coder de grandes applications.

> Les variables d'environnement de connexion à la base de données sont déjà définies dans l'image docker, il n'est donc pas utile de les redéfinir dans votre .env

> Pour vous connecter en invite de commande à votre base de données :
>
> ```mysql -P ${MYSQL_PORT} --protocol=tcp -u root -p --password=${MYSQL_ROOT_PASSWORD}```
>
> Les variables ${MYSQL_PORT} et ${MYSQL_ROOT_PASSWORD} étant définies dans le fichier docker/.env

# Débuter avec Docker

## Installer Docker Engine (*sous Ubuntu*)

Docker Engine est le *moteur* Docker, c'est à dire le daemon qui va tourner en arrière plan et faire fonctionner tous les méchanismes de containeurisation.

> Pour un autre système d'exploitation qu'Ubuntu, suivre [ce lien](https://docs.docker.com/install/).

### Mise à jour des paquets

```sudo apt-get update```

### Installer les paquets permettant à apt d'utiliser des dépôts via du HTTPS

``sudo apt-get install apt-transport-https ca-certificates curl gnupg-agent software-properties-common```

### Ajouter la clé Docker officielle GPG

```curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -```

### Ajouter le dépôt Docker (version stable)

```sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"```

### Installer Docker Engine

```sudo apt-get install docker-ce docker-ce-cli containerd.io```

### Vérifier l'installation de Docker Engine

```docker -v```

## Installer Docker Compose (*sous Ubuntu*)

Docker Compose permet de créer des images Docker à partir de plusieurs autres images (entre autres). Ce qui est particulièrement utile dans notre cas où l'on a besoin de plusieurs services (**Php**, **Apache**, **Mysql**...).

> Pour un autre système d'exploitation qu'**Ubuntu**, suivre [ce lien](https://docs.docker.com/compose/install/).

### Installer la version stable de Docker Compose

```sudo curl -L "https://github.com/docker/compose/releases/download/1.24.1/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose```

### Donner les droits d'exécution à Docker Compsoe

```sudo chmod +x /usr/local/bin/docker-compose```


### Vérifier l'installation de Docker Compose

```docker-compose -v```

## Lancer le daemon (service en arrière-plan) Docker

> Pour que Docker soit lancé en arrière-plan automatiquement à chaque démarrage de votre système, initialiser le daemon docker est obligatoire

### Démarrer le service docker

```sudo systemctl start docker```

OU

```sudo service docker start```

## Ajouter l'utilisateur courant au groupe docker

> Pour éviter de devoir taper chaque commande docker en sudo, il est préférable d'ajouter l'utilisateur courant au groupe docker

### Créer le groupe docker

```sudo groupadd docker```

### Ajouter l'utilisateur courant au groupe docker

```sudo usermod -aG docker $USER```