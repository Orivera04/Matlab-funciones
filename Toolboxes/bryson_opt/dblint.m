function sp=dblint(t,s,flg,am)
% min time paths for double integrator plant from (x,v) to (0,0) with
% |a|\leq am;                                                  7/30/98
%
x=s(1); v=s(2);
if v>=0 & 2*am*x>=-v^2, a=-am;
elseif v>=0 & 2*am*x<-v^2, a=am;
elseif v<0 & 2*am*x>=v^2, a=am;
elseif v<0 & 2*am*x<v^2, a=-am;
end;
sp=[v a]';

  
