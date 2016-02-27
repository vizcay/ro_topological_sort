require 'net/http'
require 'json'

Net::HTTP.start('localhost', 4567) do |http|
  response = http.post('/objects/Grafo', '{ "members": {} }')
  grafo_id = JSON.parse(response.body)['instanceId']

  agregar_nodo_url = "/objects/Grafo/#{grafo_id}/actions/agregar_nodo/invoke"
  response         = http.post(agregar_nodo_url, '{ "nombre": { "value": "Assembler" } }')
  assembler_id     = JSON.parse(response.body)['result']['instanceId']
  response         = http.post(agregar_nodo_url, '{ "nombre": { "value": "Fortran" } }')
  fortran_id       = JSON.parse(response.body)['result']['instanceId']
  response         = http.post(agregar_nodo_url, '{ "nombre": { "value": "C" } }')
  c_id             = JSON.parse(response.body)['result']['instanceId']
  response         = http.post(agregar_nodo_url, '{ "nombre": { "value": "LISP" } }')
  lisp_id          = JSON.parse(response.body)['result']['instanceId']
  response         = http.post(agregar_nodo_url, '{ "nombre": { "value": "Smalltalk" } }')
  smalltalk_id     = JSON.parse(response.body)['result']['instanceId']
  response         = http.post(agregar_nodo_url, '{ "nombre": { "value": "Perl" } }')
  perl_id          = JSON.parse(response.body)['result']['instanceId']
  response         = http.post(agregar_nodo_url, '{ "nombre": { "value": "Ruby" } }')
  ruby_id          = JSON.parse(response.body)['result']['instanceId']

  http.post("/objects/Nodo/#{fortran_id}/collections/dependencias",
            '{ "value": { "href": "http://localhost:4567/objects/Nodo/' + assembler_id + '" } }')
  http.post("/objects/Nodo/#{c_id}/collections/dependencias",
            '{ "value": { "href": "http://localhost:4567/objects/Nodo/' + assembler_id + '" } }')
  http.post("/objects/Nodo/#{c_id}/collections/dependencias",
            '{ "value": { "href": "http://localhost:4567/objects/Nodo/' + fortran_id + '" } }')
  http.post("/objects/Nodo/#{lisp_id}/collections/dependencias",
            '{ "value": { "href": "http://localhost:4567/objects/Nodo/' + assembler_id + '" } }')
  http.post("/objects/Nodo/#{smalltalk_id}/collections/dependencias",
            '{ "value": { "href": "http://localhost:4567/objects/Nodo/' + fortran_id + '" } }')
  http.post("/objects/Nodo/#{perl_id}/collections/dependencias",
            '{ "value": { "href": "http://localhost:4567/objects/Nodo/' + c_id + '" } }')
  http.post("/objects/Nodo/#{ruby_id}/collections/dependencias",
            '{ "value": { "href": "http://localhost:4567/objects/Nodo/' + smalltalk_id + '" } }')
  http.post("/objects/Nodo/#{ruby_id}/collections/dependencias",
            '{ "value": { "href": "http://localhost:4567/objects/Nodo/' + lisp_id + '" } }')
  http.post("/objects/Nodo/#{ruby_id}/collections/dependencias",
                       '{ "value": { "href": "http://localhost:4567/objects/Nodo/' + perl_id + '" } }')

  response = http.get("/objects/Grafo/#{grafo_id}/actions/ordenamiento_topologico/invoke")
  JSON.parse(response.body)['result']['value'].each do |nodo|
    puts nodo['title']
  end
end
