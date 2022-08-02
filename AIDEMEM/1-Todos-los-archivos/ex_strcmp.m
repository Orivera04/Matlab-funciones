function  r = strcomp(s1, s2)
%STRCOMP    comparaison de deux cha�nes pour l'ordre  ASCII
%           r = strcomp(s1, s2)
%           s1 et s2 sont des cha�nes et r vaut
%           0  si s1 == s2,  -1  si s1 < s2, 1  si s1 > s2

l1 = length(s1);
l2 = length(s2);
% on compl�te la plus courte avec des 0 ASCII (nul)
if l1 < l2, s1 = [s1 zeros(1,l2-l1)]; else s2 = [s2 zeros(1,l1-l2)];end;
diffs = find(s1 ~= s2);    % l'indice du premier diff�rent est diffs(1)
if isempty(diffs)          % s'il n'existe pas
  r = 0;                   % �galit�
elseif abs(s1(diffs(1))) < abs(s2(diffs(1)))
  r = -1;                  % s1 < s2
else
  r = 1;                   % s1 > s2
end;
