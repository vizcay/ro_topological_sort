require_relative 'topological_sort'

grafo     = Grafo.new
assembler = Nodo.new('Assembler')
fortran   = Nodo.new('Fortran',   [assembler])
c         = Nodo.new('C',         [assembler, fortran])
lisp      = Nodo.new('Lisp',      [assembler])
smalltalk = Nodo.new('Smalltalk', [fortran])
perl      = Nodo.new('Perl',      [c])
ruby      = Nodo.new('Ruby',      [smalltalk, lisp, perl])
grafo.nodos << assembler << c << fortran << lisp << perl << ruby << smalltalk

puts grafo.ordenamiento_topologico
