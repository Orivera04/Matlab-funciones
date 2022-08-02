function filename=pr_Iconfile(listname)
%PR_ICONFILE  return the filename of a bmp
%
%  FILENAME=PR_ICONFILE(LISTNAME) returns the filename of a bmp that should
%  be used as an icon for this node.
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.3.6.1 $    $Date: 2004/02/09 08:27:38 $

switch listname
case 'Objective'
    filename = 'optimobjective.bmp';
case 'Operating Point Set'
    filename = 'optimdataset.bmp';
case 'Constraint'
    filename = 'optimcon.bmp';
otherwise 
    error(['No icon defined for' listname]);
end
