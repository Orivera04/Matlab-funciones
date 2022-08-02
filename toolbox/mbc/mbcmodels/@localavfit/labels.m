function list= labels(L,varargin)
%LOCALAVFIT/LABELS coefficient labels

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%   $Revision: 1.2.6.2 $  $Date: 2004/02/09 07:37:45 $

try
   list= labels(L.model,varargin{1},0);
catch
   list= labels(L.model,varargin{1});
end
if length(list)~=size(L)
   list= list(Terms(L.model));
end
