function nd=addtoproject(nd,data,n_sub)
%ADDTOPROJECT  add data to the project
%
% ADDTOPROJECT(ND,DATA,NSUB)
%
%  If NSUB (a cgnode) is specified then DATA is ignored, otherwise
%  a cgnode is constructed for DATA.
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.4.2.2 $  $Date: 2004/02/09 08:24:39 $

if nargin<3
   n_sub=cgnode(data.info,[],data,1);
end

% pass call to new interface
nd=addnodestoproject(nd,n_sub);