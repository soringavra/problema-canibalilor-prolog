stare_initiala(stare(0, 3, 0, 3, dr)).

stare_finala(stare(3, 0, 3, 0, stg)).

% Validarea starilor
in_siguranta(stare(CS, CD, MS, MD, _)) :-
    (MS > 0 -> MS >= CS ; true),
    (MD > 0 -> MD >= CD ; true),
    CS >= 0, CD >= 0, MS >= 0, MD >= 0.

% Mutarile posibile si aplicarea lor
mutare(1, 0).
mutare(2, 0).
mutare(0, 1).
mutare(0, 2).
mutare(1, 1).

traverseaza(stare(CS, CD, MS, MD, stg), stare(CS2, CD2, MS2, MD2, dr), mutare(DC, DM)) :-
    mutare(DC, DM),
    CS2 is CS - DC, CD2 is CD + DC,
    MS2 is MS - DM, MD2 is MD + DM,
    in_siguranta(stare(CS2, CD2, MS2, MD2, dr)).

traverseaza(stare(CS, CD, MS, MD, dr), stare(CS2, CD2, MS2, MD2, stg), mutare(DC, DM)) :-
    mutare(DC, DM),
    CS2 is CS + DC, CD2 is CD - DC,
    MS2 is MS + DM, MD2 is MD - DM,
    in_siguranta(stare(CS2, CD2, MS2, MD2, stg)).

% Algoritmul traseului - DFS si evitarea ciclurilor
traseu(StareFinala, _, []) :-
    stare_finala(StareFinala).

traseu(StareCurenta, Vizitate, [Mutare | RestPasi]) :-
    traverseaza(StareCurenta, StareUrmatoare, Mutare),
    \+ member(StareUrmatoare, Vizitate),
    traseu(StareUrmatoare, [StareUrmatoare | Vizitate], RestPasi).

% Afisare
afiseaza_pas(mutare(DC, DM), PozBarca) :-
    Total is DC + DM,
    (PozBarca = stg ->
        format("  Trec stg->dr: ~w canibal(i), ~w misionar(i) [~w pers.]~n", [DC, DM, Total])
    ;
        format("  Trec dr->stg: ~w canibal(i), ~w misionar(i) [~w pers.]~n", [DC, DM, Total])
    ).

afiseaza_solutie(_, []).
afiseaza_solutie(stare(CS, CD, MS, MD, Pos), [Mutare | Rest]) :-
    format("Stare: stg(~w C, ~w M) | barca ~w | dr(~w C, ~w M)~n", [CS, MS, Pos, CD, MD]),
    afiseaza_pas(Mutare, Pos),
    once(traverseaza(stare(CS, CD, MS, MD, Pos), StareUrm, Mutare)),
    afiseaza_solutie(StareUrm, Rest).

% Main
main :-
    stare_initiala(StareInit),
    once(traseu(StareInit, [StareInit], Pasi)),
    length(Pasi, N),
    format("~nSolutie gasita in ~w pasi:~n~n", [N]),
    afiseaza_solutie(StareInit, Pasi),
    stare_finala(stare(CS, CD, MS, MD, Pos)),
    format("Stare: stg(~w C, ~w M) | barca ~w | dr(~w C, ~w M)~n", [CS, MS, Pos, CD, MD]),
    format("~nToti au trecut in siguranta pe malul stang!~n").