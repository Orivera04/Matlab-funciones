function getbondguicall()
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%    This is private file of the BDT Demo and is not meant to be called
%    directly by the user.
%
%Author: C. Bassignani, 05-20-98 
%   Copyright 1995-2002 The MathWorks, Inc. 
%$Revision: 1.5 $   $Date: 0000/00/00 00:00:00

global GBONDSPECFLAG;
global GIBOND;

%Load the bond from disk
IBond = ldoptionbond;                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                

GIBOND = IBond;                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      

if (~isempty(IBond))

%Unpack the bond structure for plotting
Settle = IBond.Settle;
Maturity = IBond.Maturity;
Period = IBond.Period;
Basis = IBond.Basis;
EndMonthRule = IBond.EndMonthRule;
IssueDate = IBond.IssueDate;
FirstCouponDate = IBond.FirstCouponDate;
LastCouponDate = IBond.LastCouponDate;

CouponRate = IBond.CouponRate;

[CFlowAmounts, CFDates] = cfamounts(CouponRate, Settle, Maturity,...
     Period, Basis, EndMonthRule, IssueDate, FirstCouponDate, LastCouponDate);


%Get the handle of the axes for plotting the bond
BondAxesHandle = findobj('Tag', 'AxesBond');

axes(BondAxesHandle);

cfplot(CFDates, CFlowAmounts);

plotscale(0.20);

set(gca, 'XTick', []);                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           
set(gca, 'YTick', []);                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           


set(gca, 'Tag', 'AxesBond');

GBONDSPECFLAG = 1;

end





