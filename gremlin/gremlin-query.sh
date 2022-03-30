#! /usr/bin/env bash

SERVER=$1
QUERY=$2

if [ "$#" -ne 2 ]; then
    echo "Usage:"
    echo "./gremlin-query.sh localhost 'g.V().elementMap()'"
    exit 1
fi

GREMLIN_SH=.gremlin-console/apache-tinkerpop-gremlin-console/bin/gremlin.sh

if [ ! -f $GREMLIN_SH ]; then
    echo "gremlin console not found! (run \`make download-gremlin-console\`?)"
    exit 1
fi

$GREMLIN_SH -e gremlin/query.groovy "$SERVER" "$QUERY"
