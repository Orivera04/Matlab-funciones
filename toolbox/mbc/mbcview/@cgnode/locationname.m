function nm = locationname(nd)
%LOCATIONNAME Return the location of the node
%
%  NAME = LOCATIONNAME(NODE) returns a string that contains the location of
%  the node on the tree.  This location may not necessarily disclose the
%  full path; this method is intended to be an intermediate option between
%  name() and fullname().

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.8.2 $    $Date: 2004/02/09 08:25:09 $ 

% Default action for cage nodes is to return the path from the project
% downwards
nm=name(nd);
p= Parent(nd);
if p~=0
    nd = p.info;
    while ~isproject(nd)
        nm = [name(nd),'/',nm];
        nd= info(Parent(nd));
    end
end