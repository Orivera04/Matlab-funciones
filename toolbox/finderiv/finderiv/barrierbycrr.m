function [Price, PriceTree] = barrierbycrr(BinStockTree, varargin)
%BARRIERBYCRR Price barrier options by a CRR binomial tree.
%
%   [Price, PriceTree] = barrierbycrr(CRRTree, OptSpec, Strike, Settle, ExerciseDates,...
%                            AmericanOpt, BarrierSpec, Barrier)
%
%   [Price, PriceTree] = barrierbycrr(CRRTree, OptSpec, Strike, Settle, ExerciseDates,...
%                            AmericanOpt, BarrierSpec, Barrier, Rebate, Options)
%
% Inputs: Type "help instbarrier" for a description of barrier contract arguments.   
%
%   CRRTree         - Stock tree structure created by CRRTREE.
%   OptSpec         - NINSTx1 cell array of strings 'call' or 'put'.
%   Strike          - For an European and American Option:
%                     NINST x 1  matrix of strike price values. Each row
%                     is the schedule for one option. 
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
%   AmericanOpt     - NINST x 1 flags 0(European) or
%                     1(American). 
%
%   BarrierSpec     - NINST x 1 cell array of strings values: 
%                       'UI' for Up Knock In
%                       'UO' for Up Knock Out
%                       'DI' for Down Knock In
%                       'DO' for Down Knock Out
%
%   Barrier         - NINST x 1 matrix of barrier levels.
%
% Optional Inputs:
%
%   Rebate          - NINST x 1 matrix of rebate values. Default is 0. 
%                     For Knock In options the Rebate is paid at expiry.  
%                     For Knock Out options the Rebate is paid when the barrier is hit.
%
%   Options			- Structure created with derivset, containing derivatives 
%                     pricing options. Type "help derivset" for more information.
%
% Outputs:
%   Price     - NINSTx1 expected prices at time 0.
%   PriceTree - Tree structure with a vector of instrument prices at each
%               node. 
%
% Notes: The Settle date for every barrier is set to the ValuationDate of
%        the stock Tree. The barrier argument, Settle, is ignored. 
%
% See also CRRTREE,INSTBARRIER.
%
% Reference: Derman, Kani, Ergener, and Bardhan (1995)

%   Author(s): M. Reyes-Kattar 01-Nov-2002
%   Copyright 1998-2003 The MathWorks, Inc. 
%   $Revision: 1.1.6.2 $  $Date: 2003/09/22 19:13:56 $

%----------------------------------------------------------------
% Checking input arguments
%----------------------------------------------------------------

if nargin<8 
    str1 = 'The function barrierbycrr requires eight input arguments:';
    str2 = 'CRRTree, OptSpec, Strike, Settle, ExerciseDates, AmericanOpt, BarrierSpec, and Barrier';
    msg = sprintf('%s\n%s', str1, str2);
    error('finderiv:barrierbycrr:InvalidInputs',msg)
end
    

if ~isafin(BinStockTree, 'BinStockTree') | ~strcmpi(BinStockTree.Method, 'CRR')
    error('finderiv:barrierbycrr:InvalidTree','CRRTree must be a Binary Stock Tree created with CRRTREE')
end

[Price, PriceTree] = barrierbybintree(BinStockTree, varargin{:});
