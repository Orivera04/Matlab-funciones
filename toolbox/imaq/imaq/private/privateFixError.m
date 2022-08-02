function privateFixError
%PRIVATEFIXERROR Remove any extra carriage returns.
%
%    PRIVATEFIXERROR removes any trailing CR's from
%    LASTERR.

%    CP 9-01-01
%    Copyright 2001-2004 The MathWorks, Inc.
%    $Revision: 1.1.6.4 $  $Date: 2004/03/30 13:06:11 $

% Initialize variables. Then remove the trailing carriage 
% returns and reset lasterr.
[errmsg, id] = lasterr;
lasterr(deblank(errmsg), id);