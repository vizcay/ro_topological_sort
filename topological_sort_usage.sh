#!/bin/bash

SERVER=http://localhost:4567

# 1. Crear objecto Grafo
GRAFO='{ "members": { } }'
GRAFO_ID=`echo $GRAFO | curl $SERVER/objects/Grafo --silent --data @- | jq -r .instanceId`

# 2. Crear cada Nodo representando un lenguaje
ADD_NODO="$SERVER/objects/Grafo/$GRAFO_ID/actions/agregar_nodo/invoke"

ASSEMBLER='{ "nombre": { "value": "Assembler" } }'
ASSEMBLER_ID=`echo $ASSEMBLER | curl --silent --data @- $ADD_NODO | jq -r .result.instanceId`

FORTRAN='{ "nombre": { "value": "Fortran" } }'
FORTRAN_ID=`echo $FORTRAN | curl --silent --data @- $ADD_NODO | jq -r .result.instanceId`

C='{ "nombre": { "value": "C" } }'
C_ID=`echo $C | curl --silent --data @- $ADD_NODO | jq -r .result.instanceId`

LISP='{ "nombre": { "value": "LISP" } }'
LISP_ID=`echo $LISP | curl --silent --data @- $ADD_NODO | jq -r .result.instanceId`

SMALLTALK='{ "nombre": { "value": "Smalltalk" } }'
SMALLTALK_ID=`echo $SMALLTALK | curl --silent --data @- $ADD_NODO | jq -r .result.instanceId`

PERL='{ "nombre": { "value": "Perl" } }'
PERL_ID=`echo $PERL | curl --silent --data @- $ADD_NODO | jq -r .result.instanceId`

RUBY='{ "nombre": { "value": "Ruby" } }'
RUBY_ID=`echo $RUBY | curl --silent --data @- $ADD_NODO | jq -r .result.instanceId`

# 3. Agregar en las dependencias de cada lenguaje otro sobre el que se basó

REF_ASSEMBLER="{ \"value\": { \"href\": \"$SERVER/objects/Nodo/$ASSEMBLER_ID\" } }"
REF_FORTRAN="{ \"value\": { \"href\": \"$SERVER/objects/Nodo/$FORTRAN_ID\" } }"
REF_C="{ \"value\": { \"href\": \"$SERVER/objects/Nodo/$C_ID\" } }"
REF_SMALLTALK="{ \"value\": { \"href\": \"$SERVER/objects/Nodo/$SMALLTALK_ID\" } }"
REF_LISP="{ \"value\": { \"href\": \"$SERVER/objects/Nodo/$LISP_ID\" } }"
REF_PERL="{ \"value\": { \"href\": \"$SERVER/objects/Nodo/$PERL_ID\" } }"

NODO="$SERVER/objects/Nodo"
echo $REF_ASSEMBLER | curl --data @- $NODO/$FORTRAN_ID/collections/dependencias &> /dev/null
echo $REF_ASSEMBLER | curl --data @- $NODO/$C_ID/collections/dependencias &> /dev/null
echo $REF_FORTRAN | curl --data @- $NODO/$C_ID/collections/dependencias &> /dev/null
echo $REF_ASSEMBLER | curl --data @- $NODO/$LISP_ID/collections/dependencias &> /dev/null
echo $REF_FORTRAN | curl --data @- $NODO/$SMALLTALK_ID/collections/dependencias &> /dev/null
echo $REF_C | curl --data @- $NODO/$PERL_ID/collections/dependencias &> /dev/null
echo $REF_SMALLTALK | curl --data @- $NODO/$RUBY_ID/collections/dependencias &> /dev/null
echo $REF_LISP | curl --data @- $NODO/$RUBY_ID/collections/dependencias &> /dev/null
echo $REF_PERL | curl --data @- $NODO/$RUBY_ID/collections/dependencias &> /dev/null

# 4. Ejecutar la acción de ordenamiento topológico
RESULT=`curl --silent $SERVER/objects/Grafo/$GRAFO_ID/actions/ordenamiento_topologico/invoke`

# 5. Procesar JSON resultante, extrayendo solo el título de cada Nodo (lenguaje)
echo $RESULT | jq -r ".result.value | .[] | .title"
