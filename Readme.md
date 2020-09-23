# 🐳 Docker + PHP 7.4 + MySQL + Nginx + Symfony 5 

## Description

This is a complete stack for running Symfony 5 into Docker containers using docker-compose tool.

It is composed by 3 containers:

- `nginx`, acting as the webserver.
- `php`, the PHP-FPM container with the 7.4 PHPversion.
- `db` which is the MySQL database container with a **MySQL 8.0** image.

## Installation

1. 😀 First, clone this repository:
     
     ```bash
     $ git clone https://github.com/LisandroCaballero/api-rest-symfony
     ```
##### Rebuilds all the containers
2. Run `make build-image` 
##### Start the containers 
3. Run `make run`
##### Installs composer dependencies
2. Run `make composer-install`

3. The 3 containers are deployed: 

```
Creating sf5-api-web   ... done
Creating sf5-api-be    ... done
Creating sf5-api-db    ... done
```

4. Use this value for the DATABASE_URL environment variable of Symfony:

```
DATABASE_URL=mysql://app_user:helloworld@db:3306/app_db?serverVersion=5.7
```

You could change the name, user and password of the database in the `.env` file at the root of the project.

## Makefile
### ssh's into the back-end container
Run `make ssh-be`

### Clear SF cache
Run `make cache`

### Stop the containers
Run `make stop`


After installing Symfony we can verify that everything has worked correctly by accessing <http://localhost:8085> (the port is the one we mapped in Nginx within the docker-compose.yml file) which will show us the Symfony welcome page:

![](https://miro.medium.com/max/875/1*p2sN6sCsiGFr3vAnNICb8g.png)
