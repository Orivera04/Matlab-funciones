function des=des_multimod(varargin);
% DES_MULTIMOD Constructor for multimod design objects
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.4.2.2 $  $Date: 2004/02/09 07:02:37 $



if nargin & isobject(varargin{1}) & ~isa(varargin{1},'xregdesign')
   parent=varargin{1};
   init=1;
elseif nargin & isstruct(varargin{1})
   % use structure fields for the new object.
   des.store=varargin{1}.store;
   parent=varargin{1}.des_respsurf;
   init=0;
else
   parent=des_respsurf(varargin{:});
   init=1;
end

if init
   % model
   m=xregmulti('nfactors',nfactors(parent));

   % storage field.  Results should be stored in a structure, maybe
   % struct.name.data
   % struct.name.designstate  -  the value of the state flag at data creation
   % struct.name.candstate
   % struct.name.modelstate   
   des.store=[];
end

% always mark as latest version
des.version=2;

des=class(des,'des_multimod',parent);
if init
   des=model(des,m);
end
return