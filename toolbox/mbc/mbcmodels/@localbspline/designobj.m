function d=designobj(m,opt);
% DESIGNOBJ   Return an apropriate design object
%
%   D=DESIGNOBJ(M) constructs a design object containing the
%   model M and returns it as D. 
%
%   D=DESIGNOBJ(M,'classname') returns the classname of the design
%   object for the model.  This is used to avoid recursion in
%   xregdesign/model.
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:38:05 $



if nargin>1 & strcmp(opt,'classname')
   d='xregdesign';
else
   d=xregdesign('nfactors',nfactors(m));
   d= model(d,m);
   d=name(d,'Free Knot Design');
end
return