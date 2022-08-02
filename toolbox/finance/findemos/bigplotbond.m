function bigplotbond()
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%    This is private file of the BDT Demo and is not meant to be called
%    directly by the user.
%
%Author: C. Bassignani, 05-20-98 
%   Copyright 1995-2002 The MathWorks, Inc. 
%$Revision: 1.5 $   $Date: 0000/00/00 00:00:00


%Unpack the zero curve from the global variable
global GIBOND;

IBond = GIBOND;

if(~isempty(IBond))
     
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
BondAxesHandle = findobj('Tag', 'AxesViewBond');

axes(BondAxesHandle);

cfplot(CFDates, CFlowAmounts);


dtaxis('x', 2);


set(gca, 'XLim', [(min(CFDates) - 90) (max(CFDates) + 90)]);

xlabel('Cash Flow Date');

ylabel('Cash Flow Magnitude');

set(gca, 'Tag', 'AxesBond');

end


