#!/bin/bash
. config.cfg
current_dir="${0%/*}"
echo "*****************************"
echo "STARTING ELASTICSEARCH IMPORT"
echo "*****************************"
echo "using config file $(pwd)/config.cfg"
echo "\n"
echo "set max_buckes to 20000"

docker exec -it ${ELASTICSEARCH_CONTAINER} curl -XPUT http://localhost:9200/_cluster/settings -d '
{
  "transient": {
    "search.max_buckets": 20000
  }
}' -H "Content-Type: application/json"


echo "\n"


for i in ${elasticsearch_indices_import_files[@]}
do
  elasticsearch_index="$(cut -d':' -f1 <<<$i)"
  file=$current_dir/"$(cut -d':' -f2 <<<$i)"
  echo "\n"
  echo "elasticsearch_index: $elasticsearch_index"
  echo "file: $file"
  echo "\n"
  echo "deleting index"
  curl -XDELETE http://localhost:9200/${elasticsearch_index}/
  echo "\n"
  echo "indexing data"
  curl -s -H "Content-Type: application/x-ndjson" -XPOST localhost:9200/${elasticsearch_index}/_bulk --data-binary "@${file}"
  echo "\n"
  echo "set max result window for index"
  curl -XPUT http://localhost:9200/${elasticsearch_index}/_settings -d '{ "index" : { "max_result_window" : 100000 } }' -H "Content-Type: application/json"
  echo "\n"
  echo "--------------------"
done

echo "\n"
echo "==> FINISHED ELASTICSEARCH IMPORT"