function [mlist,name]= buildmodels(m,nobs);
%BUILDMODELS

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.6.2 $  $Date: 2004/02/09 07:53:56 $

[m,OK] = gui_globalmodsetup(m, 'figure', 'AllowWeightEditing', false);
if OK
    name = 'User-defined';
    mlist = get(m,'models');
else
    name = '';
    mlist = {};
end
