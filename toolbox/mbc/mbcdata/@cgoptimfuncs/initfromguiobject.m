function obj = initfromguiobject(obj, hGUI)
%INITFROMGUIOBJECT Iniitialise obejct fields from an editing GUI
%
%  OBJ = INITFROMGUIOBJECT(OBJ, HGUI)

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.6.1 $    $Date: 2004/02/09 06:50:55 $ 

if ~isempty(hGUI.OptimFuncs)
    obj = hGUI.OptimFuncs;
end