function lims = mbcmakelimits(data, opt)
%MBCMAKELIMITS Create min/max limits pair for data
%
%  LIMS = MBCMAKELIMITS(DATA) returns a [MIN, MAX] limits pair for DATA.
%  DATA can be a vector or multi-dimensional matrix.  MIN and  MAX will be
%  suitable for use as axes limits: MIN < MAX and they are both finite.
%
%  LIMS = MBCMAKELIMITS(DATA, ALGOPTION) specifies how the limits shoul dbe
%  calculated.  The default is 'tight' which bounds the min and max to the
%  extent of the data.  'loose' will add a buffer to the top and bottom and
%  then round to an appropriate number.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.6.4 $    $Date: 2004/04/04 03:29:25 $ 

F = isfinite(data);
if ~any(F)
    lims = [0 1];
else
    lims = [0 0];
    lims(1) = min(data(F));
    lims(2) = max(data(F));
    
    if (lims(2)-lims(1))<100*eps
        if abs(lims(1))<(50*eps)
            lims = [-1 1];
        else
            mid = mean(lims);
            if lims(1)<0
                lims(2) = 0.9*mid;
                lims(1) = 1.1*mid;
            else
                lims(1) = 0.9*mid;
                lims(2) = 1.1*mid;
            end
        end
    else
        if nargin>1 && strcmp(opt, 'loose')
            % Perform additional processing to make nice limits
            startlims = lims;
            
            range = lims(2) - lims(1);
            mag = (10.^floor(log10(abs(range))));
            lims(1) = floor(lims(1)./mag).*mag;
            lims(2) = ceil(lims(2)./mag).*mag;
            
            % If this process has not opened a big enough gap at the top
            % and bottom, widen it slightly
            if (startlims(1)-lims(1))<(mag*eps)
                lims(1) = lims(1) - 0.5*mag;
            end
            if (lims(2)-startlims(2))<(mag*eps)
                lims(2) = lims(2) + 0.5*mag;
            end
        end
    end
end
