function plot_curve(c, M, str)

% plot_curve - plot a 2d curve.
% 
% plot_curve(c, str, M);
%
%   Note that 'c' can also be a cell array of curves.
%   - 'c' is of size 2xm
%   - 'M' is a nxn image put in background (ranging in [0,1]�)
%   - 'str' is the style of the curve.
%
%   Copyright (c) 2004 Gabriel Peyr�

if nargin<3
    str = 'k';
end
if nargin<2
    M = [];
end

hold on;

if ~isempty(M)
    n = size(M,1);
    x = 0:1/(n-1):1;
    % display image in X/Y frame
    M = M';
%    M = M(end:-1:1,:);
    imagesc(x,x,M);
end

if ~iscell(c)
    plot( c(1,:), c(2,:), str );
else
    
    if ~iscell(str)
        str1 = str; clear str;
        for i=1:length(c)
            str{i} = str1;
        end        
    end
    
    for i=1:length(c)
        plot( c{i}(1,:), c{i}(2,:), str{i} );
    end
end
axis tight;
hold off;