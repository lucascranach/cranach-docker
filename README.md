# cranach-docker
Docker Setup for Lucas Cranach Archive

## Running the build
Create a copy of the file `example-env` and rename it to `.env`.

Set up the variables in the `.env` File.

The application runs with Docker Compose and contains two Container.
* `cranach-elk` ELK Stack that povides the data
* `cranach-api` Node JS application that provides the API


Build the images and run the containers
```shell
$ docker-compose build
```

Run the containers
```shell
$ docker-compose up -d
```

For debugging run the containers without detached mode
```shell
$ docker-compose up
```

Stop the containers
```shell
$ docker-compose stop
```

### Start and Stop the containers on a remote server
To start and stop the containers on a remote server, you can use the following commands:

Login to the remote server
```shell
$ ssh -l <username> mivs02.gm.fh-koeln.de
```
Navigate to the directory where the `docker-compose.yml` file is located
```shell
$ cd /var/lucascranach/cranach-docker/
```

Start the containers
```shell
$ docker-compose -f docker-compose.yml -f docker-compose.prod.yml up -d
```

Stop the containers
```shell
$ docker-compose stop
```

## Remote server
There are two remote servers for the Cranach API which can be accessed via the following URLs:
* `https://mivs.02.gm.fh-koeln.de` - Productive environment
* `https://mivs.03.gm.fh-koeln.de` - Development enviroment

The Deployment to the servers is handled via GitHub Actions and is triggered when changes are pushed to one of the following repositories: `cranach-docker`, `cranach-api`, `cranach-elk`
On which server will be deployed depends on the branch to which changes are pushed or a pull request is merged. The following dependencies exist:

* `mivs.02.gm.fh-koeln.de` - `master` branches
* `mivs.03.gm.fh-koeln.de` - `integration` branches


## Importing data to Elasticsearch
The importer is located in the directory `importer`.


### If the data on the remote server is to be updated
* Push the zipped files to be imported on the server  
`scp files.zip <username>@mivs02.gm.fh-koeln.de:~`
* Log in to the server. 
`ssh -l <username> mivs02.gm.fh-koeln.de`  
* Move the zip file to the `files` directory  
`sudo mv files.zip /var/lucascranach/cranach-docker/importer/files/`  
* unzip and delete `files.zip`  
`sudo cd /var/lucascranach/cranach-docker/importer && unzip files.zip && rm files.zip`
* Start the import script
`cd /var/lucascranach/cranach-docker/importer && make importesindices`


### If the data on the local machine is to be updated
* Put the files to be imported into the `files` folder.
* Make a copy of the file `example-config.cfg` and rename it to `config.cfg`.
* Now adjust the variable `elasticsearch_indices_import_files` in the file `config.cfg`.
* Start the import script: `make importesinidices`

## Renew Let's Encrypt certificates
1. stop API container
```shell
cd /var/lucascranach/cranach-docker/ && docker-compose stop reverse-proxy
```
2. Renew certificate
```shell
sudo certbot certonly --standalone --preferred-challenges http  -d mivs02.gm.fh-koeln.de
```
3. start API container
```shell
cd /var/lucascranach/cranach-docker/ && sudo docker-compose -f docker-compose.yml -f docker-compose.prod.yml up -d reverse-proxy
```


