function [data, params] = calculate(varargin)
%CALCULATE Calculate the required parameters.
%   [DATA, PARAMS] = CALCULATE(H, PARAMETER1, ..., PARAMETERN, FORMAT) 
%   calculates the required parameters for the RFCKT object and returns
%   them in cell array data.
%
%   The first input is the handle to the RFCKT object, the last input is
%   the FORMAT, and the other inputs (PARAMETER1, ..., PARAMETERN) are the
%   parameters that can be visualized from the RFCKT object. 
%
%   Type LISTPARAM(H) to see the valid parameters for the RFCKT object.  
%
%   Type LISTFORMAT(H, PARAMETER) to see the valid formats for the
%   specified PARAMETER.

%   Copyright 2003-2004 The MathWorks, Inc.
%   $Revision: 1.1.6.6 $  $Date: 2004/04/12 23:37:29 $

% Get the circuit object
h = varargin{1};

% Get the data object
data = getdata(h);

% Calculate the required data by calling the method of RFDATA.DATA object
[data, params] = calculate(data, varargin{2:end});
