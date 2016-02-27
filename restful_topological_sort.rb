require 'restful_objects'

class Nodo
  include RestfulObjects::Object

  property :nombre, :string
  collection :dependencias, Nodo
  attr_accessor :visitado

  def initialize
    super
    @visitado = false
  end

  def nombre=(value)
    @nombre = @title = value
  end
end

class Grafo
  include RestfulObjects::Object

  collection :nodos, Nodo
  action :agregar_nodo, return_type: { object: Nodo }, parameters: { nombre: :string }
  action :ordenamiento_topologico, return_type: { list: Nodo }

  def agregar_nodo(nombre)
    nodo = Nodo.new
    nodos.nombre = nombre
    nodos << nodo
    return nodo
  end

  def ordenamiento_topologico
    @lista_ordenada = []
    nodos.each { |nodo| nodo.visitado = false }
    nodos_sin_visitar = nodos.dup
    until nodos_sin_visitar.empty? do
      visitar(nodos_sin_visitar.pop)
    end
    @lista_ordenada
  end

  private

  def visitar(nodo)
    unless nodo.visitado
      nodo.dependencias.each do |dependencia|
        visitar(dependencia)
      end
      nodo.visitado = true
      @lista_ordenada << nodo
    end
  end
end
