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
docker-compose build
```

Run the containers
```shell
docker-compose up -d
```

For debugging run the containers without detached mode
```shell
docker-compose up
```

Stop the containers
```shell
docker-compose stop
```

### Start and Stop the containers on a remote server
To start and stop the containers on a remote server, you can use the following commands:

Login to the remote server
```shell
ssh -l <username> mivs02.gm.fh-koeln.de
```
Navigate to the directory where the `docker-compose.yml` file is located
```shell
cd /var/lucascranach/cranach-docker/
```

Start the containers
```shell
docker-compose -f docker-compose.yml -f docker-compose.prod.yml up -d
```

Stop the containers
```shell
docker-compose stop
```

## Kibana Service Account Setup

### Background
Starting with Elasticsearch 8.0, Kibana can no longer use the `elastic` superuser account for authentication. This is because the superuser account does not have write access to system indices that Kibana requires. Instead, a service account token must be used.

### Setup Steps

#### 1. Start Elasticsearch Container (without Kibana)
First, start only the Elasticsearch container:

```bash
docker compose up -d elasticsearch
```

Wait approximately 30 seconds for Elasticsearch to fully start.

#### 2. Create Service Token for Kibana

Run the following command to generate a service token for Kibana:

```bash
docker exec -it cranach-es bin/elasticsearch-service-tokens create elastic/kibana kibana-token
```

**Important:** Note down the generated token! It will only be displayed once and has the following format:
```
SERVICE_TOKEN elastic/kibana/kibana-token = AAEAAWVsYXN0aWM...
```

#### 3. Add Token to .env File

Open the `.env` file and replace `REPLACE_WITH_GENERATED_TOKEN` with the generated token:

```bash
KIBANA_SERVICE_TOKEN=AAEAAWVsYXN0aWM...
```

The complete token string (starting with `AAE...`) must be entered.

#### 4. Start All Containers

Now you can start all containers:

```bash
docker compose up -d
```

Kibana should now successfully authenticate using the service account token.

#### 5. Verification

Check the Kibana logs:

```bash
docker logs cranach-kibana
```

You should no longer see any authentication errors.

### Additional Token Management

#### List All Service Tokens

To view all existing service tokens:

```bash
docker exec -it cranach-es bin/elasticsearch-service-tokens list
```

#### Delete Existing Token (optional)

If you need to delete a token:

```bash
docker exec -it cranach-es bin/elasticsearch-service-tokens delete elastic/kibana kibana-token
```

#### Create New Token

To create a new token:

```bash
docker exec -it cranach-es bin/elasticsearch-service-tokens create elastic/kibana kibana-token
```

### Further Information

- [Elasticsearch Service Accounts Documentation](https://www.elastic.co/guide/en/elasticsearch/reference/8.0/service-accounts.html)
- The `elastic/kibana` service account is predefined and specifically designated for Kibana
- Service tokens do not expire and must be manually deleted when no longer needed
- Multiple tokens can be created per service account (useful for multiple Kibana instances)


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
1. stop reverse proxy container
```shell
cd /var/lucascranach/cranach-docker/ && docker-compose stop reverse-proxy
```
2. Renew certificate
```shell
sudo certbot certonly --standalone --preferred-challenges http  -d mivs02.gm.fh-koeln.de
```
3. start reverse proxy
```shell
cd /var/lucascranach/cranach-docker/ && sudo docker-compose -f docker-compose.yml -f docker-compose.prod.yml up -d reverse-proxy
```


