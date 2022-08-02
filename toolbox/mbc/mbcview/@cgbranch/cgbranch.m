function h = cgbranch
%CGBRANCH  construct a cgbranch object
%
%  NOTE: this object has been deprecated.  The constructor and a loadobj
%  still exist purely for the purpose of helping to update old files that
%  contain them.  This constructor will no longer create valid cgbranch
%  objects for any other use.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.2.3 $  $Date: 2004/02/09 08:21:23 $


h=struct('branchnumber',1,...
    'timestamp',now,...
    'version',1);
t=cgnode;
h=class(h,'cgbranch',t);