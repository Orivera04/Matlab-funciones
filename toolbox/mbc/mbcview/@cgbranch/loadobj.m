function obj = loadobj(obj)
%LOADOBJ Update cgbranch objects from old files
%
%  OBJ = LOADOBJ(OBJ)

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.1.6.2 $    $Date: 2004/02/09 08:21:24 $ 

% cgbranch has been removed from cage projects.  This loadobj function
% registers a post-load action that transfers children of branches onto the
% project and removes the cgbranch.
h = mbcloadrecorder('current');
h.add({@i_removebranch, address(obj)}, '04-Apr-2003');



function i_removebranch(src, evt, pBranch)
Branch = pBranch.info;
ch = children(Branch);
Project = info(Parent(Branch));

% Remove children from branch
Branch = AssignChildren(Branch, []);

% Add each child to the project
for n = 1:length(ch)
    Project = AddChild(Project, ch(n));
end

% Remove the branch
delete(Branch);
