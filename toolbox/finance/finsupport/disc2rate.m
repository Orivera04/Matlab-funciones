function [Rates, EndTimes, StartTimes] = disc2rate(Compounding, Disc, EndX, StartX, Settle, Basis, EndMonthRule)
%DISC2RATE Convert cash flow discounting factors to interest rates
%   Computes the yields over a series of NPOINTS time intervals given
%   the cash flow discounts over those intervals.  NCURVES different rate
%   curves can be translated at once if they have the same time structure.
%   The time intervals can represent a zero curve or a forward curve.
%
%   Usage 1: Interval points input as times in periodic units
%     [Rates] = disc2rate(Compounding, Disc, EndTimes, StartTimes)
%     [Rates] = disc2rate(Compounding, Disc, EndTimes)
%
%   Usage 2: ValuationDate passed and interval points input as dates
%     [Rates, EndTimes, StartTimes] = disc2rate(Compounding, Disc, ... 
%       EndDates, StartDates, ValuationDate)
%
%   Inputs:
%     Compounding - scalar value representing the frequency at which the
%     input zero rates were compounded when annualized.  This argument
%     determines the formula for the discount factors and interpretation of
%     times as follows:   
%     1) Compounding = 1, 2, 3, 4, 6, 12 = F
%        Disc = (1 + Z/F)^(-T), where F is the compounding frequency,
%        Z is the zero rate, and T is the time in periodic units, i.e. T=F
%        is one year.
%     2) Compounding = 365 
%        Disc = (1 + Z/F)^(-T), where F is the number of days in the
%        basis year and T is a number of days elapsed computed by basis.
%     3) Compounding = -1
%        Disc = exp( -T * Z ), where T is time in years.
%
%     Disc - NPOINTS by NCURVES vector of discounts.  Disc are unit bond
%     prices over investment intervals from StartTimes, where the cash
%     flow is valued, to EndTimes, where the cash flow is received.
%
%   Usage 1: When ValuationDate is not passed, the third and fourth arguments
%   are interpreted as times:
%
%     EndTimes - NPOINTS by 1 vector or scalar of times in periodic units
%     ending the interval to discount over.
%
%     StartTimes - NPOINTS by 1 vector or scalar of times in periodic units
%     starting the interval to discount over.  StartTimes is optional and
%     the default value is 0.
%
%   Usage 2: When ValuationDate is passed, the third and fourth arguments are
%   interpreted as dates.  The date ValuationDate is used as the zero point for
%   computing the times:
%
%     EndDates - NPOINTS by 1 vector or scalar of serial maturity dates
%     ending the interval to discount over.
%
%     StartDates - NPOINTS by 1 vector or scalar of serial dates starting the
%     interval to discount over.  StartDates is optional and the default
%     value is ValuationDate.
%
%     ValuationDate - scalar value in serial date number form representing the
%     observation date of the investment horizons entered in StartDates and
%     EndDates.  ValuationDate is required in usage 2.  ValuationDate
%     must be omitted or passed as an empty matrix to invoke usage 1. 
%
%   Outputs:
%     Rates - NPOINTS by NCURVES column vector of yields in decimal form
%     over the NPOINTS time intervals.
% 
%     StartTimes - NPOINTS by 1 column vector of times starting the
%     interval to discount over, measured in periodic units.  
%
%     EndTimes - NPOINTS by 1 column vector of times ending the
%     interval to discount over, measured in periodic units.  
%  
%   Notes:
%     If Compounding = 365 (daily), StartTimes and EndTimes are measured in days.
%     The arguments otherwise contain values, T, computed from SIA semi-annual
%     time factors, Tsemi, by the formula T = Tsemi/2 * F, where F is the
%     compounding frequency.  F is set to 1 for continuous compounding. 
%
%     The investment intervals can be specified either with input times
%     (Usage 1) or with input dates (Usage 2).  Entering the argument,
%     ValuationDate, invokes the date interpretation, with omitting
%     ValuationDate invokes the default time interpretations.
%
%   See also RATE2DISC, RATETIMES.

%   Author(s): J. Akao 11/03/98
%   Copyright 1995-2002 The MathWorks, Inc. 
%   $Revision: 1.13 $  $Date: 2002/04/14 21:38:38 $

% Defaults for market basis
if ( nargin < 7 | isempty(EndMonthRule) | isnan(EndMonthRule(1)) )
  EndMonthRule = 1;
end

if ( nargin < 6 | isempty(Basis) | isnan(Basis(1)) )
  Basis = 0;
