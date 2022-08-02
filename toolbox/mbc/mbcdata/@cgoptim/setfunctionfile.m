function [newobj, ok, report] = setfunctionfile(obj, file)
%SETFUNCTIONFILE Set a new optimization function
%
%  [OBJ, OK, REPORT] = SETFUNCTIONFILE(OBJ, FCN) attempts to set a new
%  function file as the optimization.  If OK returns false then REPORT will
%  contain an Nx2 cell array containing pairs of headings and further
%  information on the problems encountered.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.6.1 $    $Date: 2004/02/09 06:53:55 $ 

newobj = obj;
newobj.fname = file;
[newobj, ok, report] = setupfromscript(newobj);
if ~ok
    newobj = obj;
end