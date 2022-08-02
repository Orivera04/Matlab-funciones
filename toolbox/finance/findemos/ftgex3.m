%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Filename FTGEX3.M
% Financial Toolbox Graphics Example 3:
% Plotting Sensitivities of a Portfolio of Options
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%       Copyright 1995-2002 The MathWorks, Inc. 
%       $Revision: 1.8 $   $Date: 2002/04/14 21:43:36 $

figure('NumberTitle', 'off', ...
       'Name', 'Call Option Sensitivity Measures 2');

range = 20:90;
plen = length(range);
exprice = [75 70 50 55 75 50 40 75 60 35];

rate = 0.1*ones(10,1);
time = [36  36  36  27  18  18  18  9  9  9];
sigma = 0.35*ones(10,1);
numopt = 1000*[4  8  3  5  5.5  2  4.8  3  4.8  2.5];
zval = zeros(36, plen);
color = zeros(36, plen);

for i = 1:10
       pad = ones(time(i),plen);
       newr = range(ones(time(i),1),:);

       t = (1:time(i))';
       newt = t(:,ones(plen,1));

       zval(36-time(i)+1:36,:) = zval(36-time(i)+1:36,:) ...
              + numopt(i) * blsgamma(newr, exprice(i)*pad, ...
              rate(i)*pad, newt/36, sigma(i)*pad);

       color(36-time(i)+1:36,:) = color(36-time(i)+1:36,:) ...
              + numopt(i) * blsdelta(newr, exprice(i)*pad, ...
              rate(i)*pad, newt/36, sigma(i)*pad);
end

mesh(range, 1:36, zval, color);
view(60,60);
set(gca, 'xdir','reverse', 'tag', 'mesh_axes_3');
axis([20 90  0 36  -inf inf]);

title('Call Option Sensitivity Measures Graph Example 2');
xlabel('Stock Price ($)');
ylabel('Time (months)');
zlabel('Gamma');
set(gca, 'box', 'on');
colorbar('horiz');

%a = findobj(gcf, 'tag', 'mesh_axes_3');
%set(get(a, 'xlabel'), 'string', 'Delta');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% End of FTGEX3.M
