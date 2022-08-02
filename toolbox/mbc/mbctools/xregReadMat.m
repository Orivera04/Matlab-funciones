function [OK, msg, out] = xregReadMat(filename, out)
% XREGREADMAT Reads in a standard mat file

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%   $Revision: 1.8.4.3 $  $Date: 2004/02/09 08:21:05 $




OK = 0;
msg = '';

matFileData = load(filename);
[path, name, ext] = fileparts(filename);

try
	[OK, newSS] = xregImportDataStructure(matFileData, [name ext]);
catch
	OK = 0;
	msg = lasterr;
end

if OK
	out = sweepset2struct(newSS);
	out.filename = filename;
end
