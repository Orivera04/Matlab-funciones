function x=xa(y,p)
% © Jeney Andras 1998; programok az Integralok kiszamitasa reszhez

   a=p(1);
   b=p(2);
   x=-sqrt(a^2-(a/b*y)^2);

function x=xf(y,p)
  a=p(1);
  b=p(2);
  x=sqrt(a^2-(a/b*y)^2);
% az integral peldaja
 a=2;  b=3;
 V=quad8('integr',-b,b,[],[],[],[],'fxy','xa','xf',[a,b])