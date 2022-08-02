function [hlines, hsm] = smith(varargin)
%SMITH Plot the parameters on the Smith chart.
%   [HLINES, HSM] = SMITH(H, PARAMETER1, ..., PARAMETERN) plots the
%   specified parameters on the Z Smith chart. The first input is the
%   handle to the RFCKT object, and the other inputs PARAMETER1, ...,
%   PARAMETERN are the parameters to be visualized.
%
%   [HLINES, HSM] = SMITH(H, PARAMETER1, ..., PARAMETERN, TYPE) plots the
%   specified parameters on the specified TYPE of Smith chart. TYPE could
%   be 'Z', 'Y', or 'ZY'.
%
%   Type LISTPARAM(H) to see the valid parameters for the RFCKT object. 
%
%   This method has two outputs. The first is a column vector of handles to
%   lineseries objects, one handle per plotted line. The second output is
%   the handle to the Smith chart. The properties of the Smith chart
%   include,
%
%             Type: 'Z', 'Y', 'ZY', or 'YZ'
%           Values: 2*N matrix for the circles
%            Color: Color for the main chart
%        LineWidth: Line width for the main chart
%         LineType: Line type for the main chart
%         SubColor: Color for the sub chart
%     SubLineWidth: Line width for the sub chart
%      SubLineType: Line type for the sub chart
%     LabelVisible: 'on' or 'off'
%        LabelSize: Label size
%       LabelColor: Label color

%   Copyright 2004 The MathWorks, Inc. 
%   $Revision: 1.1.6.2 $  $Date: 2004/03/24 20:45:23 $

% Get the RFCKT object
h = varargin{1};

% Get the data object
data = getdata(h);

% Plot data by calling the method of RFDATA.DATA object
[hlines, hsm] = smith(data, varargin{2:end});
