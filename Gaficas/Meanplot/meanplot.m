function meanplot(nfig)
% produce average plot of figure #nfig, without knowing original x, y data
% by Hongxue Cai @ Northwestern University

% get handles of al line-type objects in figure #nfig
h = findobj(figure(nfig), 'type', 'line');

% get x,y data (cell arrays)
x = get(h, 'xdata');
y = get(h, 'ydata');

% find the maxmum of y
for k = 1:length(h)
    yy = y{k};
    maxy (k) = max(yy);
end
ymax = max(maxy);

% xAll contains all non-repeated x values in x{1} ~ x{length(h)}
xAll = x{1};
for k = 1:length(h)-1
    xAll = x1x2combine(xAll,x{k+1});
end

%interpolation
for k=1:length(h)
    xx = x{k};
    yy = y{k};
    ynew(k,1:length(xAll)) = interp1(xx, yy, xAll);
    
    % For all values in xAll but outside the range of xx, set corresponding
    % y a special number, which will not be used in the calculation of the
    % average
    ynew(k, xAll < xx(1)) = ymax + 9999;
    ynew(k, xAll > xx(length(xx))) = ymax + 9999;
end

% computation of average
for j = 1:length(xAll)
    n = 0;
    ytemp = 0;
    for k = 1:length(h)
        if ynew(k,j) ~= ymax + 9999 % special number excluded
            n = n + 1;
            ytemp = ytemp + ynew(k,j);
        end
    end
    yAll(j) = ytemp/n;
end

% plotting average line
figure(nfig)
hold on
plot(xAll, yAll, 'color', 'k', 'Linewidth', 2)