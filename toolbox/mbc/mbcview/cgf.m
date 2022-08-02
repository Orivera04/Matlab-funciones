function h= cgf(tag);
% CGF  Cage Browser handle finder

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 08:39:28 $

if nargin==0
   tag= 'cgbrowser';
end

h= findobj(allchild(0),'flat','tag',tag);
if length(h)>1
   h= h(1);
end