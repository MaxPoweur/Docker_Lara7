# Docker image PHP 7.1.3 et Mysql 5.7 (environnement iso Lara7)

### GitLab Orange Heading
{: .gitlab-orange}
Déployer un containeur (image Docker que l'on exécute), c'est s'assurer de retrouver un environnement de développement iso avec les autres environnements (autres développeurs, pré-production, production...).

L'image Lara7 propose les services suivants :

- Un serveur web tournant sous Apache et avec Php 7.1.3
- Un serveur Mysql 5.7
- Une interface web pour gérer la base de données : PhpMyadmin

Ainsi, cette image est adaptée pour les projets Lara7. Pour les projets Lara ou Lara7-2, merci de vous référer au dépôt correspondant.

> Si vous n'avez encore jamais utilisé Docker, c'est le moment de vous lancer. Consultez la section **Débuter avec Docker**

<span style="color:red"><i class="fab fa-gitlab fa-fw" style="color:red; font-size:.85em" aria-hidden="true"></i> Merci de ne pas mettre à jour ce dépôt Docker sans l'accord d'un référent</span>

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
2) Construire les images Docker :

>  docker-compose build --build-arg USER_ID=${UID}

*La partie --build-arg USER_ID=${UID} est à écrire **telle quelle** et permet d'anticiper de futurs problèmes de permissions sur nos containeurs Docker.*

4) Lancer les containeurs Docker :

> docker-compose up -d

Nous y voilà, les containeurs/services tournent en arrière-plan !

Pour stopper les services (sans les détruire), il suffit de taper la commande :

> docker-compose down -d

Il suffira alors d'écrire la première commande pour relancer les même services et retrouver l'état précédent de vos services (état **persistant**)

Pour détruire totalement les services :
> docker-compose rm -fs

## Travailler avec l'image Docker

Il est important de comprendre que le répertoire **/src** sur votre machine est reliée en temps réel au dossier **/var/www/html/src** du containeur.

Et le dossier */var/www/html/src* correspond à la racine du serveur web.

Le serveur web est configuré avec des virtual hosts automatiques et a un fonctionnement similaire au serveur Lara7 et vous pouvez utiliser le containeur pour héberger plusieurs de vos projets Lara7.

### Ajouter un projet au containeur

Pour chaque projet Lara7, il faut créer le répertoire correspondant à la racine du dossier **/src**.
Pour pouvoir accéder à votre projet depuis votre navigateur, il vous est demandé d'éditer votre fichier **/etc/hosts** en y rajoutant cette ligne :

```127.0.0.1       **{projectName}**.hegyd.local```
> **{projectName}** étant à remplacer par le nom de votre sous-répertoire correspondant au projet à ajouter

Ainsi, chaque sous-répertoire dans */src* sera disponible à l'adresse **{projectName}.hegyd.local:{ENV.HTTP_PORT}**.
> **{ENV.HTTP_PORT}** étant une variable de configuration du fichier **.env**

> Les variables d'environnement de connexion à la base de données sont déjà définies dans l'image docker, il n'est donc pas utile de les redéfinir dans votre .env
> Si vous les définissez tout de même dans le .env de votre projet, elles seront ignorées

### Travailler sur un projet

Il vous est demandé, pour tout ce qui est commande (php artisan, npm, composer...), de les écrire directement dans le dossier de votre projet, dans le containeur.
Ceci pour des raisons de permissions et de synchronisation des fichiers.

Vous pouvez cependant coder directement depuis le dossier **/src/{projectName}** de votre machine.

Voici la commande vous permettant de vous connecter à votre containeur :

```docker exec -it webapp-7.1.3 bash```

Cette commande vous connectera en **ssh** sur votre container, dans lequel vous pourrez taper toutes les commandes dont vous aurez besoin.
Mais n'oubliez pas que le containeur contient **tous** vos projets Lara7. Pour taper des commandes **artisan** (par exemple), positionnez-vous d'abord dans le répertoire du projet désiré.

Pour vous connecter en invite de commande à votre base de données, depuis votre machine :

> ```mysql -P ${MYSQL_PORT} --protocol=tcp -u root -p --password=${MYSQL_ROOT_PASSWORD}```

*Les variables ${MYSQL_PORT} et ${MYSQL_ROOT_PASSWORD} étant définies dans le fichier docker/.env*

Pour vous connecter à vos bases de données depuis **MySQL Workbench**, il faut utiliser les détails de connexion définies dans le fichier **/docker/.env**
Pour l'hôte, spécifiez 127.0.0.1.

Si vous préférez consulter vos bases de données sur navigateur via PhpMyAdmin, rendez-vous sur **localhost:8085**.

Et voilà ! Vous voilà fin prêt pour coder de grandes applications.

# Débuter avec Docker

## Vous avez dit Docker 🤔 ?

Tout le monde n'est pas forcément familier avec **Docker**. D'ailleurs, tout le monde ne connait pas Docker.

### Mais qu'est-ce que Docker ?

Docker est un logiciel aujourd'hui largement répandu qui permet de déployer aisément différents **environnements ISOS** les uns par rapport aux autres (développement, recette, pré-production...).

Docker tourne autour du concept de "containeur". Un containeur est semblable à une **machine virtuelle**, c'est à dire un sous-système d'exploitation *étanche* dans lequel nous allons installer un ensemble d'applications, de configurations...

La différence principale entre un containeur** et une machine virtuelle réside dans la **légèreté** et dans la **simplicité d'utilisation et de configuration** d'un containeur.

En effet, un containeur est beaucoup plus léger qu'une machine virtuelle, et il est alors beaucoup plus rapide de lancer un containeur.

Un containeur, pour être plus précis, correspond à une **instance** d'une **image** docker.

Et une image, c'est un ensemble de règles qui vont définir comment sera construit notre container (ex: les règles de configurations, les logiciels/services à installer dans notre containeur).

Comme analogie, je vous propose de comparer la relation image/containeur avec la relation classe/objet :

> Une classe est une définition et un objet est l'instance d'une classe.

Un second intérêt à utiliser Docker est alors de pouvoir déployer des containeurs docker dans différents environnements, à partir de la même image (et qui bénificient donc des même configurations et services).

*Marre des effets de bords liés à une version PHP non cohérente avec celle utilisée dans l'environnement de production 🤗 ? Utilisez Docker !*

### Utiliser Docker

Pour utiliser Docker, il n'est pas nécessaire de comprendre ses rouages internes, ni de savoir créer ou configurer une image Docker.

Utiliser Docker, ça se résume bien souvent à l'utilisation de quelques commandes.

Pour lancer notre containeur Docker, il faut utiliser l'une des commandes suivantes (dans le répertoire de l'image Docker) :

> docker run *[OPTIONS]* IMAGE *[ARGS]*

ou

> docker-compose up *[OPTIONS]*

La première commande lance un unique containeur, tandis que la seconde commande lance **au moins** un containeur.

La seconde commande est ainsi utile dans le cas d'applications nécessitant **plusieurs services**, avec un containeur par service (ex: un containeur apache, un containeur mysql, un containeur phpMyAdmin...).

Ainsi, la ou les commandes commandes à utiliser, dépendent du contexte d'utilisation. Il faut alors se référer à la **documentation de l'image** que vous comptez utiliser pour l'exploiter correctement.

Mais avant tout, il faudra tout de même veiller à installer Docker sur son ordinateur.

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