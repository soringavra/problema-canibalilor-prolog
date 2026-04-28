:- initialization(solve, main).
% stare(NCanibaliStg, NCanibaliDr, NMisionariStg, NMisionariDr, PozitieBarca)
% Starea initiala: toti pe stanga, barca pe stanga
stare_initiala(stare(3, 0, 3, 0, stg)).

% Starea finala: toti pe dreapta
stare_finala(stare(0, 3, 0, 3, dr)).

% Validarea starii - nimeni nu e in pericol
in_siguranta(stare(CS, CD, MS, MD, _)) :-
    % Stanga: daca exista misionari, sa fie >= canibali
    (MS > 0 -> MS >= CS ; true),
    % Dreapta: daca exista misionari, sa fie >= canibali
    (MD > 0 -> MD >= CD ; true),
    % Valori nenegative
    CS >= 0, CD >= 0, MS >= 0, MD >= 0.

% Mutari posibile (1-2 persoane in barca)
% (DeltaCanibali, DeltaMisionari)
mutare(1, 0).
mutare(2, 0).
mutare(0, 1).
mutare(0, 2).
mutare(1, 1).

% Aplica mutarea si verifica starea rezultata
traverseaza(stare(CS, CD, MS, MD, stg), stare(CS2, CD2, MS2, MD2, dr), Mutare) :-
    mutare(DC, DM),
    Mutare = mutare(DC, DM),
    CS2 is CS - DC,
    CD2 is CD + DC,
    MS2 is MS - DM,
    MD2 is MD + DM,
    in_siguranta(stare(CS2, CD2, MS2, MD2, dr)).

traverseaza(stare(CS, CD, MS, MD, dr), stare(CS2, CD2, MS2, MD2, stg), Mutare) :-
    mutare(DC, DM),
    Mutare = mutare(DC, DM),
    CS2 is CS + DC,
    CD2 is CD - DC,
    MS2 is MS + DM,
    MD2 is MD - DM,
    in_siguranta(stare(CS2, CD2, MS2, MD2, stg)).

% DFS cu evitarea ciclurilor
% traseu(StareaCurenta, StariVizitate, Pasi)
traseu(StareFinala, _, []) :-
    stare_finala(StareFinala).

traseu(StareCurenta, Vizitate, [Mutare | RestPasi]) :-
    traverseaza(StareCurenta, StareUrmatoare, Mutare),
    \+ member(StareUrmatoare, Vizitate),
    traseu(StareUrmatoare, [StareUrmatoare | Vizitate], RestPasi).

% Afisarea rezultatului
afiseaza_pas(mutare(DC, DM), PozBarca) :-
    Total is DC + DM,
    (PozBarca = stg ->
        format("  Trec de pe stanga pe dreapta: ~w canibal(i), ~w misionar(i) [~w persoana(e)]~n",
               [DC, DM, Total]);
        format("  Trec de pe dreapta pe stanga: ~w canibal(i), ~w misionar(i) [~w persoana(e)]~n",
               [DC, DM, Total])
    ).

afiseaza_solutie(_, []).
afiseaza_solutie(stare(CS, CD, MS, MD, Pos), [Mutare | Rest]) :-
    format("Stare: stg(~w C, ~w M) | barca ~w | dr(~w C, ~w M)~n",
           [CS, MS, Pos, CD, MD]),
    afiseaza_pas(Mutare, Pos),
    traverseaza(stare(CS, CD, MS, MD, Pos), StareUrm, Mutare),
    afiseaza_solutie(StareUrm, Rest).

% Predicatul principal
solve :-
    stare_initiala(StareInit),
    traseu(StareInit, [StareInit], Pasi),
    length(Pasi, N),
    format("~nSolutie gasita in ~w pasi:~n~n", [N]),
    afiseaza_solutie(StareInit, Pasi),
    stare_finala(StareFinala),
    format("Stare: ~w~n", [StareFinala]),
    format("~nToti au trecut in siguranta!~n").