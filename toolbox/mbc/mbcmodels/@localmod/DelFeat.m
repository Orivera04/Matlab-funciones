function f1=DelFeat(f,ind);
% LOCALMOD/DELFEAT delete response feature from localmod
%
% f1=DelFeat(f,ind);

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:38:34 $

if isa(ind,'double');
   f1= f;
   f1.Values(ind,:)=[];
   f1.Type(ind)=[];
   f1.delG(ind,:)=[];
   f1.Limits(:,ind)=[];
else
   f1= f;
   f1.Values=[];
   f1.Type=f1.Type(~1);
   f1.delG=[];
   f1.Limits=zeros(2,0);
end   