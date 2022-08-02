function L= LocalModel(TS,XG);
% XREGTWOSTAGE/LOCALMODEL

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.



%   $Revision: 1.7.2.2 $  $Date: 2004/02/09 07:59:15 $

L= TS.Local;
[y,Yrf,d,p]= EvalModel(TS,{zeros(1,nlfactors(TS)),XG});
if DatumType(L)
   L= update(L,p,[]);
   L= datum(L,d);
else
   L= update(L,p);
end

if ~allLinearRF(L)
   L= EvalDelG(L);
end

% Initialize prediction error
D= JacobGlobalVar(TS,gcode(TS,XG))*var(TS);
ri=  delG(L)\D;
% square down rinv
ri= triu(qr(ri',0))';
ri= ri(:,1:size(ri,1));
L= var(L,ri,[],[]);

