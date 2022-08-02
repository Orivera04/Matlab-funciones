function proj=ccgreateproject(fname)
%CGCREATEPROJECT  Create a blank project
%
%  P = CGCREATEPROJECT(FILENAME) returns a pointer to a cgproject object.
%  This project contains the default setup of a new Cage project and will
%  save to the file FILENAME.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.2.3 $  $Date: 2004/02/09 08:39:26 $

% First create a Project node
proj=address(cgproject(fname));

% add a Data Dictionary - empty at present
dd=address(cgddnode([]));
proj.AddChild(dd);