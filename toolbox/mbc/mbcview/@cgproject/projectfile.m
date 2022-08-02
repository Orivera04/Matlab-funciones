function file= projectfile(MP,file)
% CGPROJECT/PROJECTFILE filename for project

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 08:28:23 $

if nargin==1
   file= MP.filename;
else
   MP.filename=file;
   pointer(MP);
   file=MP;
end
