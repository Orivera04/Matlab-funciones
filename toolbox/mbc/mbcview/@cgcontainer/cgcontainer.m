function h=cgcontainer(varargin)
%CGCONTAINER  construct a cgcontainer object
%
% h=cgcontainer(data) 
% h=cgcontainer(data, iconfile) 
% h=cgcontainer(structure)
%
% CGCONTAINER inherits from CGNODE
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 08:21:53 $

loadstr=0;
if nargin==0
   loadstr=1;
   t=cgnode;
end

if nargin==1 & isstruct(varargin{1})
   % version update mechanism - fixes the input structure
   h=varargin{1};
   
   t=h.cgnode;
   h=mv_rmfield(h,'cgnode');  
else 
   % construct a new object
   if nargin<2
      ic='cgcont.bmp';
      if nargin<1
         d=[];
      else
         d=varargin{1};
      end
   else
      d=varargin{1};
      ic=varargin{2};
   end
   h=struct('data',d,...
      'version',1);  
   if ~loadstr
      t=cgnode('container',ic);
   end
end

h=class(h,'cgcontainer',t);

if ~loadstr
   p=pointer(h);
   h=p.info;
end