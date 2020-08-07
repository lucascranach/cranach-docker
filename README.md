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
Run the containers
```shell
$ docker-compose up
```

Stop the containers
```shell
$ docker-compose stop
```

## Importing data to Elasticsearch
The importer is located in the directory `importer`.

* Put the files to be imported into the `files` folder.
* Make a copy of the file `example-config.cfg` and rename it to `config.cfg`.
* Now adjust the variable `elasticsearch_indices_import_files` in the file `config.cfg`.
* Start the import script: `make importesinidices`
