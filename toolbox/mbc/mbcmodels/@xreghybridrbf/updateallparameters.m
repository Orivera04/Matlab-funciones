function m= updateallparameters(m,b)
%XREGHYBRIDRBF/ALLPARAMETERS

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%   $Revision: 1.2.6.1 $  $Date: 2004/02/09 07:48:30 $

% update linear part
nlin= size(m.linearmodpart,1);
blin= b(1:nlin);
m.linearmodpart= updateallparameters(m.linearmodpart,blin );
% update rbf 
brbf= b(nlin+1:end);
m.rbfpart= updateallparameters(m.rbfpart,brbf);

m.xreglinear= update(m.xreglinear,[blin; double(m.rbfpart)]);

lambda= [zeros(1,nlin) brbf(4)*ones(1,size(m.rbfpart,1))];
m.xreglinear=set(m.xreglinear,'lambda',lambda);
m.xreglinear=set(m.xreglinear,'qr',get(m.rbfpart,'qr'));

