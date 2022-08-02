function out = ismajoritem(node)
%ISMAJORITEM A short description of the function
%
%  OUT = ISMAJORITEM(NODE) returns true if NODE is a major project item,
%  false otherwise.
%
%  In general, if a node believes that all child nodes only contain data
%  that is already referenced in itself then it is reasonable to consider
%  that node as a major project item.  The default implementation of
%  ISMAJORITEM assumes that the project and any direct children of a
%  project are major items.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.8.3 $    $Date: 2004/02/09 08:25:04 $ 

out = false;
out = isproject(node);

if ~out
    % Check parent
    ndeParent = info(Parent(node));
    out = isproject(ndeParent);   
end