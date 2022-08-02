function pToggleLibs( show, featnode )
%PTOGGLELIBS 
%
%  PTOGGLELIBS( SHOW )

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.1.6.3 $    $Date: 2004/02/09 08:24:06 $ 

% shows/hides all the libraries
c = cgbrowser;
if (c.GUIExists)
    PR = xregGui.PointerRepository;
    ptrID = PR.stackSetPointer(c.Figure,'watch');
end

libs = pGetFeatureLibraries;
for n=1:size(libs,1)
    openCB = libs{n,2}{1};
    closeCB = libs{n,2}{2};
    if show
        feval(openCB, featnode);
    else
        feval(closeCB, featnode);
    end
end

if (c.GUIExists)
    PR.stackRemovePointer(c.Figure,ptrID);
end
