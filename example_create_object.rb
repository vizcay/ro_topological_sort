require 'net/http'
require 'json'

Net::HTTP.start('localhost', 4567) do |http|
  response = http.post('/objects/Nodo', '{ "members": { "nombre": { "value": "Assembler" } } }')
  puts JSON.pretty_generate(JSON.parse(response.body))
end
