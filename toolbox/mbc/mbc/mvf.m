function h= mvf(tag);
% MVF ModelBrowser Figure Handle

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.5.4.2 $  $Date: 2004/02/09 06:49:09 $

if nargin==0
   tag= 'mvModelBrowser';
end

h= findobj(allchild(0),'flat','tag',tag);
if length(h)>1
   h= h(1);
end