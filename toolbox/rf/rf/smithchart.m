function [hlines, hsm] = smithchart(y)
%SMITHCHART Plot the complex data on Smith chart.
%   [HLINES, HSM] = SMITHCHART(Y) plots complex data Y on Smith chart.
%
%   [HLINES, HSM] = SMITHCHART draws a Smith chart.
%  
%   This function has two outputs. The first is a column vector of handles
%   to lineseries objects, one handle per plotted line. The second output
%   is the handle to the Smith chart. The properties of the Smith chart
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

%   Copyright 2003-2004 The MathWorks, Inc.
%   $Revision: 1.1.6.8 $  $Date: 2004/04/12 23:39:06 $

hlines = [];
% Draw a Smith chart
fig = gcf;
set(fig, 'Name', 'The Smith chart');
hsm = rfchart.smith;

% Check the input number
if nargin < 1; return; end;

hold on;
% Call PLOT to plot the complex data on Smith chart
hlines = plot(y);
hold off;
