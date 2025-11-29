% ------------------------------
% Base de conocimiento: Pokémons
% ------------------------------
% Hechos: pokemon(Nombre).
%        tipo(Pokemon, Tipo).
%        evoluciona_a(PokemonAnterior, PokemonSiguiente).
%        nivel_para_evolucion(Pokemon, Nivel).
%        capturado_por(Pokemon, Entrenador).
%
% Reglas: evolucion_transitiva/2, misma_linea/2, mismo_tipo/2,
%        puede_evolucionar_a_nivel/2, ancestro/2

% Pokémons (ejemplos)
pokemon(bulbasaur).
pokemon(ivysaur).
pokemon(venusaur).
pokemon(charmander).
pokemon(charmeleon).
pokemon(charizard).
pokemon(squirtle).
pokemon(wartortle).
pokemon(blastoise).
pokemon(pichu).
pokemon(pikachu).
pokemon(raichu).

% Tipos
tipo(bulbasaur, planta).
tipo(ivysaur, planta).
tipo(venusaur, planta).
tipo(charmander, fuego).
tipo(charmeleon, fuego).
tipo(charizard, fuego).
tipo(squirtle, agua).
tipo(wartortle, agua).
tipo(blastoise, agua).
tipo(pichu, electrico).
tipo(pikachu, electrico).
tipo(raichu, electrico).

% Evoluciones directas
evoluciona_a(bulbasaur, ivysaur).
evoluciona_a(ivysaur, venusaur).
evoluciona_a(charmander, charmeleon).
evoluciona_a(charmeleon, charizard).
evoluciona_a(squirtle, wartortle).
evoluciona_a(wartortle, blastoise).
evoluciona_a(pichu, pikachu).
evoluciona_a(pikachu, raichu).

% Nivel mínimo para evolucionar (cuando aplica)
nivel_para_evolucion(ivysaur, 16).
nivel_para_evolucion(venusaur, 32).
nivel_para_evolucion(charmeleon, 16).
nivel_para_evolucion(charizard, 36).
nivel_para_evolucion(wartortle, 16).
nivel_para_evolucion(blastoise, 36).
nivel_para_evolucion(pikachu, 20).
nivel_para_evolucion(raichu, 999). % ejemplo: Raichu no evoluciona más

% Quién capturó a cada Pokémon (ejemplo)
capturado_por(pikachu, ash).
capturado_por(charmander, misty). % solo ejemplo pedagógico

% ------------------------------
% Reglas / consultas básicas
% ------------------------------

% evolucion_transitiva(A,B): A evoluciona a B en 1 o más pasos.
evolucion_transitiva(A,B) :-
    evoluciona_a(A,B).
evolucion_transitiva(A,B) :-
    evoluciona_a(A,C),
    evolucion_transitiva(C,B).

% ancestro(A,B): A es ancestro evolutivo (misma idea que evolucion_transitiva)
ancestro(A,B) :- evolucion_transitiva(A,B).

% misma_linea(A,B): A y B pertenecen a la misma línea evolutiva (comparten ancestro común).
mismo_ancestro(A,B,Anc) :-
    (evolucion_transitiva(Anc,A) ; Anc = A),
    (evolucion_transitiva(Anc,B) ; Anc = B).

misma_linea(A,B) :-
    A \= B,
    pokemon(A), pokemon(B),
    mismo_ancestro(A,B,_Anc).

% mismo_tipo(A,B): comparten tipo
mismo_tipo(A,B) :-
    tipo(A, T), tipo(B, T), A \= B.

% puede_evolucionar_a_nivel(A, Nivel): True si A puede (por camino trans.) evolucionar a algún B que requiere <= Nivel
puede_evolucionar_a_nivel(A, NivelUsuario) :-
    evolucion_transitiva(A,B),
    nivel_para_evolucion(B, NivelReq),
    NivelReq =< NivelUsuario.

% lista_linea(A, Lista): devuelve la línea evolutiva (desde el ancestro hasta la última)
% estrategia simple: encontrar ancestro más alto (no exhaustiva para todas las ramas)
ancestro_mas_alto(X, X) :-
    \+ (evoluciona_a(_, X)). % si nada evoluciona hacia X, X es ancestro superior
ancestro_mas_alto(X, Top) :-
    evoluciona_a(Y, X),
    ancestro_mas_alto(Y, Top).

lista_linea(A, Linea) :-
    ancestro_mas_alto(A, Top),
    construir_linea(Top, Linea).

construir_linea(X, [X|Resto]) :-
    evoluciona_a(X, Y),
    construir_linea(Y, Resto).
construir_linea(X, [X]) :-
    \+ evoluciona_a(X, _).

% ejemplo de regla compuesta: es_fuertemente_tipo(A, T) (si A es de tipo T y su linea completa es T)
es_fuertemente_tipo(A, T) :-
    lista_linea(A, Linea),
    forall(member(P, Linea), tipo(P, T)).

