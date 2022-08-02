function m= xregmulti(varargin)
% XREGMULTI   Constructor for xregmulti object
%
%  M=XREGMULTI creates an multi-model object containing a single
%  xregcubic object.
%  M=XREGMULTI('nfactors',N) creates an object with N factors.
%  M=XREGMULTI(S) where S is a struct creates an object from
%  the structure S.
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:54:13 $

% Created 25/5/2000

if nargin & isa(varargin{1},'struct')
   m=varargin{1};
   mdl = m.xregmodel;
   m= rmfield(m,'xregmodel');
else 
   if nargin
      switch lower(varargin{1})
      case 'nfactors'
         nf=varargin{2};
      end
   else  
      nf=4;
   end
   m.currentindex=1;
   m.models={xregcubic('nfactors',nf)};
   m.weights=[1];
   m.version=1;
   mdl=xregmodel('nfactors',nf);
end

m=class(m,'xregmulti',mdl);

return