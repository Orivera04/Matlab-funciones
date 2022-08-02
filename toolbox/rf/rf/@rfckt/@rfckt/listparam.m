function list = listparam(h)
%LISTPARAM List the valid parameters for the RFCKT object.
%   LIST = LISTPARAM(H) lists the valid parameters that can be visualized
%   for the RFCKT object.

%   Copyright 2003-2004 The MathWorks, Inc.
%   $Revision: 1.1.6.6 $  $Date: 2004/04/12 23:37:35 $

% Get the data object
data = getdata(h);

% Get the list by calling the method of RFDATA.DATA object
list = data.listparam;
