function vout = tsmovavg(vin, mode, varargin)
%TSMOVAVG calculates the (weighted) moving average of a vector of data.
%
%   Syntax: VO = TSMOVAVG(VI, 's', LAG, DIM)        => SIMPLE, s
%           VO = TSMOVAVG(VI, 'e', TIMEPER, DIM)    => EXPONENTIAL, e
%           VO = TSMOVAVG(VI, 't', NUMPER, DIM)     => TRIANGULAR, t
%           VO = TSMOVAVG(VI, 'w', WEIGHTS, DIM)    => WEIGHTED, w
%           VO = TSMOVAVG(VI, 'm', NUMPER, DIM)     => MODIFIED, m
%
%   NOTE: The Simple and Weighted moving averages have a new calling
%   syntax. This is different from previous versions of this function.
%   The simple moving average does not require a LEAD input and the
%   weighted moving average does not require a PIVOT point. [END NOTE]   
%  
%   VI is assumed to be a row vector or row-oriented matrix. DIM is an
%   optional input, and if it is not included as an input, the default
%   value 2 is assumed. DIM = 2 means that each row is a variable and
%   each column is an observation (row-oriented matrix). If a column-
%   oriented matrix is supplied for VI (i.e. each column is a variable 
%   and each row is an observation) then a DIM must be included and set
%   to the value DIM = 1. VO is identical in form to VI. 
%
%   Simple Moving Average:
%   LAG is the parameter indicating the number of previous data points to
%   be used in conjunction with the current data point when calculating 
%   the moving average. LAG can also be thought of as the window size or
%   number of periods of the moving average.
%
%   Exponential Moving Average:
%   Exponential moving average is a weighted moving average, where TIMEPER is
%   the time period of the exponential moving average. Exponential moving 
%   averages reduce the lag by applying more weight to recent prices. For 
%   example, a 10 period exponential moving average weights the most recent
%   price by 18.18%.
% 
%   Exponential Percentage = 2/(TIMEPER + 1) or 2/(WINDOW_SIZE + 1)
%
%   Triangular Moving Average:
%   Triangular moving average is a double-smoothing of the data. The first
%   simple moving average is calculated with a window width of
%   CEIL((NUMPER+1)/2). Then a second simple moving average is calculated
%   on the first moving average with the same window size.
%
%   Weighted Moving Average:
%   A weighted moving average is calculated with a weight vector, WEIGHTS.
%   The length of the weight vector determines the size of the window. If
%   larger weight factors are used for more recent prices and smaller factors
%   for previous prices, the trend will be more responsive to recent changes.
%
%   Modified Moving Average:
%   The modified moving average calculation is similar to the simple moving
%   average calculation. NUMPER can be thought of as the LAG of the simple
%   moving average. The first modified moving average value, VO(NUMPER), is
%   calculated the same way the first simple moving average value is 
%   calculated. All subsequent values are calculated by adding the new 
%   price and then subtracting the last average from the resulting sum.
%
%   See also MEAN, PERAVG.

%   Reference: Achelis, Steven B., Technical Analysis From A To Z,
%              Second Printing, McGraw-Hill, 1995, pg. 184-192

%   Author: P. Wang
%   Copyright 1999-2003 The MathWorks, Inc.
%   $Revision: 1.12.2.5 $  $Date: 2004/04/06 01:09:50 $


% Warn of syntax change. 
warning('Ftseries:ftseries_tsmovavg:WarnSyntaxChange', ...
    sprintf(['TSMOVAVG is different from previous versions of this\n', ...
        'function (Financial Time Series Toolbox version 2.0 and lower)\n', ...
        'The simple moving average does not require a LEAD input and\n', ...
        'the weighted moving average does not require a PIVOT point.']));

% Transpose input if necessary. If nargin == 3, assume
% the user supplied a row oriented matrix.
if nargin == 4
    dim = varargin{2};
    if dim == 1  
        % If input is column-oriented, transpose.
        vin = vin';
    elseif dim == 2    
        % Default, do nothing.
    else
        error('Ftseries:ftseries_tsmovavg:InvalidDIM', ...
            'Invalid DIM indicator. DIM = 1 (column vector); Dim = 2 (row vectors).');
    end
elseif (nargin < 3) || (nargin > 4)
    error('Ftseries:ftseries_tsmovavg:InvalidNumOfInputs', ...
        'Invalid number of inputs.');
end

% vinVars = # variables; observ = # obervations
[vinVars,observ] = size(vin);

