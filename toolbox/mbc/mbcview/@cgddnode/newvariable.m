function [dd,ptr] = newvariable(dd)
% CGDDNODE/NEWVARIABLE Add a new variable to the browser
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.5.2.2 $  $Date: 2004/02/09 08:23:41 $

CGP=project(dd);
name='New_Variable';
name=uniquename(CGP,name);
[dd, ptr] = add(dd, name);
dd = info(address(dd));