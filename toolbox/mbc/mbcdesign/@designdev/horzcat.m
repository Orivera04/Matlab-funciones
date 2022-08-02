function result = horzcat(obj,varargin)
% DESIGNDEV/HORZCAT horizontal concatination of designdev objects

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:03:09 $

% Note DesignDev objects are stored right to left, since level 1 
% is the local, lowest level. 
for i = 1:length(varargin)
   obj = prepend(obj, varargin{i});
end

result = obj;
