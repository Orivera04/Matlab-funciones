function h=cgoptimnode(varargin)
%CGOPTIMNODE  construct a cgoptimnode object
%
% h=cgoptimnode(data)  constructs a cgoptimnode object
% h=cgoptimnode(structure)
%
% CGOPTIMNODE inherits from CGCONTAINER
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.6.2 $    $Date: 2004/02/09 08:26:51 $

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
      t=guid(t,'cgoptim');
      t=name(t,'Optimisation');
   else
      t=cgcontainer;
   end
end

h=class(h,'cgoptimnode',t);

if ~loadstr
   p=pointer(h);
   h=p.info;
end
