function h=cgproject(varargin)
%CGPROJECT  construct a cgproject object
%
% h=cgproject(filename)  constructs a cdproject object
% h=cgproject(structure)
%
% CGPROJECT inherits from CGNODE
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 08:28:04 $

loadstr=0;
if nargin==0
   loadstr=1;
   t=cgnode;
end

if nargin==1 & isstruct(varargin{1})
   h=varargin{1};
   t=h.cgnode;
   h=mv_rmfield(h,'cgnode'); 
   loadstr=1;
else 
   if nargin<1
      fname='Untitled';
   else
       fname=varargin{1};
   end
   % construct a new object
   h=struct('loader', mbcloadstart, ...
       'timestamp',now,...
       'version',5,...
       'heap',[],...
       'filename',fname,...
       'beingdel',0,...
       'modified',0, ...
       'SavedMBCVersion', '', ...
       'SavedAddonVersions', {cell(0,2)}); 
   if ~loadstr
      t=cgnode('project','cage.bmp');
      t=name(t,'Project');
   end
end

h=class(h,'cgproject',t);

if ~loadstr
   p=pointer(h);
   h=p.info;
end