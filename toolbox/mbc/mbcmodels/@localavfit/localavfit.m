function L= localavfit(varargin);
%LOCALAVFIT Construct "average fit" model
%
%  M = LOCALAVFIT constructs a model that performs an average fit over all
%  tests.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.6.2 $  $Date: 2004/02/09 07:37:46 $

switch nargin
   case 0
      nf = 2;
      m = xregcubic('nfactors',nf);
   case 1
      m = varargin{1};
      nf = nfactors(m);
   case 2
      nf = varargin{2};
      m = xregcubic('nfactors',nf);
end

L.model  = m;

BaseModel = xregmodel('nfactors',nf);
L = class(L,'localavfit',localmod,BaseModel);

[Feats,Defaults,Values] = features(L);
L = AddFeat(L,Values,Defaults);
