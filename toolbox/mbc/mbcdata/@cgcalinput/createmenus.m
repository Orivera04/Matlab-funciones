function createmenus(obj,h)
% CreateMenus method for cgcalinput
% createmenus(cgcalinput,h)
% Attaches menus to uimenu handle h for all the currently available output types

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.3.2.3 $  $Date: 2004/02/09 06:49:16 $



[fcns,names]=getinputfunctions(obj);
% Loop over output methods to create a menu item for each
fcn=@i_outputcb;
for i = 1:length(fcns)
    uimenu(h , 'label' , names{i} ,...
        'callback',{fcn,fcns{i}});
end



function i_outputcb(src,evt,outputfcn)
c=cgbrowser;
n=c.CurrentNode;
feval(outputfcn,cgcaloutput(n));
return