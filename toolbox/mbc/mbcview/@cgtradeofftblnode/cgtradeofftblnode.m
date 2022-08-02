function h=cgtradeofftblnode(varargin)
%CGTRADEOFFTBLNODE  construct a cgtradeofftblnode object
%
% h=cgtradeofftblnode(data)  constructs a cgtradeofftblnode object
% h=cgtradeofftblnode(structure)
%
% CGTRADEOFFTBLNODE inherits from CGTABLENODE
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.3 $  $Date: 2004/02/09 08:38:54 $

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
      t=guid(t,'cgtradeofftable');
      t=name(t,'Table');
   else
      t=cgtablenode;
   end
end

h=class(h,'cgtradeofftblnode',t);

if ~loadstr
   p=pointer(h);
   h=p.info;
end
