function h=cgdatasetnode(varargin)
%CGDATASETNODE  construct a cgdatasetnode object
%
% h=cgdatasetnode(data)  constructs a cgdatasetnode object
% h=cgdatasetnode(structure)
%
% CGDATASETNODE inherits from CGCONTAINER
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.3 $  $Date: 2004/02/09 08:21:41 $

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
      t=guid(t,'cgdataset');
      t=name(t,'Dataset');
   else
      t=cgcontainer;
   end
end

h=class(h,'cgdatasetnode',t);

if ~loadstr
   p=pointer(h);
   h=p.info;
end
