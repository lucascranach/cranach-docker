# cranach-docker
Docker Setup for Lukas Cranach Archive

## Running the build
The application runs with Docker Compose and contains two Container.
* `cranach-elk` ELK Stack that povides the data
* `cranach-api` Node JS application that provides the API

Build the images and run the containers
```shell
$ docker-compose up -d
```

Stop the containers
```shell
$ docker-compose stop
```

## Importing data to Elasticsearch
The importer is located in the directory `importer`.

* Put the files to be imported into the `files` folder.
* Make a copy of the file `exampleconfig` and rename it to `config.cfg`.
* Now adjust the variable `elasticsearch_indices_import_files` in the file `config.cfg`.
* Start the import script: `make importesinidices`