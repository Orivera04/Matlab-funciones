function TimeSpec = bdttimespec(varargin)
%BDTTIMESPEC Specify time structure for a BDT tree.
%   Set the number of levels and node times for a BDT tree, and
%   determine the mapping between dates and time for rate quoting.
%   
%   TimeSpec = bdttimespec(ValuationDate, Maturity)
%   TimeSpec = bdttimespec(ValuationDate, Maturity, Compounding)
%
% Inputs:
%   ValuationDate - Scalar date marking the pricing date and first observation
%                   in the tree. Specify ValuationDate as a serial date number 
%                   or date string.
%
%   Maturity      - NLEVELS x 1 vector of dates marking the cash flow
%                   dates of the tree.  Cash flows with these maturities will fall 
%                   on tree nodes.  This argument determines the number of levels, 
%                   or depth, of the tree.  Maturity should be in increasing order.
%
% Optional Inputs:
%   Compounding   - Scalar value representing the frequency at which the rates
%                   are compounded when annualized. Default = 1. This argument 
%                   determines the formula for the discount factors and  
%                   interpretation of times as follows: 
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
% Output:
%   TimeSpec - Structure specifying the time layout for BDTTREE.  The
%              state observation dates are [ValuationDate; Maturity(1:end-1)].  
%              Because a forward rate is stored at the last observation, the 
%              tree can value cash flows out to Maturity(end).
%
% Example:
%   Specify an 8-period tree with semi-annual nodes (every 6 months).
%   Use exponential compounding to report rates.
%
%   Compounding = -1
%   ValuationDate = '15-Jan-1999'
%   Maturity = datemnth(ValuationDate, 6*(1:8)' )
%   TimeSpec = bdttimespec(ValuationDate, Maturity, Compounding)
%
% See also BDTTREE, BDTVOLSPEC.

%   Copyright 1998-2002 The MathWorks, Inc. 
%   $Revision: 1.4 $  $Date: 2002/04/14 16:39:43 $

% -------------------------------------------------
% Use the equivalent fcn from HJM
HJMTimeSpec = hjmtimespec(varargin{:});

% -------------------------------------------------
% For now, simply change the name of the structure,
% and copy the rest of the fields.
TimeSpec = classfin('BDTTimeSpec');

TimeSpec.ValuationDate = HJMTimeSpec.ValuationDate;
TimeSpec.Maturity      = HJMTimeSpec.Maturity;
TimeSpec.Compounding   = HJMTimeSpec.Compounding;
TimeSpec.Basis         = HJMTimeSpec.Basis;
TimeSpec.EndMonthRule  = HJMTimeSpec.EndMonthRule;


