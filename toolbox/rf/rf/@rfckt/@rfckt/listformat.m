function list = listformat(h, parameter)
%LISTFORMAT List the valid formats for the specified PARAMETER.
%   LIST = LISTFORMAT(H, PARAMETER) lists the valid formats for the
%   specified PARAMETER.
%    
%   Type LISTPARAM(H) to get the valid parameters of the RFCKT object.

%   Copyright 2003-2004 The MathWorks, Inc.
%   $Revision: 1.1.6.6 $  $Date: 2004/04/12 23:37:34 $

% Get the data object
data = getdata(h);

% Get the list by calling the method of RFDATA.DATA object
list = data.listformat(parameter);