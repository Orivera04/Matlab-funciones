function SRates = findswaprates(RateSpec, FloatPrice, Settle, FixedPrincipal, ...
   							FixedMaturity, FixedResets, FixedBasis)
% FINDSWAPRATES Find the coupon rate based on a given coupon bond price.
% This function is called by swapbyzero, swapbyhjm, and swapbybdt.
%
%   This is a private function that is not meant to be called directly
%   by the user.

%   Author(s): M. Reyes-Kattar 07/27/2001
%   Copyright 1998-2002 The MathWorks, Inc. 
%   $Revision: 1.3 $   $  $Date: 2002/04/14 21:41:29 $		

                     
NumInst = size(FloatPrice,1); 
                     
% Find CFDates:
[FixedCFA, CFlowDates, Tpds] = cfamounts(1, Settle, FixedMaturity, ...
   FixedResets, FixedBasis);

% Place all instruments in a common time line
[CFBondDate, AllDates, AllT] = cfport(FixedCFA, CFlowDates, Tpds);

% Find discounts from AllDates to Settle:
RateSpec = intenvset(RateSpec, 'StartDates', Settle(1), 'EndDates',  AllDates);
Disc = intenvget(RateSpec, 'Disc')'; % NCurves x NPoints
NumCurves = size(Disc,1);

% Repeat the Disc rows as many times as instruments we have:
Disc = duplicaterows(Disc, NumInst);

% Repeat the Ppals as many times as curves we have:
FixedPrincipal = repmat(FixedPrincipal(:), NumCurves, 1);

% Find Masks for all cash flows:
CFBondDate = repmat(CFBondDate, NumCurves,1);
CFMask = (CFBondDate ~= 0);
CFMask(:,1) = logical(0); % No accrued interests

% Find location of Maturity in AllDates vector
[MatInd, IOrder] = findsub(AllDates, FixedMaturity);
MatInd = MatInd(IOrder);
PIndex = sub2ind(size(CFBondDate),(1:NumCurves*length(MatInd))',repmat(MatInd, NumCurves, 1));

% Pull out the discount applicable to the payment of the ppal
% and multiply it by the appropriate ppal
DiscPpal = Disc(PIndex) .* FixedPrincipal;
DiscPpal = reshape(DiscPpal, NumInst, NumCurves);

% Find all cash flows and mask out non-cf dates
DiscSum = sum((Disc .* repmat(FixedPrincipal, 1, size(Disc,2))) .* CFMask, 2);

% Rearrange the results into NumInst x NumCurves;
DiscSum = reshape(DiscSum, NumInst, NumCurves);

% Calculate Swap Rates
SRates = ((FloatPrice - DiscPpal) ./ DiscSum) .* repmat(FixedResets, 1, NumCurves);

return

%------------------------------------------
% DUPLICATEROWS:
%	duplicate N-times each row of input array Array.
%
%  Inputs:
%  	InArray: input array to be expanded
% 		    	N: number of times each row should
%            	be duplicated.
% ------------------------------------------
function OutArray = duplicaterows(InArray, N)

[NRows, NCols] = size(InArray);

Indexes = ((1:(NRows*NCols))' * ones(1, N))';
Indexes = reshape(Indexes, N*NRows, NCols);
OutArray = InArray(Indexes);
return

% -----------------------------------------
% FINDSUB:
% Find the indices within All where the
% elements of Sub are found. IOrder keeps
% the order in which they appear:
% Ind(IOrder) = Sub when all elements of Sub
% can be found in All
function [Ind, IOrder] = findsub(All, Sub)

lengthAll  = length(All);
lengthSub = length(Sub);
IMask = (repmat(All(:)', lengthSub,1)== repmat(Sub(:), 1, lengthAll));
[I, Ind] = find(IMask);
[dummy, IOrder] = sort(I);
return