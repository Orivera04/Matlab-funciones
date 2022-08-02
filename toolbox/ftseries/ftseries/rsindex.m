function rsi = rsindex2(closep, nperiods)
%RSINDEX Relative Strength Index (RSI).
%
%   RSI = RSINDEX(CLOSEP) calculates the Relative Strength Index (RSI) from the
%   closing price column vector CLOSEP.  The RSI is calculated based on a 
%   default 14-period period.
%
%   RSI = RSINDEX(CLOSEP, NPERIODS) calculates the Relative Strength Index (RSI)
%   from the closing price vector CLOSEP.  The RSI will be calculated based on 
%   a NPERIODS-period period.
%
%   Note: The RS factor is calculated by dividing the sum of the closing values
%   for the up days by the sum of the closing values for the down days.
%
%     RS = sum(CLOSEP_up)/sum(CLOSEP_down)
%
%   Also, the first value of RSI, RSI(1), is a NaN in order to preserve the 
%   dimensions of CLOSEP.
% 
%   Example:   load disney.mat
%              dis_RSI = rsindex(dis_CLOSE);
%              plot(dis_RSI);
%
%   See also NEGVOLIDX, POSVOLIDX.

%   Reference: Murphy, John J., Technical Analysis of the Futures Market,
%              New York Institute of Finance, 1986, pp. 295-302

%   Author: P. N. Secakusuma, P. Wang
%   Copyright 1995-2003 The MathWorks, Inc.
%   $Revision: 1.13.2.2 $   $Date: 2004/04/06 01:09:48 $

% Check input arguments.
switch nargin
case 1
    nperiods = 14;
case 2
    if numel(nperiods) ~= 1 || mod(nperiods, 1) ~= 0
        error('Ftseries:rsindex:NPERIODSMustBeScalar', ...
            'NPERIODS must be a scalar integer.');
    elseif nperiods > length(closep)
        error('Ftseries:rsindex:NPERIODSTooLarge1', ...
            'NPERIODS is too large for the number of data points.');
    end
otherwise
    error('Ftseries:rsindex:InvalidNumberOfInputArguments', ...
        'Invalid number of input arguments.');
end

% Check to make sure closep is a column vector
if size(closep, 2) ~= 1
    error('Ftseries:rsindex:ClosepMustBeColumnVect', ...
    'Closing prices must be a column vector.');
end

% Check for data sufficiency.
if length(closep) < nperiods
    error('Ftseries:rsindex:NPERIODSTooLarge2', ...
        'NPERIODS is too large for the number of data points.');
end

% Calculate the Relative Strength index (RSI).
if (nperiods > 0) && (nperiods ~= 0)
    % Determine how many nans are in the beginning
    nanVals = isnan(closep);
    zeroValIdx = find(nanVals == 0);
    firstVal = min(zeroValIdx);
    numLeadNans = firstVal - 1;
    
    % Create vector of non nan closing prices
    nnanclosep = closep(~isnan(closep));
    
    % Take a diff of the non nan closing prices
    diffdata = diff(nnanclosep);
    
    % Calculate the RSI of the non nan closing prices. Ignore first non nan 
    % closep b/c it is a reference point and take into account any leading nans
    % that may exist in closep vector.
    trsi = repmat(NaN, size(diffdata, 1)-numLeadNans, 1);
    for didx = nperiods:size(diffdata, 1)
        upidx   = find(diffdata(didx-nperiods+1:didx) >= 0) + (didx-nperiods+1);
        downidx = find(diffdata(didx-nperiods+1:didx) <  0) + (didx-nperiods+1);
        if isempty(downidx)
            trsi(didx) = NaN;
        else
            rs         = sum(nnanclosep(upidx)) ./ sum(nnanclosep(downidx));
            trsi(didx) = 100 - (100/(1+rs));
        end
    end
    
    % Pre allocate vector taking into account reference value and leading nans.
    % length of vector = length(closep) - # of reference values - # of leading nans
    rsi = repmat(NaN, size(closep, 1)-1-numLeadNans, 1);
    
    % Populate rsi
    rsi(~isnan(closep(2+numLeadNans:end))) = trsi;
    
    % Add leading nans
    rsi = [repmat(nan, numLeadNans+1, 1); rsi];
elseif nperiods < 0
    error('Ftseries:rsindex:NPERIODSMustBePosScalar', ...
        'NPERIODS must be a positive scalar.');
else
    rsi = closep;
end


% [EOF]
