function varargout=constraints(L,X,Y);
% LOCALMOD/CONSTRAINTS
%
% [LB,UB,A,c,nlcon,optparams]=constraints(L,X,Y)

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:43:41 $

  
Ns= size(X,3);
LB= zeros(size(L,1),Ns);
UB= LB;
%A= cell(Ns,1);
%c= zeros(Ns,1)
for i=1:Ns
   [LB(:,i),UB(:,i),A,c,nlcon,args]=constraints(L.userdefined,X{i},Y{i});
end
if ~iscell(args)
   args= {args};
end
   
if ~isempty(A)
   A= spblkdiag(repmat(A,[1 1 Ns]));
   c= repmat(c(:),[Ns,1]);
end
nlcon= nlcon*Ns;
varargout= {LB,UB,A,c,nlcon,{args}};