#!/bin/bash
mongo -u $MONGO_DB_USERNAME -p $MONGO_DB_PASSWORD <<EOF

db.createUser({
  user: 'mongouser',
  pwd: '$MONGO_DB_PASSWORD',
  roles: [{
    role: 'readWrite',
    db: '$MONGO_DB_DATABASE'
  }]
})
EOF