function h=cgnormnode(varargin)
%CGNORMNODE  construct a cgnormnode object
%
% h=cgnormnode(data)  constructs a cgnormnode object
% h=cgnormnode(structure)
%
% CGNORMNODE inherits from CGCONTAINER
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.3 $  $Date: 2004/02/09 08:25:26 $

% Version 0

loadstr=0;
if nargin==0
   loadstr=1;
   t=cgcontainer;
end

if nargin==1 & isstruct(varargin{1})
   % version update mechanism - fixes the input structure
   h=varargin{1};
   
   t=h.cgcontainer;
   h=mv_rmfield(h,'cgcontainer');  
else 
   % construct a new object
   if nargin<1
      data=[];
   else
      data=varargin{1};
   end
   h=struct([]); 
   if ~loadstr
      t=cgcontainer(data);
      t=guid(t,'cgnorm');
      t=name(t,'Normaliser');
   else
      t=cgcontainer;
   end
end

h(1).Data = [];
h.SFData = [];
Managers.AutoSpaceManager = [];
Managers.InitialisationManager = [];
Managers.OptimisationManager = [];

h.Managers = Managers;
h.Version = 0;

h=class(h,'cgnormnode',t);

if ~loadstr
   p=pointer(h);
   h=p.info;
end
