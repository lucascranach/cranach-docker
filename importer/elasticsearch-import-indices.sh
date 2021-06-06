#!/bin/bash
. config.cfg
current_dir="${0%/*}"
echo "*****************************"
echo "STARTING ELASTICSEARCH IMPORT"
echo "*****************************"
echo "using config file $(pwd)/config.cfg"
echo "\n"
echo "set max_buckes to 20000"


for i in ${elasticsearch_indices_import_files[@]}
do
  # elasticsearch_index="$(cut -d':' -f1 <<<$i)"

  elasticsearch_index="$(cut -d':' -f1 <<< $i)";
  file=$current_dir/"$(cut -d':' -f2 <<<$i)"

  echo "deleting index"
  curl --user ${ELASTICSEARCH_USERNAME}:${ELASTICSEARCH_PASSWORD} -XDELETE http://${ELASTICSEARCH_HOST}/${elasticsearch_index}/

  echo "creating index and setting mappings"
  curl --user ${ELASTICSEARCH_USERNAME}:${ELASTICSEARCH_PASSWORD} -XPUT http://${ELASTICSEARCH_HOST}/${elasticsearch_index}/ -d '{
  "settings" : { "number_of_shards" : 1, "max_result_window" : 100000, "index.requests.cache.enable": true, "index.queries.cache.enabled": true },
}' -H "Content-Type: application/json"

  echo ""
  echo "------------------------------"

  echo ""
  echo "elasticsearch_index: $elasticsearch_index"
  echo "file: $file"
  echo ""
  echo ""
  echo "indexing data"
  curl  --user ${ELASTICSEARCH_USERNAME}:${ELASTICSEARCH_PASSWORD} -s -H "Content-Type: application/x-ndjson" -XPOST ${ELASTICSEARCH_HOST}/${elasticsearch_index}/_bulk --data-binary "@${file}"
  echo ""
  echo "set max result window for index"
  curl  --user ${ELASTICSEARCH_USERNAME}:${ELASTICSEARCH_PASSWORD} -XPUT http://${ELASTICSEARCH_HOST}/${elasticsearch_index}/_settings -d '{ "index" : { "max_result_window" : 100000 } }' -H "Content-Type: application/json"
  echo ""
  echo "--------------------"
done

echo ""
echo "==> FINISHED ELASTICSEARCH IMPORT"