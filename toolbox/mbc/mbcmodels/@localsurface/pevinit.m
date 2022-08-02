function L= pevinit(L,Xfitdata,Yfitdata);
% LOCALMOD/PEVINIT

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:42:25 $

[Xd,Y]= checkdata(L,Xfitdata,Yfitdata);
% Xd{1}= code(L,Xd{1});
df= (size(Y,1)-size(L,1));
[Xd,Y]= symmetric(L,double(Xd),double(Y));
c= covmodel(L);
if ~isempty(c);
   yhat= eval(L,Xd);
   if isTBS(L)
      yhat= ytrans(L,yhat);
   end
   Wc= choltinv(c,yhat,Xd);
   [r,J]= lsqcost(L,Xd,Y,Wc);
   if df>0
       s2= sum((r).^2)/df;
   else
       s2= 0;
   end
else
   [r,J]= lsqcost(L,Xd,Y);
   if df>0
       s2= sum((r).^2)/df;
   else
       s2= 0;
   end
end

in= linterms(L);
t= Terms(L.userdefined);
in = in(t);
J= J(:,in);

[J,P]=xregprecond(J);
[Q,R,OK]= xregqr(J);

ri= zeros(size(L,1));
if OK
	ri(in,in)= (P/R)*sqrt(s2);
else
	ri(:)= NaN;
	s2= NaN;
end
L= var(L,ri,s2,df);
