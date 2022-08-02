function f=EditFeat(f,i,Value,Type,Limit);
% LOCALMOD/EDITFEAT edit response feature definition
%
% f=EditFeat(f,i,Value,Type,Limit);

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:38:38 $

f.Values(i,:)= Value;
if nargin<5
   Limit=repmat([-Inf;Inf],1,size(Value,1));
end
f.Limits(:,i)= Limit;

% this returns a structure adjusted for datum
flist= DatumDisplay(f,features(f));
f.Type(i)= flist(Type);
% reevaluate delG
f= EvalDelG(f);

