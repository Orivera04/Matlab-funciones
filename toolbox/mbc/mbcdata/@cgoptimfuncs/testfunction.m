function [ok, report] = testfunction(obj, idx)
%TESTFUNCTION Test an optimization function
%
%  [OK, REPORT] = TESTFUNCTION(OBJ, IDX) tests the function at index IDX to
%  check whether it can run.  If OK is false, REPORT will contain an Nx2
%  cell array containing pairs of headings and further information on the
%  problems encountered.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.6.1 $    $Date: 2004/02/09 06:54:04 $ 

nFuncs = length(obj.FunctionNames);
% Check index is OK
if (numel(idx) ~= 1) || (idx > nFuncs) || (idx < 1)
    error('mbc:cgoptimfuncs:InvalidArgument', ...
        'Index must be scalar and less than or equal to the number of functions.')
end

fileexists = pfindfunction(obj.FunctionNames{idx});
if fileexists
    optimobj = cgoptim;
    [optimobj, ok, report] = setfunctionfile(optimobj, obj.FunctionNames{idx});
else
    ok = false;
    report = {'Function not found', ...
            ['The function specified was not found on MATLAB''s search path.  ', ...
                'Check that you have added the function''s location to MATLAB''s path ', ...
                'by looking at the path tool: in MATLAB, go to the "File" menu and', ...
                'choose "Set Path...".']};
end