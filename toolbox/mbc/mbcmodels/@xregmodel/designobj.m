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
%
%   Note this version is provided as a part of the basic model
%   class to ensure all model types are capable of generating
%   a design type.  Model classes should overload this function
%   to generate an appropriate design.
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:51:41 $



if nargin>1 & strcmp(opt,'classname')
   d='xregdesign';
else
   d=xregdesign('nfactors',nfactors(m));
   d=model(d,m);
   d=name(d,'Generic Design');
end

