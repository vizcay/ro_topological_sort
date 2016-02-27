require 'net/http'
require 'json'

Net::HTTP.start('localhost', 4567) do |http|
  response = http.post('/objects/Nodo', '{ "members": {} }')
  nodo_id = JSON.parse(response.body)['instanceId']

  language = ['Assembler', 'C', 'Fortran', 'Lisp', 'Smalltalk', 'Perl', 'Ruby'].sample
  http.put("/objects/Nodo/#{nodo_id}/properties/nombre", '{ "value": "' + language + '" }')

  response = http.get("/objects/Nodo/#{nodo_id}/properties/nombre")
  puts 'Nombre: ' + JSON.parse(response.body)['nombre']['value']
end
