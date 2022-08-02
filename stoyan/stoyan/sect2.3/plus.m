function c=plus(a,b)
% © Dunay Rezs"o 1998; program az Uj adattipusok c. reszhez
% INTERVAL/PLUS a+b implement\a'al\a'asa intervallum t\a"omb\a"okre.

a=interval(a); % a param\a'eterek konvert\a'al\a'asa intervallum
               % objektumm\a'a} 
b=interval(b);
c=interval;    % \"ures objektum l\a'etrehoz\a'asa
c.l=a.l+b.l;
c.u=a.u+b.u;