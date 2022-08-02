function i=interval(l,u)
% © Dunay Rezs''o 1998; program az Uj adattipusok c. reszhez
% INTERVAL Intervallum oszt\a'aly konstruktora
% i=interval(l,u) l\a'etrehoz egy intervallum objektumot az
% l \a'es az u als\a'o \a'es fels\H o hat\a'arokkal.
% i=interval(l) (ahol l double t\a'{\i}pus\a'u) ugyanaz, mint
% i=interval(l,l)

if  nargin == 0
 i.l=[];
 i.u=[];
 i=class\index{class}(i,'interval');
elseif isa(l,'interval')
 i=l;
else
 i.l=l;
 if nargin>1
  i.u=u;
 else
  i.u=l;
 end
 i=class(i,'interval');
end