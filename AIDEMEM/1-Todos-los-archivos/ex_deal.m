a = ones(1, 3);                           % un tableau
[b, c, d] = deal(a)                       % r�pliqu� dans b, c et d
[e, f]   =  deal(a, 2*a)                  % a dans e,  2*a dans f
s = struct('nom',  'pipo', 'age', 25);    % une structure
[s(1:4)] = deal(s);                       % r�pliqu�
[s(2:3).nat] = deal('fran�ais');          % rajout d'un champ dans les 2 centraux
s(1).nat = 'italien';                     % affectation des deux restant
s(4).nat = 'belge';
for i = 1:4,  disp(s(i).nat),  end; 
[g{1:4}] = deal(s.nat)                    % mise des nationalit�s en cellules
[h, i, j, k] = deal(g{:})                 % mise en cha�nes individuelles