end

% Decide if times are in date form or time form
if (nargin < 5 | isempty(Settle) | isnan(Settle(1)) )
  % Interpret RefEndX, RefStartX, EndX, StartX arguments as times
  TimeArgForm = 'times';

else
  % check if settlement is a date string
  if ischar(Settle)
    Settle = datenum(Settle);
  end
  
  % check if settlement is a scalar
  if length(Settle)~=1
    error('Settle must be a single date')
  end

  % Interpret RefEndX, RefStartX, EndX, StartX arguments as times
  TimeArgForm = 'dates';

end

% Collect date/time arguments
if (nargin < 4)
  StartX = [];
end

if (nargin < 3)
  EndX = [];
end

if isempty(StartX) & strcmp(TimeArgForm,'dates')
    StartX = Settle;
end

% Parse size of the rates
[NumPts, NumCurves] = size(Disc);

% Default is semi-annual Compounding 
if isempty(Compounding)
  Compounding=2;
end

%---------------------------------------------------------------------
% Convert to times from dates if needed
if strcmp(TimeArgForm,'dates')
  StartTimes    = date2time(Settle,    StartX, Compounding,Basis,EndMonthRule);
  EndTimes      = date2time(Settle,      EndX, Compounding,Basis,EndMonthRule);
else
  StartTimes = StartX;
  EndTimes = EndX;
end

  
%---------------------------------------------------------------------
% Set default curve forms
% 
% StartTimes [NumPts x 1]
%   EndTimes [NumPts x 1]
% DeltaTimes [NumPts x 1]
%---------------------------------------------------------------------

[mE,nE] = size(EndTimes);
if (nE>1)
  error('EndTimes argument must be a single column vector');
elseif ( (mE>1) & (mE~=NumPts) )
  error('EndTimes must have as many points as the Rate curves');
end

[mS,nS] = size(StartTimes);
if (nS>1)
  error('StartTimes argument must be a single column vector');
elseif ( (mS>1) & (mS~=NumPts) )
  error('StartTimes must have as many points as the Rate curves');
end

% scalar expansion
if mE==1,
  EndTimes = EndTimes(ones(NumPts,1));
end
if mS==1,
  StartTimes = StartTimes(ones(NumPts,1));
end

% Empty expansion
if isempty(StartTimes)
  % zero curve
  StartTimes = zeros(NumPts,1);
end
if isempty(EndTimes)
  % Unit forward curve
  EndTimes = StartTimes + 1;
end

% Compute length of the time intervals
DeltaTimes = EndTimes - StartTimes;

% Mask DeltaTimes = 0 : rate is undefined
% DTMask is defined rates
DTMask = ( DeltaTimes ~= 0 );

% Expand to the number of curves
DeltaTimes = DeltaTimes(DTMask,ones(1,NumCurves));


%---------------------------------------------------------------------
% Compute Frequency
switch Compounding
  case {1, 2, 3, 4, 6, 12}
    % Periodic
    F = Compounding;
    
  case -1
    % Continuous (yearly time)
    F = 1;
    
  case 365
    % Daily
    F = 365;

  otherwise
    error('Invalid Compounding specified')
end

%---------------------------------------------------------------------
% Compute Rates
Rates = zeros(NumPts, NumCurves);

switch Compounding
  case {1, 2, 3, 4, 6, 12, 365}
    % Periodic
    % Disc = (1 + Rates/F).^(-DeltaTimes); 
    Rates(DTMask,:) = F*( Disc(DTMask,:).^(-1./DeltaTimes) - 1 );
    
  case -1
    % Continuous (yearly time)
    % Disc = exp( -Rates/F .* DeltaTimes );
    Rates(DTMask,:) = F*( log( Disc(DTMask,:) )./(-DeltaTimes) );
    
end

%---------------------------------------------------------------------
% By convention, interpolate undefined rates from defined rates
% Interpolate the EndTimes (Incomplete)
if any(DTMask) & any(~DTMask),
  UndefTimes = EndTimes(~DTMask);
  DefTimes = EndTimes(DTMask);
end


%   Rates run over investment intervals from StartTimes, where the cash
%   flow is valued, to EndTimes, where the cash flow is received.
%   At least one of starting or ending points is required.  If only
%   ending times or dates are entered, all intervals start at T=0 (zero
%   curve).  If only starting times or dates are entered, intervals end
%   at StartTimes + 1 (future spot rates).  An arbitrary set of forward
%   rates can be input by entering both starting and ending times.
