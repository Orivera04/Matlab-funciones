function hlines = polar(varargin)
%POLAR Plot the parameters on polar plane.
%   HLINES = POLAR(H, PARAMETER1, ..., PARAMETERN) plots the specified
%   parameters on the polar plane. The first input is the handle to the
%   RFCKT object, and the other inputs PARAMETER1, ..., PARAMETERN are the
%   parameters to be visualized.
%
%   This method returns a column vector of handles to lineseries objects,
%   one handle per plotted line.
%
%   Type LISTPARAM(H) to see the valid parameters for the RFCKT object. 

%   Copyright 2004 The MathWorks, Inc. 
%   $Revision: 1.1.6.2 $  $Date: 2004/03/24 20:45:21 $

% Get the RFCKT object
h = varargin{1};

% Get the data object
data = getdata(h);

% Plot data by calling the method of RFDATA.DATA object
hlines = polar(data, varargin{2:end});
