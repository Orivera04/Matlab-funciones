function newy = interpolate(h, x, y, newx)
%INTERPOLATE Interpolate the data using INTERP1 function.
%   INTERPOLATE(H, X, Y, NEWY) interpolates Y(X) at NEWX by using MATLAB
%   function INTERP1.

%   Copyright 2004 The MathWorks, Inc.
%   $Revision: 1.1.6.2 $  $Date: 2004/03/05 18:21:40 $

% Set the default 
method = get(h, 'IntpType');
N = length(newx);

% Check the data to determine if an interpolation is needed
M = length(x);
if M == 1 
    % No need interpolation
    newy(1:N) = y(1);
    newy = newy(:);
elseif (length(x) == length(newx)) && all(x == newx)
    % No need interpolation
    newy = y;
else
    % Sort the data 
    [x, xindex] = sort(x);
    y(:) = y(xindex);

    % Interpolate
    newy = interp1(x, y(:), newx, method, NaN);
    
    % Extrapolate
    lowerindex = min(find(newx >= x(1)));
    index = find(newx < x(1));
    if ~isempty(index)
        if ~isempty(lowerindex)
            newy(index) = newy(lowerindex);
        else
            newy(index) = y(1);
        end
    end
    
    upperindex = max(find(newx <= x(end)));
    index = find(newx > x(end));
    if ~isempty(index)
        if ~isempty(upperindex)
            newy(index) = newy(upperindex);
        else
            newy(index) = y(end);
        end
    end    
end
