function pr_ConfigureExprList(list,listlyt)
% pr_ConfigureExprList(list,listlayout)

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.4.2.3 $  $Date: 2004/02/09 08:22:19 $



pr_ConfigureList(list,listlyt,...
        {'Expression','Type','Information','Index'},...
        [200,150,400,0],...
        '');
list.FullRowSelect = true;