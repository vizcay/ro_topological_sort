require 'restful_objects'

class Node
  include RestfulObjects::Object

  property   :label,        :string
  property   :visited,      :bool
  collection :dependencies, Node
end

class Graph
  include RestfulObjects::Object

  collection :nodes, Node
  action :topological_sort, return_type: { list: Node }
  action :add_node,         return_type: { object: Node }, parameters: { label: :string }

  def add_node(label)
    n = Node.new
    n.label = label
    nodes << n
    n
  end

  def topological_sort
    list = []
    nodes.each { |node| node.visited = false }
    unvisited_nodes = nodes
    while not unvisited_nodes.empty? do
      visit(unvisited_nodes.pop, list)
    end
    list
  end

  private

  def visit(node, list)
    if !node.visited
      node.dependencies.each { |dependent_node| visit(dependent_node, list) }
      node.visited = true
      list << node
    end
  end
end

class GraphFactory
  include RestfulObjects::Service

  action :create, return_type: { object: Graph }

  def create
    Graph.new
  end
end

