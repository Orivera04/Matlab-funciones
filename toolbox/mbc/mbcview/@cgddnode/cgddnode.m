function h=cgddnode(varargin)
%CGDDNODE  construct a cgddnode object
%
% h=cgddnode(data)  constructs a cgddnode object
% h=cgddnode(structure)
%
% CGDDNODE inherits from CGCONTAINER
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.4.2.3 $  $Date: 2004/02/09 08:23:07 $

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
   loadstr = 1;
else 
   % construct a new object
   if nargin<1
      data=[];
   else
      data=varargin{1};
   end
   h=struct('ptrlist',assign(xregpointer, []), ...        % List of variable pointers
       'numsymvars', 0 ,...                               % Number of formulae (improves performance)
       'version', 2);
   if ~loadstr
      t=cgcontainer(data);
      t=guid(t,'cgdd');
      t=name(t,'Variable Dictionary');
   else
      t=cgcontainer;
   end
end

h=class(h,'cgddnode',t);

if ~loadstr
   p=pointer(h);
   h=p.info;
end
