#!/bin/bash

GRAFO_ID=`echo '{ "members": { } }' | curl http://localhost:4567/objects/Grafo --silent --data @- | jq .instanceId | tr -d '"'`

ASSEMBLER='{ "nombre": { "value": "Assembler" } }'
FORTRAN='{ "nombre": { "value": "Fortran" } }'
C='{_ID "nombre": { "value": "C" } }'
LISP='{ "nombre": { "value": "LISP" } }'
SMALLTALK='{ "nombre": { "value": "Smalltalk" } }'
PERL='{ "nombre": { "value": "Perl" } }'
RUBY='{ "nombre": { "value": "Ruby" } }'

ASSEMBLER_ID=`echo $ASSEMBLER | curl --silent --data @- http://localhost:4567/objects/Grafo/$GRAFO_ID/actions/agregar_nodo/invoke | jq .result.instanceId | tr -d '"'`
FORTRAN_ID=`echo $FORTRAN | curl --silent --data @- http://localhost:4567/objects/Grafo/$GRAFO_ID/actions/agregar_nodo/invoke | jq .result.instanceId | tr -d '"'`
C_ID=`echo $C | curl --silent --data @- http://localhost:4567/objects/Grafo/$GRAFO_ID/actions/agregar_nodo/invoke | jq .result.instanceId | tr -d '"'`
LISP_ID=`echo $LISP | curl --silent --data @- http://localhost:4567/objects/Grafo/$GRAFO_ID/actions/agregar_nodo/invoke | jq .result.instanceId | tr -d '"'`
SMALLTALK_ID=`echo $SMALLTALK | curl --silent --data @- http://localhost:4567/objects/Grafo/$GRAFO_ID/actions/agregar_nodo/invoke | jq .result.instanceId | tr -d '"'`
PERL_ID=`echo $PERL | curl --silent --data @- http://localhost:4567/objects/Grafo/$GRAFO_ID/actions/agregar_nodo/invoke | jq .result.instanceId | tr -d '"'`
RUBY_ID=`echo $RUBY | curl --silent --data @- http://localhost:4567/objects/Grafo/$GRAFO_ID/actions/agregar_nodo/invoke | jq .result.instanceId | tr -d '"'`

REF_ASSEMBLER="{ \"value\": { \"href\": \"http://localhost:4567/objects/Nodo/$ASSEMBLER_ID\" } }"
REF_FORTRAN="{ \"value\": { \"href\": \"http://localhost:4567/objects/Nodo/$FORTRAN_ID\" } }"
REF_C="{ \"value\": { \"href\": \"http://localhost:4567/objects/Nodo/$C_ID\" } }"
REF_SMALLTALK="{ \"value\": { \"href\": \"http://localhost:4567/objects/Nodo/$SMALLTALK_ID\" } }"
REF_LISP="{ \"value\": { \"href\": \"http://localhost:4567/objects/Nodo/$LISP_ID\" } }"
REF_PERL="{ \"value\": { \"href\": \"http://localhost:4567/objects/Nodo/$PERL_ID\" } }"

echo $REF_ASSEMBLER | curl --silent --data @- http://localhost:4567/objects/Nodo/$FORTRAN_ID/collections/dependencias > /dev/null
echo $REF_ASSEMBLER | curl --silent --data @- http://localhost:4567/objects/Nodo/$C_ID/collections/dependencias > /dev/null
echo $REF_FORTRAN | curl --silent --data @- http://localhost:4567/objects/Nodo/$C_ID/collections/dependencias > /dev/null
echo $REF_ASSEMBLER | curl --silent --data @- http://localhost:4567/objects/Nodo/$LISP_ID/collections/dependencias > /dev/null
echo $REF_FORTRAN | curl --silent --data @- http://localhost:4567/objects/Nodo/$SMALLTALK_ID/collections/dependencias > /dev/null
echo $REF_C | curl --silent --data @- http://localhost:4567/objects/Nodo/$PERL_ID/collections/dependencias > /dev/null
echo $REF_SMALLTALK | curl --silent --data @- http://localhost:4567/objects/Nodo/$RUBY_ID/collections/dependencias > /dev/null
echo $REF_LISP | curl --silent --data @- http://localhost:4567/objects/Nodo/$RUBY_ID/collections/dependencias > /dev/null
echo $REF_PERL | curl --silent --data @- http://localhost:4567/objects/Nodo/$RUBY_ID/collections/dependencias > /dev/null

curl --silent http://localhost:4567/objects/Grafo/$GRAFO_ID/actions/ordenamiento_topologico/invoke | jq ".result.value | .[] | .title"
