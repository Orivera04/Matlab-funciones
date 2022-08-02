function L = localmulti(varargin)
%LOCALMULTI Constructor for localmulti models
%
%  M = LOCALMULTI constructs a model that tries multiple models and selects
%  'best' fit.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.6.2 $  $Date: 2004/02/09 07:40:03 $

switch nargin
   case 0
      nf = 2;
   case 1
      nf = nfactors(varargin{1});
   case 2
      nf = varargin{2};
end

L.Select = 'RMSE';
L.ReconModel = 1;
L.version = 1;

BaseModel = xregmulti('nfactors',nf);
L = class(L,'localmulti',localmod,BaseModel);

[Feats,Defaults,Values] = features(L);
L = AddFeat(L,Values,Defaults);
