function [LB,UB,A,c,nlcon,optparams]=constraints(L,X,Y);
% LOCALMOD/CONSTRAINTS

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:38:51 $

[x0,LB,UB,ok]=initial(L,X{1},Y{1});
Ns= size(X,3);
if ~isempty(LB)
   LB= repmat(LB(:),1,Ns);
end
if ~isempty(UB)
   UB= repmat(UB(:),1,Ns);
end

A=[];
c=[];
nlcon=0;
optparams={};

