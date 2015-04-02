class Nodo
  attr_accessor :nombre, :dependencias, :visitado

  def initialize(nombre, dependencias = [])
    @nombre       = nombre
    @dependencias = dependencias
    @visitado     = false
  end

  def to_s
    @nombre
  end
end

class Grafo
  attr_accessor :nodos, :lista_ordenada

  def initialize
    @nodos = []
  end

  def ordenamiento_topologico
    @lista_ordenada = []
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
