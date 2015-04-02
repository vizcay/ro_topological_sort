require 'restful_objects'

class Nodo
  include RestfulObjects::Object

  attr_accessor :visitado

  property :nombre, :string
  property :creado_en, :date
  collection :dependencias, Nodo

  def initialize()
    super
    @visitado = false
  end

  def to_s
    @nombre
  end
end
