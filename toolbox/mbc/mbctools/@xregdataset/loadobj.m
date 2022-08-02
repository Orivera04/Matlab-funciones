function A=loadobj(B);
% DATASET/LOADOBJ load sweepset object and version control
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 08:18:49 $

% Date:   9-11-2000

% Enter current version number of object
CurrentVersion = 2;

A = B;
if isa(B,'dataset')
	if B.version == CurrentVersion
		return
	end
end

% Enter code for updating object in this case statement
switch B.version
case 1
	A.sizes = {uint32(B.sizes)};
	A.type = {B.type};
	A.testnum = {B.testnum};
	A.version = 2;
otherwise
	if A.version~= CurrentVersion
		warning(sprintf('%s contains an unknown sweep version (%3.1f)',inputname(1),B.version));
	end
end