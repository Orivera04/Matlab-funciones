function nd=addtoproject(nd,varargin)
%ADDTOPROJECT  add data to the project
%
% ADDTOPROJECT(ND,DATA,NSUB)
%
%  If NSUB (a cgnode) is specified then DATA is ignored, otherwise
%  a cgnode is constructed for DATA.
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.4.2.2 $  $Date: 2004/02/09 08:22:37 $

% add to project the normal way
addtoproject(nd.cgcontainer,varargin{:});

% check whether any items should also be attached to tradeoff node
data = varargin{1};
nd=address(nd);
if data.isa('cglookup') & ~data.isa('cgnormaliser')
	tblnd=cgnode(data.info,nd,data,1);
	nd.AddChild(tblnd);
end

