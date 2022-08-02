function Price= lookbackbyeqp(BinStockTree, varargin)
%LOOKBACKBYEQP Price lookback options by an EQP binomial tree.
%
%   Price  = lookbackbyeqp(EQPTree, OptSpec, Strike, Settle, ...
%                                      ExerciseDates)
%
%   Price  = lookbackbyeqp(EQPTree, OptSpec, Strike, Settle, ...
%                                      ExerciseDates, AmericanOpt)
%
% Inputs: Type "help instlookback" for a description of lookback contract arguments.   
%
%   EQPTree         - Stock tree structure created by EQPTREE.
%   OptSpec         - NINSTx1 cell array of strings 'call' or 'put'.
%   Strike          - NINST x 1  matrix of strike price values. Each row
%                     is the schedule for one option. To calculate the value of a
%                     Floating Strike lookback option, strike should be specified 
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
%
% Outputs:
%   Price           - NINSTx1 expected prices at time 0.
%
% Notes: The Settle date for every lookback is set to the ValuationDate of
%        the stock Tree. The lookback argument, Settle, is ignored. 
%
%        LOOKBACKBYEQP calculates values of Fixed and  Floating Strike 
%        lookback options. To compute the value of a Floating Strike lookback
%        option, strike should be specified as NaN.
%
%        Pricing of lookback options is done using Hull-White (1993).
%        Consequently, for these options there are no unique prices on the 
%        tree nodes with the exception of the root node. 
%
%
% See also EQPTREE,INSTLOOKBACK.
%
% Reference: J. Hull and A. White, "Efficient Procedures for Valuing
%            European and American Path-Dependent Options,", Journal of
%            Derivatives, Fall 1993,21-31.

%   Author(s): M. Reyes-Kattar 01-Nov-2002
%   Copyright 1998-2003 The MathWorks, Inc. 
%   $Revision: 1.1.6.1 $  $Date: 2003/08/29 04:46:41 $

%----------------------------------------------------------------
% Checking input arguments
%----------------------------------------------------------------

if nargin<5 
    str1 = 'The function lookbackbyeqp requires five input arguments:';
    str2 = 'EQPTree, OptSpec, Strike, Settle and ExerciseDates.';
    msg = sprintf('%s\n%s', str1, str2);
    error('finderiv:lookbackbyeqp:InvalidInputs',msg)
end
    
%Checking input arguments.
if ~isafin(BinStockTree, 'BinStockTree') | ~strcmpi(BinStockTree.Method, 'EQP')
    error('finderiv:lookbackbyeqp:InvalidTree','EQPTree must be a Binary Stock Tree created with EQPTREE')
end

Price = lookbackbybintree(BinStockTree, varargin{:});
