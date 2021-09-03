#!/bin/bash
. config.cfg
current_dir="${0%/*}"
if [ "$1" = "dev" ]; then
  import_config=${elasticsearch_dev_indices_import_files[@]}
else
  import_config=${elasticsearch_indices_import_files[@]}
fi

echo $import_config;
echo -e "*****************************"
echo -e "STARTING ELASTICSEARCH IMPORT"
echo -e "*****************************"
echo -e "using config file $(pwd)/config.cfg"
echo -e "\n"
echo -e "set max_buckes to 20000"


for i in $import_config[@]
do
  elasticsearch_index="$(cut -d':' -f1 <<<$i)"
   echo -e "deleting index"
  curl --user ${ELASTICSEARCH_USERNAME}:${ELASTICSEARCH_PASSWORD} -XDELETE http://${ELASTICSEARCH_HOST}/${elasticsearch_index}/
done

echo -e "\n"
echo -e "------------------------------"


for i in $import_config[@]
do
  elasticsearch_index="$(cut -d':' -f1 <<<$i)"
  echo -e "creating index and setting mappings"
  curl --user ${ELASTICSEARCH_USERNAME}:${ELASTICSEARCH_PASSWORD} -XPUT http://${ELASTICSEARCH_HOST}/${elasticsearch_index}/ -d '{
    "settings" : { "number_of_shards" : 1, "max_result_window" : 300000, "index.requests.cache.enable": true, "index.queries.cache.enabled": true },
    "mappings": {
      "properties": {
        "involvedPersons": {
          "type": "nested",
          "properties": {
            "name": {
              "type": "keyword"
            }
          }
        }
      }
    }
  }' -H "Content-Type: application/json"
done



for i in $import_config[@]
do
  elasticsearch_index="$(cut -d':' -f1 <<<$i)"
  file=$current_dir/"$(cut -d':' -f2 <<<$i)"
  echo -e "\n"
  echo -e "elasticsearch_index: $elasticsearch_index"
  echo -e "file: $file"
  echo -e "\n"
  echo -e "\n"
  echo -e "indexing data"
  curl  --user ${ELASTICSEARCH_USERNAME}:${ELASTICSEARCH_PASSWORD} -s -H "Content-Type: application/x-ndjson" -XPOST ${ELASTICSEARCH_HOST}/${elasticsearch_index}/_bulk --data-binary "@${file}"
  echo -e "\n"
  echo -e "set max result window for index"
  curl  --user ${ELASTICSEARCH_USERNAME}:${ELASTICSEARCH_PASSWORD} -XPUT http://${ELASTICSEARCH_HOST}/${elasticsearch_index}/_settings -d '{ "index" : { "max_result_window" : 100000 } }' -H "Content-Type: application/json"
  echo -e "\n"
  echo -e "--------------------"
done

echo -e "\n"
echo -e "==> FINISHED ELASTICSEARCH IMPORT"