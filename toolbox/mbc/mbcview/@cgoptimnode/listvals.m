function vals = listvals(optnode, listname)
%LISTVALS Return information for an item in any of the lists
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.3.6.1 $    $Date: 2004/02/09 08:26:58 $

%   INPUTS  :   optnode     -   Optimisation node object
%               listname    -   Tag for the activeX list (objective, DS, con)
%               listitem    -   Item in the list
%

%   OUTPUTS :   tags        -   Labels for each column 
%               vals        -   Cell array of values to fill the list

pO = getdata(optnode);
switch listname
case 'Objective'
    vals=pr_GetObjInfo(pO);
case 'Operating Point Set'
    vals=pr_GetDSInfo(pO);
case 'Constraint'
    vals=pr_GetConInfo(pO);
end



