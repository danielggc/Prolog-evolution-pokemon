Abre SWI-Prolog y carga el archivo:

?- [pokemons].
?- lista_linea(pikachu, L).
L = [pichu, pikachu, raichu].

?- mismo_tipo(charmander, X).
X = charmeleon ;
X = charizard.


?- puede_evolucionar_a_nivel(pichu, 20).
true.