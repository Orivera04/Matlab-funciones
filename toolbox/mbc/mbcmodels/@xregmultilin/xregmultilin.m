function m=xregmultilin(varargin)
% XREGMULTILIN  Linear-onoly multi model
%
%  XREGMULTILIN constructs a child of xregmulti which
%  is constrained to containing linear models.
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:56:09 $

% Created 19/12/2000

if nargin & isa(varargin{1},'struct')
   m=varargin{1};
   mdl = m.xregmulti;
   m= rmfield(m,'xregmulti');
else 
   if nargin
      switch lower(varargin{1})
      case 'nfactors'
         nf=varargin{2};
      end
   else  
      nf=4;
   end
   m.version=1;
   mdl=xregmulti('nfactors',nf);
end

m=class(m,'xregmultilin',mdl);

return