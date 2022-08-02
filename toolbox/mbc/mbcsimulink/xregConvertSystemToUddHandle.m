function h = xregConvertSystemToUddHandle(system)
%XREGCONVERTSYSTEMTOUDDHANDLE convert simulink block to true udd handle
%
%  H = XREGCONVERTSYSTEMTOUDDHANDLE(system)

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.1.6.2 $    $Date: 2004/02/09 08:02:57 $ 

% Default output is an invalid handle
h = handle(-1);

% First check for a string input which would be a full path to the block
if ischar(system)
    system = get_param(system, 'handle');
end

% Now convert from a double handle
if isnumeric(system)
    h = handle(system);
end
