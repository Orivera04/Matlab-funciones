function [Price] = asianbycrr(BinStockTree, varargin)
%ASIANBYCRR Price asian options by a CRR binomial tree.
%
%   Price = asianbycrr(CRRTree, OptSpec, Strike, Settle, ExerciseDates)
%                                      
%   Price = asianbycrr(CRRTree, OptSpec, Strike, Settle,ExerciseDates, ...
%                     AmericanOpt)
%
%   Price = asianbycrr(CRRTree, OptSpec, Strike, Settle,ExerciseDates, ...
%                     AmericanOpt, AvgType)
%
%
%   Price = asianbycrr(CRRTree, OptSpec, Strike, Settle,ExerciseDates, ...
%                     AmericanOpt, AvgType, AvgPrice, AvgDate)
%
% Inputs: Type "help instasian" for a description of asian contract arguments.   
%
%   CRRTree         - Stock tree structure created by CRRTREE.
%   OptSpec         - NINST x 1 cell array of strings 'call' or 'put'.
%   Strike          - NINST x 1  matrix of strike price values. Each row
%                     is the schedule for one option. To calculate the value of a
%                     Floating Strike asian option, strike should be specified 
%                     as NaN.
%   Settle          - NINSTx1 matrix of settlement or trade date.
%   ExerciseDates   - For an European Option:
%                     NINST x 1 matrix of exercise dates. Each row is the 
%                     schedule for one option. For an European option,there 
%                     is only one ExerciseDate on the option expiry date.
%                     
%                     For an American Option:
%                     NINST x 2 vector of exercise date boundaries. For each
%                     instrument, the option can be exercised on any tree date 
%                     between or including the pair of dates on that row. If only 
%                     one non-Nan date is listed, or if ExerciseDates is NINST x 1, 
%                     the option can be exercised between the ValuationDate of the 
%                     stock tree and the single listed ExerciseDate.
%
% Optional Inputs:
%
%   AmericanOpt     - NINST x 1 flags 0(European) or 1(American).Default is 0. 
%   AvgType         - String. Average type must be either "arithmetic" for
%                     arithmetic average, or "geometric" for geometric 
%                     average. Default is "arithmetic".
%   AvgPrice        - Scalar representing the average price of the
%                     underlying asset at Settle. This argument is used
%                     when AvgDate < Settle. 
%   AvgDate         - Scalar representing the date on which the averaging
%                     period begins. 
%
% Outputs:
%   Price           - NINSTx1 expected prices at time 0.
%
% Notes: The Settle date for every asian is set to the ValuationDate of
%        the stock Tree. The asian argument, Settle, is ignored.
%
%        ASIANBYCRR calculates values of Fixed and  Floating Strike 
%        asian options. To compute the value of a Floating Strike asian
%        option, strike should be specified as NaN. Fixed Strike asian
%        options are also known as Average Price options. Floating Strike asian
%        options are also known as Average Strike options.
%
%        Pricing of Asian options is done using Hull-White (1993).
%        Consequently, for these options there are no unique prices on the 
%        tree nodes with the exception of the root node. 
%
%
% See also CRRTREE,INSTASIAN.
%
% Reference: J. Hull and A. White. Efficient procedures for valuing
%            European and American path-dependent options.Journal of 
%            Derivatives,Vol1,pp 21-31.

%   Author(s): M. Reyes-Kattar 01-Nov-2002
%   Copyright 1998-2003 The MathWorks, Inc. 
%   $Revision: 1.1.6.1 $  $Date: 2003/08/29 04:46:03 $

%----------------------------------------------------------------
% Checking input arguments
%----------------------------------------------------------------

if nargin<5 
    str1 = 'The function asianbycrr requires five input arguments:';
    str2 = 'CRRTree, OptSpec, Strike, Settle and ExerciseDates';
    msg = sprintf('%s\n%s', str1, str2);
    error('finderiv:asianbycrr:InvalidInputs',msg)
end
    

if ~isafin(BinStockTree, 'BinStockTree') | ~strcmpi(BinStockTree.Method, 'CRR')
    error('finderiv:asianbycrr:InvalidTree','CRRTree must be a Binary Stock Tree created with CRRTREE')
end

[Price] = asianbybintree(BinStockTree, varargin{:});
