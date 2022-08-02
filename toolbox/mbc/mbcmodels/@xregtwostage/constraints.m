function [loBnds,hiBnds,Ac,Bc,nlcon,optparams]= constraints(TS,Xgc,Yrf);
%CONSTRAINTS

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.3 $  $Date: 2004/02/09 07:59:29 $


% constraints for model
for i= 1:length(TS.Global)
   % [L{i},U{i},lsqparams{i}] = init_param(TS.Global{i},Xgc,Yrf(:,i));
   % more general 
   [L{i},U{i},A{i},b{i},nlcon(i),optparams{i}] = constraints(TS.Global{i},Xgc,Yrf(:,i));
   Np(i)= numNLParams(TS.Global{i});
   N(i) = numParams(TS.Global{i});
end

isNested= sum(Np)<sum(N);

Np = cumsum([1 Np]);
loBnds= -Inf*zeros(Np(end)-1,1);
hiBnds= Inf*zeros(Np(end)-1,1);
for i= 1:length(L)
   loBnds(Np(i):Np(i)+length(L{i})-1)= L{i};
   hiBnds(Np(i):Np(i)+length(U{i})-1)= U{i};
end
optfunc= 'fmincon';
if ~all(cellfun('isempty',A)) 
   nr= cumsum([1 cellfun('size',A,1)]);
   Ac= zeros(nr(end)-1,Np(end)-1);
   Bc= zeros(size(Ac,1),1);
   for i= 1:length(A)
      Ac(nr(i):nr(i+1)-1,Np(i):Np(i+1)-1)= A{i};
      Bc(nr(i):nr(i+1)-1,1)= b{i};
   end
   optfunc= 'fmincon';
else
   Ac=[];
   Bc=[];
end

nlcon= sum(nlcon);
