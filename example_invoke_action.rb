require 'net/http'
require 'json'

Net::HTTP.start('localhost', 4567) do |http|
  response = http.post('/objects/Grafo', '{ "members": { } }')
  grafo_id = JSON.parse(response.body)['instanceId']

  action_invoke_url = "/objects/Grafo/#{grafo_id}/actions/agregar_nodo/invoke"
  response = http.post(action_invoke_url, '{ "nombre": { "value": "Fortran" } }')
  action_result = JSON.parse(response.body)

  puts 'Title: ' + action_result['result']['title']
  puts 'InstanceId: ' + action_result['result']['instanceId']
end
