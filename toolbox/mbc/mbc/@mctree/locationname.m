function nm = locationname(nd)
%LOCATIONNAME Return the location of the node
%
%  NAME = LOCATIONNAME(NODE) returns a string that contains the location of
%  the node on the tree.  This location may not necessarily disclose the
%  full path; this method is intended to be an intermediate option between
%  name() and fullname().

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.6.1 $    $Date: 2004/02/09 06:47:56 $ 

% Default action is to return the full path
nm = fullname(nd);