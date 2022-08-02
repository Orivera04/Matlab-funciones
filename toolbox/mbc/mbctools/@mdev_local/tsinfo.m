function [TS,mdev]= tsinfo(mdev,TS);
% MDEV_LOCAL/TSINFO sets twostage code and symbols from data

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 08:05:15 $

[Bnd,g,Tgt]= getcode(TS);
if ((Tgt(1,1)==0 | Tgt(1,1)==-1) & Tgt(1,2)==1);
   
   % mdev= localinfo(mdev);
   L= model(mdev);
   nl= nfactors(L);
   [BndL,gL,TgtL]= getcode(L);
   Bnd(1:nl,:)=BndL;
   g(1:nl)=gL;
   Tgt(1:nl,:)= TgtL;
   TS= setcode(TS,Bnd,g,Tgt);
   
   TS= yinfo(TS,yinfo(L));
   
   xli= xinfo(L);
   xtsi= xinfo(TS);
   xtsi.Names(1:nl)= xli.Names;
   xtsi.Units(1:nl)= xli.Units;
   xtsi.Symbols(1:nl)= xli.Symbols;
   
   TS= xinfo(TS,xtsi);
   
   [Xg,Yrf,Sigma]= mledata(mdev,1);
   % init for pev
   TS= pevinit(TS,Xg,Yrf,Sigma);
   % update mdev
end
