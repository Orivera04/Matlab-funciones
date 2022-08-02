function hlines = plot(varargin)
%PLOT Plot the parameters on X-Y plane.
%   HLINES = PLOT(H, PARAMETER) plots the specified parameter on X-Y plane
%   in the default format. The first input H is the handle to the RFCKT
%   object, and the second input PARAMETER is the parameter to be
%   visualized.
%
%   HLINES = PLOT(H, PARAMETER, FORMAT) plots the PARAMETER on X-Y plane in
%   the specified FORMAT.
%
%   Type LISTFORMAT(H, PARAMETER) to see the valid formats for the
%   specified parameter. The first listed format is the default format for
%   the specified parameter.
%
%   HLINES = PLOT(H, PARAMETER1, ..., PARAMETERN) plots the parameters
%   PARAMETER1, ..., PARAMETERN on X-Y plane using the default format. All
%   the parameters must have same default format.

%   HLINES = PLOT(H, PARAMETER1, ..., PARAMETERN, FORMAT) plots the
%   parameters PARAMETER1, ..., PARAMETERN on X-Y plane using the specified
%   FORMAT. FORMAT must be a valid format for all the parameters.
%
%   This method returns a column vector of handles to lineseries objects,
%   one handle per plotted line.
%
%   Type LISTPARAM(H) to see the valid parameters for the RFCKT object.

%   Copyright 2004 The MathWorks, Inc. 
%   $Revision: 1.1.6.2 $  $Date: 2004/03/24 20:45:20 $

% Get the RFCKT object
h = varargin{1};

% Get the data object
data = getdata(h);

% Plot data by calling the method of RFDATA.DATA object
hlines = plot(data, varargin{2:end});
