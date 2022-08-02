function nm=levelname(mdev,nm, LOAD_FLAG)
% LEVELNAME  Return Level name for modeldev node
%
%   NM=LEVELNAME(MDEV)
%   MDEV=LEVELNAME(MDEV, NM)
%
% This method sets and retrieves the generic "Name" for a node, eg
% "TestPlan", "Response Feature"
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 08:10:32 $

% Created 11/12/2000

if nargin>1
   mdev.LevelName=nm;
   nm=mdev;
   
   % This function may be called during load process.  In this case, don't update pointer!
   if nargin<3 | ~LOAD_FLAG
      pointer(mdev);
   end  
else
   nm=mdev.LevelName;
end