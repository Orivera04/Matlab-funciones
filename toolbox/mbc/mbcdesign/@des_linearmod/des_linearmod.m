function smod=des_linearmod(varargin)
% DES_LINEARMOD   Constructor function for the des_linearmod object
%
%
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.4.2.2 $  $Date: 2004/02/09 07:02:18 $


% Created 26/10/99

if nargin & isobject(varargin{1}) & ~isa(varargin{1},'xregdesign')
   parent=varargin{1};
   init=1;
elseif nargin & isstruct(varargin{1})
   % use structure fields for the new object.
   smod.store=varargin{1}.store;
   parent=varargin{1}.des_respsurf;
   init=0;
else
   parent=des_respsurf(varargin{:});
   init=1;
end

if init
   % storage field.  Results should be stored in a structure, maybe
   % struct.name.data
   % struct.name.designstate  -  the value of the state flag at data creation
   % struct.name.candstate
   % struct.name.modelstate 
   smod.store=[];
end

% always mark as latest version
smod.version=2;

smod=class(smod,'des_linearmod',parent);
return