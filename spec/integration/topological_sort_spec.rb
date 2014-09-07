require_relative '../spec_helper'

describe 'TopologicalSort integration' do
  before :each do
    RestfulObjects::DomainModel.current.reset_objects
  end

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
end

