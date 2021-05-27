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

For debugging run the containers without detached Mode
```shell
$ docker-compose up
```

Stop the containers
```shell
$ docker-compose stop
```

## Importing data to Elasticsearch
The importer is located in the directory `importer`.

### If the data on the remote server is to be updated
* Push the zipped files to be imported on the server  
`scp files.zip <username>@mivs02.gm.fh-koeln.de:~`
* Log in to the server. 
`ssh -l <username> mivs02.gm.fh-koeln.de`  
* Move the zip file to the `files` directory  
`mv files.zip /var/lucascranach/cranach-docker/importer/files/`  
* unzip and delete `files.zip`
`unzip files.zip && rm files.zip`
* Start the import script  
`make importesinidices`


### If the data on the local machine is to be updated
* Put the files to be imported into the `files` folder.
* Make a copy of the file `example-config.cfg` and rename it to `config.cfg`.
* Now adjust the variable `elasticsearch_indices_import_files` in the file `config.cfg`.
* Start the import script: `make importesinidices`
