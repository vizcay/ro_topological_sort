require 'net/http'
require 'json'

Net::HTTP.start('localhost', 4567) do |http|
  response = http.post('/objects/Grafo', '{ "members": { } }')
  grafo_id = JSON.parse(response.body)['instanceId']
  collection_url = "/objects/Grafo/#{grafo_id}/collections/nodos"

  response = http.post('/objects/Nodo', '{ "members": { "nombre": { "value": "Smalltalk" } } }')
  nodo_smalltalk = JSON.parse(response.body)['instanceId']

  http.post(collection_url,
    '{ "value": { "href": "http://localhost:4567/objects/Nodo/' + nodo_smalltalk + '" } }')

  response = http.get(collection_url)
  puts JSON.pretty_generate(JSON.parse(response.body)['value'])
end
