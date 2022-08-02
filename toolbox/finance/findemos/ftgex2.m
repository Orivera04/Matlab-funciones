%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Filename FTGEX2.M
% Financial Toolbox Graphics Example 2:
% Plotting Sensitivities of an Option
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%       Copyright 1995-2002 The MathWorks, Inc. 
%       $Revision: 1.8 $   $Date: 2002/04/14 21:42:50 $

figure('NumberTitle', 'off', ...
       'Name', 'Call Option Sensitivity Measures 1');

range = 10:70;
span = length(range);
j = 1:0.5:12;
newj = j(ones(span,1),:)'/12;

jspan = ones(length(j),1);
newrange = range(jspan,:);
pad = ones(size(newj));

zval = blsgamma(newrange, 40*pad, 0.1*pad, newj, 0.35*pad);
color = blsdelta(newrange, 40*pad, 0.1*pad, newj, 0.35*pad);

mesh(range, j, zval, color);
xlabel('Stock Price ($)');
ylabel('Time (months)');
zlabel('Gamma');
title('Call Option Sensitivity Measures Graph Example 1');
axis([10 70  1 12  -inf inf]);

set(gca, 'box', 'on', 'tag', 'mesh_axis_2');
colorbar('horiz');
%a = findobj(gcf, 'tag', 'mesh_axis');
%set(get(a, 'xlabel'), 'string', 'Delta');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% End of FTGEX2.M
