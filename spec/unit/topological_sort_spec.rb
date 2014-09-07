require_relative '../spec_helper'

describe 'TopologicalSort' do
  before :each do
    RestfulObjects::DomainModel.current.reset_objects
  end

  it 'should solve simple dependency problem' do
    graph = Graph.new
    a = graph.add_node('A')
    b = graph.add_node('B')
    c = graph.add_node('C')

    b.dependencies << a
    c.dependencies << b

    expect(graph.topological_sort.map { |n| n.label }).to eq ['A', 'B', 'C']
  end

  it 'should solve branch dependency problem' do
    graph = Graph.new
    a  = graph.add_node('A')
    b  = graph.add_node('B' ); b.dependencies  << a
    b1 = graph.add_node('B1'); b1.dependencies << b
    b2 = graph.add_node('B2'); b2.dependencies << b
    c  = graph.add_node('C' ); c.dependencies  << b2

    sort = graph.topological_sort.map { |n| n.label }

    expect(sort.index('A')).to  eq 0
    expect(sort.index('B')).to  eq 1
    expect(sort.index('B1')).to be > sort.index('B')
    expect(sort.index('B2')).to be > sort.index('B')
    expect(sort.index('B2')).to be < sort.index('C')
    expect(sort.index('C')).to  be > sort.index('B2')
  end
end

