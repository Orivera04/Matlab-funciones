function linkVars = finddeps(dd, pVar, listVars)
%FINDLINKS Return the variables which are dependent to another
%
%  OUT = FINDLINKS(DD, PVAR) returns the items in the variable dictionary
%  that are dependent on PVAR. 
%  OUT = FINDLINKS(DD, PVAR, PLIST) returns the items in PLIST that are
%  dependent on PVAR.
%
%  Formulae are dependent on any variables or constants that are used in
%  it.
%  Variables are dependent on any formulae that use them.
%  Constants are not dependent on anything because their value is never set
%  as a result of a formula's value change.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.6.1 $    $Date: 2004/02/09 08:23:19 $ 


if nargin<3
    listVars = dd.ptrlist;
end

if pVar.issymvalue
    linkVars = [pVar.getrhsptrs, pVar];
elseif pVar.isconstant
    linkVars = pVar;
else
    linkVars = [insymval(dd, pVar), pVar];
end
linkVars = intersect(linkVars, listVars);