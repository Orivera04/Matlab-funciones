function mdev= localinfo(mdev);
% MDEV_LOCAL/LOCALINFO sets local code and symbols from data

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 08:04:39 $

warning('Obsolete file')
return
L= model(mdev);
[Bnd,g,Tgt]= getcode(L);
if ((Tgt(1,1)==0 | Tgt(1,1)==-1) & Tgt(1,2)==1);
   nl= size(Bnd,1);
   [XL,Y]= getdata(mdev,'X');
   yn= get(Y,'name');
   yu= get(Y,'units');
   yi = struct('Name',yn{1},'Units',yu{1},'Symbol',yn{1});
   L= yinfo(L,yi);
   xn= get(XL,'name');
   xu= get(XL,'units');
   xi = struct('Names',{xn},'Units',{xu},'Symbols',{xn});
   L= xinfo(L,xi);
   
   XL= double(XL);
   Bnd= [min(XL)' max(XL)'];
   Tgt(:,1)= -Inf;
   Tgt(:,2)= Inf;
   L= setcode(L,Bnd,g,Tgt);
   mdev= model(mdev,L);
end