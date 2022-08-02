function h=cgnode(varargin)
%CGNODE  construct a cgnode object
%
% h=cgnode  constructs a cgnode object
% h=cgnode(GUID,iconfile) 
% h=cgnode(structure)
%
% CGNODE inherits from MCTREE
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 08:24:46 $

loadstr=0;
if nargin==0
   loadstr=1;
end

if nargin==1 & isstruct(varargin{1})
   % version update mechanism - fixes the input structure
   h=varargin{1};
   
   t=h.mctree;
   h=mv_rmfield(h,'mctree');  
   loadstr=1;
else 
   % construct a new object
   if nargin<2
      fl='cgnode.bmp';
      if nargin<1
         GUID='cgnode';
      else
         GUID=varargin{1};
      end
   else
      fl=varargin{2};
      GUID=varargin{1};
   end
   h=struct('GUID',GUID,...
      'icon',fl,...
      'version',1);  
   t=mctree;
end

h=class(h,'cgnode',t);

if ~loadstr
   % update dynamic memory
   p=pointer(h);
   h=p.info;
end