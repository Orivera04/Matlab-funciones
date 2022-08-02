function obj = cgcalinput( filename )
% cgcalinput
%
% IN = CGCALINPUT;
% IN = CGCALINPUT( FILENAME );

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
% Inc.


%   $Revision: 1.4.2.3 $  $Date: 2004/02/09 06:49:15 $


obj = struct('inputFcn',[],...
    'filename',[],...
    'datafilename',[]);

if nargin==1
    obj.filename = filename;
end

obj = class(obj,'cgcalinput');



