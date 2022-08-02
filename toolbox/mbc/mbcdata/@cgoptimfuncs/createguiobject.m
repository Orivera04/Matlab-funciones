function hGUI = createguiobject(obj, prnt, varargin)
%CREATEGUIOBJECT Create a GUI object for editing function list
%
%  HGUI = CREATEGUIOBJECT(OBJ, PRNT, PROP1, VAL1, ...)
%  
%  SEE ALSO: INITFROMGUIOBJECT

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.6.1 $    $Date: 2004/02/09 06:50:51 $ 

hGUI = cgoptimgui.optimfuncseditor('parent', prnt, ...
    'OptimFuncs', obj, ...
    varargin{:});