% Mov Avg modes and calculations
switch lower(mode(1))
    case 's' % Simple
        % Lag window size
        lag = varargin{1};
        
        % Calculate simple mov avg
        vout = simplema(vin,lag,vinVars,observ);
        
    case 'e' % Exponential
        % Get the time periods
        if nargin < 3
            timePer = 5;
        elseif nargin <= 4
            timePer = varargin{1};
        else
            error('Ftseries:ftseries_tsmovavg:InvalidNumOfInputsExponential', ...
                'Invalid number of inputs.');
        end
        
        % Calculate the exponential percentage
        k = 2 / (timePer + 1);
        
        % Calculate the simple moving average. The timPer period's mov avg
        % is used as the first 'exp mov avg' in the calculation. 
        vout = simplema(vin,timePer,vinVars,observ);
        
        % Calculate exp mov avg
        firstCalc = 1;
        for idx = timePer:observ
            if firstCalc == 1
                % First period calculation
                vout(:,timePer) = (vin(:,idx) * k) + (vout(:,timePer) * (1 - k));
                firstCalc = firstCalc + 1;
            else
                % Remaining periods calculation
                vout(:,idx) = (vin(:,idx) * k) + (vout(:,idx-1) * (1 - k));
            end
        end
        
    case 't' % Triangular
        % Get the time periods
        if nargin < 3
            numPer = 5;
        elseif nargin <= 4
            numPer = varargin{1};
        else
            error('Ftseries:ftseries_tsmovavg:InvalidNumOfInputsTriangular', ...
                'Invalid number of inputs.');
        end
        
        % Window size
        maPer = ceil((numPer + 1) / 2);
        
        % First moving average
        movAvg1 = simplema(vin,maPer,vinVars,observ);
        
        % Second moving average
        vout = simplema(movAvg1,maPer,vinVars,observ);
        
    case 'w' % Weighted
        % Get the weights
        if (nargin >= 3) && (nargin <= 4)
            weights = varargin{1};
            
            % Determine the length of the weights (window size)
            [wi,lenWghts] = size(weights);
            if wi ~= 1
                error('Ftseries:ftseries_tsmovavg:WeightMustBeRowVector', ...
                    'The weights must a row oriented vector.');
            end
        else
            error('Ftseries:ftseries_tsmovavg:InvalidNumOfInputsWeighted', ...
                'Invalid number of inputs.');
        end
        
        % Sum of weights
        sumWghts = sum(weights);
        
        % Preallocate a vector of nans
        vout =  ones(size(vin))*nan;
        
        % repmat the weights vector to have the same number of rows as the input
        weights = repmat(weights, size(vin, 1), 1);
        
        % Calculate the weighted mov avg
        for idx = lenWghts:observ
            vout(:,idx) = sum(weights.*vin(:,idx-lenWghts+1:idx),2) / sumWghts;
        end
        
    case 'm' % Modified
        % Get the number of periods 
        if nargin < 3
            numPer = 5;
        elseif nargin <= 4
            numPer = varargin{1};
        else
            error('Ftseries:ftseries_tsmovavg:InvalidNumOfInputsExponential', ...
                'Invalid number of inputs.');
        end
        
        % Calculate simple mov avg. The first point of the modified moving 
        % average is calculated the same way the first point of the simple
        % moving average is calculated. However, all subsequent points are
        % calculated using the modified mov avg formula.
        vout = simplema(vin,numPer,vinVars,observ);
        
        % Calculate modified mov avg
        for idx = numPer+1:observ
            % Remaining periods calculation
            vout(:, idx) = vout(:, idx-1) + (vin(:, idx)-vout(:, idx-1))/numPer;
        end
        
    otherwise
        error('Ftseries:ftseries_tsmovavg:InvalidMode', ...
            'Invalid mode for moving average calculation.');
end

% Transpose output (if appropriate) so it is the same
% size as the input.
if exist('dim', 'var') && dim == 1
    vout = vout';
end

% -------------------------------------------------------------------------
function simOut = simplema(vin,lag,vinVars,observ)
% Simple moving average

if (lag <= 0) || (lag >= observ)
    error('Ftseries:ftseries_tsmovavg:InvalidLag', ...
        'Lag must be greater than 0 or less than the number of observations.');
end

% Preallocate a vector of nans
simOut = repmat(nan,size(vin));

% Using filter about 3x times faster than above with a vector size 96750x29
for idx = 1:vinVars
    % Simple moving average
    ma = filter(ones(1,lag)/lag, 1, vin(idx,:));
    
    % Fill in the NaN's vector
    simOut(idx,lag:end) = ma(lag:end);
end

% [EOF]
