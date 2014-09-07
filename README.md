### Restful Objects - Topological sort app
Example application that uses the [Restful Objects for Ruby framework](https://github.com/vizcay/RestfulObjectsRuby).

### Live demo
This project is running live as a free Heroku app at [http://topological-sort.herokuapp.com](http://topological-sort.herokuapp.com).

### Running locally - step by step
* Be sure you have a running ruby environment of at least 1.9.3 or higher:

```shell
$ ruby -v
ruby 1.9.3p448 (2013-06-27 revision 41675) [x86_64-linux]
```
If not [install ruby](https://www.ruby-lang.org/en/installation/) first.

* Bundler is the gem library manager for Ruby, check it is installed:

```shell
$ bundle -v
Bundler version 1.3.5
```

If not, install it by running:

```shell
$ gem install bundler
```

* Clone this repository with git:

```shell
$ git clone https://github.com/vizcay/ro_topological_sort.git
```

* Start the application server

```shell
$ cd ro_topological_sort
$ bundle exec restful_server.rb topological_sort.rb
[2014-09-07 01:42:52] INFO  WEBrick 1.3.1
[2014-09-07 01:42:52] INFO  ruby 1.9.3 (2013-06-27) [x86_64-linux]
== Sinatra/1.4.4 has taken the stage on 4567 for development with backup from WEBrick
[2014-09-07 01:42:52] INFO  WEBrick::HTTPServer#start: pid=10116 port=4567
```

As you can see it's running at http://localhost:4567 you can play with it now.

### Topological sort
This example executes the topological sort algorithm at a Graph, for example:

```ruby
it 'should solve simple dependency problem' do
  graph = Graph.new
  a = graph.add_node('A')
  b = graph.add_node('B')
  c = graph.add_node('C')

  b.dependencies << a
  c.dependencies << b

  expect(graph.topological_sort.map { |n| n.label }).to eq ['A', 'B', 'C']
end
```

This is the same code executed throught the http api:

```ruby
it 'should solve simple dependencies' do
  get '/services/GraphFactory/actions/create/invoke'
  graph_url = JSON.parse(last_response.body)['result']['links'].find { |link| link['rel'] == 'self' }['href']

  get graph_url + '/actions/add_node/invoke', {}, { input: { 'label' => {'value' => 'A'} }.to_json }
  n1_url = JSON.parse(last_response.body)['result']['links'].find { |link| link['rel'] == 'self' }['href']

  get graph_url + '/actions/add_node/invoke', {}, { input: { 'label' => {'value' => 'B'} }.to_json }
  n2_url = JSON.parse(last_response.body)['result']['links'].find { |link| link['rel'] == 'self' }['href']

  get graph_url + '/actions/add_node/invoke', {}, { input: { 'label' => {'value' => 'C'} }.to_json }
  n3_url = JSON.parse(last_response.body)['result']['links'].find { |link| link['rel'] == 'self' }['href']

  put n2_url + '/collections/dependencies', {}, { input: { 'value' => { 'href' => n1_url } }.to_json }
  put n3_url + '/collections/dependencies', {}, { input: { 'value' => { 'href' => n2_url } }.to_json }

  get graph_url + '/actions/topological_sort/invoke'
  labels = JSON.parse(last_response.body)['result']['value'].map do |node|
     get node['href']
     JSON.parse(last_response.body)['members']['label']['value']
  end

  expect(labels).to eq ['A', 'B', 'C']
end
```

### Resources
- [Restful Objects Spec](http://restfulobjects.org/)
- [Introduction to Restful Objects](http://www.infoq.com/articles/Intro_Restful_Objects)

### License
MIT License.

### Credits
This project has been developed as the main subject of Pablo Vizcay undergradute System's Engineering thesis, directed by [Dr. Alejandro Zunino](http://azunino.sites.exa.unicen.edu.ar/) for the [U.N.I.C.E.N. University in Tandil - Buenos Aires - Argentina](http://www.exa.unicen.edu.ar/).

