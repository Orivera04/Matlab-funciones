function relabel(figAxHandle, xtic, timeData,otherAx)
%RELABEL relabels the x-axis in conjunction with DATETICK2.

%   Author: P. Wang
%   Copyright 1995-2003 The MathWorks, Inc.
%   $Revision: 1.3.2.2 $   $Date: 2004/04/06 01:09:44 $

% Find length of axes
posit = get(figAxHandle,'position');
lenAx = posit(3);

% Find the min and max (limits) of the data set
minData = min(xtic);
maxData = max(xtic);

% Move out +/- x days or x hours.
[yrS, monS, dayS] = datevec(minData);
[yrE, monE, dayE] = datevec(maxData);

if abs(dayS - dayE) > 5
    minData = minData - 1;
    maxData = maxData + 1;
else
    if timeData == 1 % else do nothing
        minData = minData - 0.0005;
        maxData = maxData + 0.0005;
    end
end

% Get only the dates of the min and max
minDate = floor(minData);
maxDate = floor(maxData);

% Create new tickmarks based on axes size
if lenAx <= 5.65
    if timeData
        tickSpan = (maxData - minData) / 3;
        newTicks = minData:tickSpan:maxData;
    else
        % Scale the plot correctly by adding 1 or 2 dates to the xtick
        % so that when it is divided by 3, the ticks are even
        tickSpan = (maxData - minData) / 3;
        modTick = mod(tickSpan,1);
        if tickSpan < 1 % if there are less than 3 dates
            newTicks = minData:maxData;
        elseif modTick == 0 % if there is a multiple of 3 dates
            newTicks = minData:tickSpan:maxData;
        elseif abs(modTick - 2/3) < 1e-12
            % shift 1 right
            maxData = maxData + 1;
            tickSpan = (maxData - minData) / 3;
            newTicks = minData:tickSpan:maxData;
        elseif abs(modTick - 1/3) < 1e-12
            % shift 1 right and 1 left
            minData = minData - 1;
            maxData = maxData + 1;
            tickSpan = (maxData - minData) / 3;
            newTicks = minData:tickSpan:maxData;
        end
    end
elseif (lenAx > 5.65) & (lenAx <= 8.65)
    if timeData
        tickSpan = (maxData - minData) / 4;
        newTicks = minData:tickSpan:maxData;
    else
        % Scale the plot correctly by adding 1 - 3 dates to the xtick
        % so that when it is divided by 4, the ticks are even
        tickSpan = (maxData - minData) / 4;
        modTick = mod(tickSpan, 1);
        if tickSpan < 1 % if there are less than 4 dates
            newTicks = minData:maxData;
        elseif modTick == 0 % if there is a multiple of 4 dates
            newTicks = minData:tickSpan:maxData;
        elseif abs(modTick - 1/4) < eps 
            % shift 1 right
            maxData = maxData + 1;
            tickSpan = (maxData - minData) / 4;
            newTicks = minData:tickSpan:maxData;
        elseif abs(modTick - 2/4) < eps
            % shift 1 right and 1 left
            minData = minData - 1;
            maxData = maxData + 1;
            tickSpan = (maxData - minData) / 4;
            newTicks = minData:tickSpan:maxData;
        elseif abs(modTick - 3/4) < eps
            % shift 2 right and 1 left
            minData = minData - 1;
            maxData = maxData + 2;
            tickSpan = (maxData - minData) / 4;
            newTicks = minData:tickSpan:maxData;
        end
    end
