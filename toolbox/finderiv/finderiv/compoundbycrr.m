function [Price, PriceTree] = compoundbycrr(BinStockTree, varargin)
%COMPOUNDBYCRR Price compound options by a CRR binomial tree.
%
%   [Price,PriceTree] = compoundbycrr(CRRTree, UOptSpec, UStrike, USettle, ...
%                                     UExerciseDates,UAmericanOpt,COptSpec,...
%                                     CStrike, CSettle, CExerciseDates)
%
%   [Price,PriceTree] = compoundbycrr(CRRTree, UOptSpec, UStrike, USettle, ...
%                                     UExerciseDates,UAmericanOpt,COptSpec,...
%                                     CStrike, CSettle, CExerciseDates,CAmericanOpt)
%
% Inputs: Type "help instcompound" for a description of the compound contract 
%         arguments.   
%
%   CRRTree         - Stock tree structure created by CRRTREE.
%   UOptSpec        - String 'call' or 'put' of the underlying option.                     
%   UStrike         - 1 X 1 vector of the underlying strike price.
%   USettle         - 1 X 1 vector of the settlement date or trade date.
%   UExerciseDates  - For an European Option:
%                     1 X 1 vector of the underlying exercise date. For an 
%                     European option,there is only one ExerciseDate on the 
%                     option expiry date.
%                     
%                     For an American Option:
%                     1 x 2 vector of the underlying exercise date boundaries. 
%                     The option can be exercised on any tree date. If only 
%                     one non-Nan date is listed, or if ExerciseDates is 1 x 1, 
%                     the option can be exercised between the ValuationDate of the 
%                     stock tree and the single listed ExerciseDate.
%
%   UAmericanOpt    - Flag of the underlying option: 0(European)or 1(American).
%                     
%   COptSpec        - NINSTx1 cell array of strings 'call' or 'put' 
%                     of the compound option.
%   CStrike         - For an European and American Option:
%                     NINST x 1  matrix of compound strike price values. Each row
%                     is the schedule for one option. 
%   CSettle         - 1 X 1 vector of the settlement date or trade date.
%   CExerciseDates  - For an European Option:
%                     NINST x 1 matrix of compound exercise dates. Each row is 
%                     the schedule for one option. For an European option,there 
%                     is only one ExerciseDate on the option expiry date.
%                     
%                     For an American Option:
%                     NINST x 2 vector of the compound exercise date boundaries. 
%                     For each instrument, the option can be exercised on any tree date 
%                     between or including the pair of dates on that row. If only 
%                     one non-Nan date is listed, or if ExerciseDates is NINST x 1, 
%                     the option can be exercised between the ValuationDate of the 
%                     stock tree and the single listed ExerciseDate.
%
%
% Optional Inputs:
%
%   CAmericanOpt    - NINST x 1 flags 0(European) or 1(American)
%                     of the compound option. Default is 0.
%
% Outputs:
%   Price     - NINSTx1 expected prices at time 0.
%   PriceTree - Tree structure with a vector of instrument prices at each
%               node. 
%
% Notes: The Settle date is set to the ValuationDate of the stock Tree.  
%
% See also CRRTREE,INSTCOMPOUND.
%
% Reference: Rubinstein, Mark (1991). Double Trouble, Risk 5.
%

%   Author(s): M. Reyes-Kattar 01-Nov-2002
%   Copyright 1998-2003 The MathWorks, Inc. 
%   $Revision: 1.1.6.1 $  $Date: 2003/08/29 04:46:21 $

%----------------------------------------------------------------
% Checking input arguments
%----------------------------------------------------------------

if nargin<10
    str1 = 'The function compoundbycrr requires ten input arguments:';
    str2 = ['CRRTree, UOptSpec, UStrike, USettle, UExerciseDates,UAmericanOpt, ',...
             'COptSpec, CStrike, CSettle, and CExerciseDates'];
    msg = sprintf('%s\n%s', str1, str2);
    error('finderiv:compoundbycrr:InvalidInputs',msg)
end

    
%Checking input arguments.
if ~isafin(BinStockTree, 'BinStockTree') | ~strcmpi(BinStockTree.Method, 'CRR')
    error('finderiv:compoundbycrr:InvalidTree','CRRTree must be a Binary Stock Tree created with CRRTREE.')
end

[Price, PriceTree] = compoundbybintree(BinStockTree, varargin{:});