function d=designobj(m,opt)
% DESIGNOBJ  Return an appropriate design object
%
%   D=DESIGNOBJ(M) returns a design object of the appropriate
%   type, loaded with the model M
%
%   D=DESIGNOBJ(M,'classname') returns the classname of the design
%   object for the model.  This is used to avoid recursion in
%   xregdesign/model.
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:53:59 $

if nargin>1 & strcmp(opt,'classname')
   d='des_multimod';
else
   d=des_multimod('nfactors',nfactors(m));
   d=model(d,m);
   d=name(d,'Multi-model Design');
end
return