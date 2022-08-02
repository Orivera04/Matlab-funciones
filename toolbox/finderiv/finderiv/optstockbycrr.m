function [Price, PriceTree] = optstockbycrr(BinStockTree, varargin)
%OPTSTOCKBYCRR Price options on stocks by a CRR binomial tree.
%
%   [Price,PriceTree] = optstockbycrr(CRRTree, OptSpec, Strike, Settle,...
%                                     ExerciseDates)
%
%   [Price,PriceTree] = optstockbycrr(CRRTree, OptSpec, Strike, Settle,...
%                                     ExerciseDates, AmericanOpt)
%
% Inputs: Type "help instoptstock" for a description of option contract
%         arguments.   
%
%   CRRTree         - Stock tree structure created by CRRTREE.
%   OptSpec         - NINSTx1 cell array of strings 'call' or 'put'.
%   Strike          - For an European or Bermuda Option:
%                     NINST x 1 (European) or NINST x NSTRIKES(Bermuda) matrix 
%                     of strike price values. Each row is the schedule for one 
%                     option. If an option has fewer than NSTRIKES exercise 
%                     opportunities, the end of the row is padded with NaN's.
%  
%                     For an American Option:
%                     NINST x 1 vector of strike price values for each option.
%   Settle          - NINST x 1 matrix of settlement or trade date.
%
%   ExerciseDates   - For an European or Bermuda Option:
%                     NINST x 1 (European) or NINST x NSTRIKES(Bermuda) matrix of
%                     exercise dates.  Each row is the schedule for one option.For an 
%                     European option,there is only one ExerciseDate on the option 
%                     expiry date.
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
%   AmericanOpt     - NINST x 1 flags 0(European/Bermuda) or
%                     1(American). Default is 0.
%
% Outputs:
%   Price     - NINSTx1 expected prices at time 0.
%   PriceTree - Tree structure with a vector of instrument prices at each
%               node. 
%
% Notes: The Settle date for every option is set to the ValuationDate of
%        the stock Tree. The option argument, Settle, is ignored. 
%
% See also CRRTREE,INSTOPTSTOCK.

%   Author(s): M. Reyes-Kattar 01-Nov-2002
%   Copyright 1998-2003 The MathWorks, Inc. 
%   $Revision: 1.1.6.1 $  $Date: 2003/08/29 04:46:47 $

%----------------------------------------------------------------
% Checking input arguments
%----------------------------------------------------------------
if nargin<4 
    str1 = 'The function optstockbycrr requires five input arguments:';
    str2 = 'CRRTree, OptSpec, Strike, Settle and ExerciseDates';
    msg = sprintf('%s\n%s', str1, str2);
    error('finderiv:optstockbycrr:InvalidInputs',msg)
end
    
%Checking input arguments.
if ~isafin(BinStockTree, 'BinStockTree') | ~strcmpi(BinStockTree.Method, 'CRR')
    error('finderiv:optstockbycrr:InvalidTree','CRRTree must be a Binary Stock Tree created with CRRTREE')
end

[Price, PriceTree] = optstockbybintree(BinStockTree, varargin{:});
