function h=cgmodelnode(varargin)
%CGMODELNODE  construct a cgmodelnode object
%
% h=cgmodelnode(data)  constructs a cgmodelnode object
% h=cgmodelnode(structure)
%
% CGMODELNODE inherits from CGCONTAINER
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.3 $  $Date: 2004/02/09 08:24:17 $

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
      t=guid(t,'cgmodel');
      t=name(t,'Model');
   else
      t=cgcontainer;
   end
end

h=class(h,'cgmodelnode',t);

if ~loadstr
   p=pointer(h);
   h=p.info;
end
