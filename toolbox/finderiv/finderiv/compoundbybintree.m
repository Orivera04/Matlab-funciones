function [Price, PriceTree] = compoundbybintree(BinStockTree, varargin) 
%COMPOUNDBYBINTREE Engine function for compoundbycrr and compoundbyeqp.
%
%   This is a private function that is not meant to be called directly
%   by the user.

%   Author(s): M. Reyes-Kattar 01-Nov-2002
%   Copyright 1998-2003 The MathWorks, Inc. 
%   $Revision: 1.1.6.2 $  $Date: 2003/08/31 19:44:28 $

% -------------------------------------------------------------
% Process Input arguments
% -------------------------------------------------------------

% First, process the underlying option
[UOptSpec,UStrike,USettle,UExerciseDates,UAmericanOpt] = instargoptstock(varargin{1:5});
if(size(UAmericanOpt,1) ~= 1)
    error('finderiv:compoundbybintree:InvalidUnderlyingSecurity','Only one option can be specified as the underlying security.')
end

% Now process the compounded option
[COptSpec,CStrike,CSettle, CExerciseDates,CAmericanOpt] = instargoptstock(varargin{6:end});

% -------------------------------------------------------------
% Make sure that all compounds mature **before** the underlying 
% does
% -------------------------------------------------------------

% Find the last exercise date for each instrument:
NumInst = size(CAmericanOpt,1);
[dummy,   NDperRow] = finargpack(1, CExerciseDates);
CMaturity = CExerciseDates(sub2ind(size(CExerciseDates), ...
        (1:NumInst)', NDperRow));

if any(CMaturity > UExerciseDates(end))
    str1 = 'All Compound maturities must be less or equal to the ';
    str2 = 'underlying option''s maturity';
    msg = sprintf('%s\n%s', str1, str2);
    error('finderiv:compoundbybintree:InvalidCompoundMaturity',msg)
end
% --------------------------------------------------------------

% -------------------------------------------------------------
% If the stock tree has dividend payments AND is longer than the maturity
% of the option, we will have to recompute the tree to take out any
% dividend payments occurring after option maturity. This is typically done
% in procoption. Make sure it's only done here if necessary.
if(~isempty(BinStockTree.StockSpec.DividendType) & (BinStockTree.dObs(end) > UExerciseDates(end)))
    try
        [DummyNumInst, DummyInstPut, DummyInstCall, DummyNumPut, DummyNumCall, DummyAllStrike, BinStockTree] = ...
            procoptions(BinStockTree, UOptSpec,UStrike,USettle,UExerciseDates,UAmericanOpt);
    catch
        msg=sprintf('Error while processing underlying option:\n\t%s', lasterr);
        error('finderiv:compoundbybintree:InvalidUnderlyingOption',msg);
    end
end
% -------------------------------------------------------------

% Find the price tree for the underlying option
try
    [P, UPriceTree] = optstockbybintree(BinStockTree, varargin{1:5});
catch
    msg=sprintf('Error while processing underlying option:\n\t%s', lasterr);
    error('finderiv:compoundbybintree:InvalidUnderlyingOption',msg);
end


% Take the price tree of the underlying option and use it as the stock
% price tree. Make sure it is treated as if there are no dividends:
FakeStockTree = BinStockTree;
FakeStockTree.STree = UPriceTree.PTree;
FakeStockTree.StockSpec = stockspec(BinStockTree.StockSpec.Sigma, BinStockTree.StockSpec.Sigma);

% Find the price tree for the compound option
try
    [Price, PriceTree] = optstockbybintree(FakeStockTree, varargin{6:end});
catch
    msg=sprintf('Error while processing compound option:\n\t%s', lasterr);
    error('finderiv:compoundbybintree:InvalidCompoundOption',msg);
end
