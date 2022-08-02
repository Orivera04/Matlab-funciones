function h=cgfeattblnode(varargin)
%CGFEATTBLNODE  construct a cgfeattblnode object
%
% h=cgfeattblnode(data)  constructs a cgfeattblnode object
% h=cgfeattblnode(structure)
%
% CGFEATTBLNODE inherits from CGTABLENODE
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.3 $  $Date: 2004/02/09 08:23:56 $

loadstr=0;
if nargin==0
   loadstr=1;
   t=cgtablenode;
end

if nargin==1 & isstruct(varargin{1})
   % version update mechanism - fixes the input structure
   h=varargin{1};
   
   t=h.cgtablenode;
   h=mv_rmfield(h,'cgtablenode');  
else 
   % construct a new object
   if nargin<1
      data=[];
   else
      data=varargin{1};
   end
   h=struct([]); 
   if ~loadstr
      t=cgtablenode(data);
      t=guid(t,'cgfeaturetable');
      t=name(t,'Table');
   else
      t=cgtablenode;
   end
end

h(1).SFData = [];
h.Version = 0;
h=class(h,'cgfeattblnode',t);

if ~loadstr
   p=pointer(h);
   h=p.info;
end
