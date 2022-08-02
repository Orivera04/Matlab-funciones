function [ki1,ki2] = argszam(be1,be2,be3)
% a program a bemeno es a kimeno parameterek szamat 
% adja vissza ugy, hogy ki1 a bemeno parameterek szama
% ki2 a kimeno parameterek szama
%
% © Molnarka Gy''oz''o 1998; program a Matlab programozasa c. reszhez

if nargin < 1  ki1=0;
   elseif nargin ==1 ki1=1; 
   elseif nargin ==2 ki1=2;
   else ki1=3;
end
if nargout < 1 ki2=0;
   elseif  nargout == 1 ki2=1;
   else ki2=2;
end