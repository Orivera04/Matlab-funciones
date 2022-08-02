function [macdvec, nineperma] = macd(data, dim)
%@FINTS/MACD   Moving Average Convergence/Divergence (MACD).
%
%   [MACDVEC, NINEPERMA] = MACD(DATA) calculates the Moving Average
%   Convergence/Divergence (MACD) line, MACDVEC, from the data vector, DATA,
%   as well as the 9-period exponential moving average, NINEPERMA, from the 
%   MACD line.
%
%   When the two lines are plotted, they can give you indications on when
%   to buy or sell a stock, when overbought or oversold is occurring, and 
%   when the end of trend may occur.
%
%   The MACD is calculated by subtracting the 26-period (7.5%) exponential 
%   moving average from the 12-period (15%) moving average.  The 9-period 
%   (20%) exponential moving average of the MACD line is used as the 
%   "signal" line.  For example, when the MACD and the 20% moving average 
%   line has just crossed and the MACD line becomes below the other line, 
%   it is time to sell.
%
%   [MACDVEC, NINEPERMA] = MACD(DATA, DIM) lets you specify in what direction
%   the input is oriented.  If the input DATA is a matrix, you need to tell
%   the orientation of the data whether each row is a set of observations
%   (DIM = 2) or each column is a set of observation (DIM = 1).  If it is not
%   specified, it will be assumed that the data is column-oriented (i.e. each
%   column is a set of observations).
%
%   Example:   load disney.mat
%              dis_CloseMACD = macd(dis_CLOSE);
%              dis_OpenMACD = macd(dis_OPEN);
%              plot(dis_CloseMACD);
%              plot(dis_OpenMACD);
%
%   See also ADLINE, WILLAD.

%   Reference: Achelis, Steven B., Technical Analysis From A To Z,
%              Second Printing, McGraw-Hill, 1995, pg. 166-168

%   Author: P. Wang
%   Copyright 1995-2002 The MathWorks, Inc.
%   $Revision: 1.9.2.1 $   $Date: 2003/01/16 12:51:20 $

% Check input argument.
switch nargin
    case 1
        % Size of input
        [vi,vj] = size(data);
        
        if vi == 1
            dim = 2;
            % Number of variables
            numVars = vi;
            
        elseif vj == 1
            dim = 1;
            % Number of variables
            numVars = vj;
        else
            dim = 1;
            % Number of variables
            numVars = vj;
        end
    case 2
        % Size of input
        [vi,vj] = size(data);
        
        if dim == 1
            % Number of variables
            numVars = vj;
        else
            % Number of variables
            numVars = vi;
        end
    otherwise
        error('Ftseries:ftseries_macd:InvalidNumberOfInputs', ...
            'Invalid number of inputs.');
end

% Get the warning state.
w = warning;
warning off Ftseries:ftseries_tsmovavg:WarnSyntaxChange

% Pre allocate vars
ema26p = repmat(nan,size(data));
ema12p = ema26p;

% Calculate the 26-period (7.5%)exp mov avg and the 12-period (15%) exp mov avg
for idx = 1:numVars
    if dim == 1 % Column oriented
        % 26-period (7.5%)exp mov avg
        try
            ema26p(~isnan(data(:,idx)),idx) = tsmovavg(data(~isnan(data(:,idx)),idx), 'e', 26, dim);
        catch
            errMsg = lasterror;
            errormessage(errMsg,26);
        end
        
        % 12-period (15%) exp mov avg
        try
            ema12p(~isnan(data(:,idx)),idx) = tsmovavg(data(~isnan(data(:,idx)),idx), 'e', 12, dim);
        catch
            errMsg = lasterror;
            errormessage(errMsg,12);
        end
    else % Row oriented
        % 26-period (7.5%)exp mov avg
        try
            ema26p(idx,~isnan(data(idx,:))) = tsmovavg(data(idx,~isnan(data(idx,:))), 'e', 26, dim);
        catch
            errMsg = lasterror;
            errormessage(errMsg,26);
        end
        
        % 12-period (15%) exp mov avg
        try
            ema12p(idx,~isnan(data(idx,:))) = tsmovavg(data(idx,~isnan(data(idx,:))), 'e', 12, dim);
        catch 
            errMsg = lasterror;
            errormessage(errMsg,12);
        end
    end
end

% Calculate the MACD line.
macdvec = ema12p - ema26p;

% Calculate the 9-period (20%) exp mov avg of the MACD line.
nineperma = repmat(nan,size(data));

for idx = 1:numVars
    if dim == 1 % Column oriented
        try
            nineperma(~isnan(macdvec(:,idx)),idx) = tsmovavg(macdvec(~isnan(macdvec(:,idx)),idx), 'e', 9, dim);
        catch
            errMsg = lasterror;
            errormessage(errMsg,9);
        end
    else % Row oriented
        try
            nineperma(idx,~isnan(macdvec(idx,:))) = tsmovavg(macdvec(idx,~isnan(macdvec(idx,:))), 'e', 9, dim);
        catch
            errMsg = lasterror;
            errormessage(errMsg,9);
        end
    end
end

% Turn warning back on
warning(w)

% ------------------------------------------
function errormessage(errMsg,period)
% ERRORMESSAGE Error message generator for MACD.

if period ~= 9
    if strcmp(errMsg.identifier,'Ftseries:ftseries_tsmovavg:InvalidLag')
        error('Ftseries:ftseries_macd:TooFewObservations', ...
            ['There must be at least ',num2str(period),' nonNaN values in each set of observations.']);
    else
        error('Ftseries:ftseries_macd:TsmovavgError', ...
            errMsg.message);
    end
else
    if strcmp(errMsg.identifier,'Ftseries:ftseries_tsmovavg:InvalidLag')
        error('Ftseries:ftseries_macd:TooFewObservations9Per', ...
            ['There must be at least ',num2str(period),' nonNaN values in the MACD Line (MACDVEC).']);
    else
        error('Ftseries:ftseries_macd:TsmovavgError9Per', ...
            errMsg.message);
    end
end

% [EOF]
