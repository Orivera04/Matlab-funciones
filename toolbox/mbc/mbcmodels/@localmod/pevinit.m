function L= pevinit(L,Xfitdata,Yfitdata);
% LOCALMOD/PEVINIT

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%   $Revision: 1.4.4.2 $  $Date: 2004/02/09 07:39:35 $



[Xd,Y]= checkdata(L,Xfitdata,Yfitdata);
% Xd{1}= code(L,Xd{1});
df= (size(Y,1)-size(L,1));
[Xd,Y]= symmetric(L,double(Xd),double(Y));
if ~isempty(L.covmodel);
   yhat= eval(L,Xd);
   if isTBS(L)
      yhat= ytrans(L,yhat);
   end
   Wc= choltinv(L.covmodel,yhat,Xd);
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

[J,P]=xregprecond(J);
[Q,R,OK]= xregqr(J);

if OK
	ri= (P/R)*sqrt(s2);
else
	ri= NaN*R;
	s2= NaN;
end
L= var(L,ri,s2,df);