elseif (lenAx > 8.65) & (lenAx <= 9.65)
    if timeData
        tickSpan = (maxData - minData) / 6;
        newTicks = minData:tickSpan:maxData;
    else
        % Scale the plot correctly by adding 1 - 5 dates to the xtick
        % so that when it is divided by 6, the ticks are even
        tickSpan = (maxData - minData) / 6;
        modTick = mod(tickSpan, 1);
        if tickSpan < 1 % if there are less than 4 dates
            newTicks = minData:maxData;
        elseif modTick == 0 % if there is a multiple of 4 dates
            newTicks = minData:tickSpan:maxData;
        elseif abs(modTick - 1/6) < 1e-12
            % shift 1 right
            maxData = maxData + 1;
            tickSpan = (maxData - minData) / 6;
            newTicks = minData:tickSpan:maxData;
        elseif abs(modTick - 2/6) < 1e-12
            % shift 1 right and 1 left
            minData = minData - 1;
            maxData = maxData + 1;
            tickSpan = (maxData - minData) / 6;
            newTicks = minData:tickSpan:maxData;
        elseif abs(modTick - 3/6) < eps
            % shift 2 right and 1 left
            minData = minData - 1;
            maxData = maxData + 2;
            tickSpan = (maxData - minData) / 6;
            newTicks = minData:tickSpan:maxData;
        elseif abs(modTick - 4/6) < 1e-12
            % shift 2 right and 2 left
            minData = minData - 2;
            maxData = maxData + 2;
            tickSpan = (maxData - minData) / 6;
            newTicks = minData:tickSpan:maxData;
        elseif abs(modTick - 5/6) < 1e-12
            % shift 3 right and 2 left
            minData = minData - 2;
            maxData = maxData + 3;
            tickSpan = (maxData - minData) / 6;
            newTicks = minData:tickSpan:maxData;
        end
    end
elseif lenAx > 9.65
    if timeData
        tickSpan = (maxData - minData) / 8;
        newTicks = minData:tickSpan:maxData;
    else
        % Scale the plot correctly by adding 1 - 5 dates to the xtick
        % so that when it is divided by 6, the ticks are even
        tickSpan = (maxData - minData) / 8;
        modTick = mod(tickSpan, 1);
        if tickSpan < 1 % if there are less than 4 dates
            newTicks = minData:maxData;
        elseif modTick == 0 % if there is a multiple of 4 dates
            newTicks = minData:tickSpan:maxData;
        elseif abs(modTick - 1/8) < eps
            % shift 1 right
            maxData = maxData + 1;
            tickSpan = (maxData - minData) / 8;
            newTicks = minData:tickSpan:maxData;
        elseif abs(modTick - 2/8) < eps
            % shift 1 right and 1 left
            minData = minData - 1;
            maxData = maxData + 1;
            tickSpan = (maxData - minData) / 8;
            newTicks = minData:tickSpan:maxData;
        elseif abs(modTick - 3/8) < eps
            % shift 2 right and 1 left
            minData = minData - 1;
            maxData = maxData + 2;
            tickSpan = (maxData - minData) / 8;
            newTicks = minData:tickSpan:maxData;
        elseif abs(modTick - 4/8) < eps
            % shift 2 right and 2 left
            minData = minData - 2;
            maxData = maxData + 2;
            tickSpan = (maxData - minData) / 8;
            newTicks = minData:tickSpan:maxData;
        elseif abs(modTick - 5/8) < eps
            % shift 3 right and 2 left
            minData = minData - 2;
            maxData = maxData + 3;
            tickSpan = (maxData - minData) / 8;
            newTicks = minData:tickSpan:maxData;
        elseif abs(modTick - 6/8) < eps
            % shift 3 right and 3 left
            minData = minData - 3;
            maxData = maxData + 3;
            tickSpan = (maxData - minData) / 8;
            newTicks = minData:tickSpan:maxData;
        elseif abs(modTick - 7/8) < eps
            % shift 4 right and 3 left
            minData = minData - 3;
            maxData = maxData + 4;
            tickSpan = (maxData - minData) / 8;
            newTicks = minData:tickSpan:maxData;
        end % end of 'if tickSpan < 1'
    end % end of 'if timeData'
end % end of 'if lenAx <= 5.65'

if length(xtic) == 1
    newTicks = [xtic - 1, xtic, xtic + 1];
end

% Default to x axis if 3 inputs
if nargin == 3
    datetick2('x', 0, 'keeplimits', newTicks, timeData);
elseif nargin == 4
    datetick2(otherAx, 0, 'keeplimits', newTicks, timeData);
end

% Normalize everything
set(figAxHandle, 'units', 'normalized');

% [EOF]
