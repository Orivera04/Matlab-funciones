function sampleoptionbond()
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%    This is private file of the BDT Demo and is not meant to be called
%    directly by the user.
%
%Author: C. Bassignani, 05-20-98 
%   Copyright 1995-2002 The MathWorks, Inc. 
%$Revision: 1.4 $   $Date: 0000/00/00 00:00:00

%Build the bond structure
IBond.IssueDate = [];
IBond.Settle = datenum('11-Mar-1997');
IBond.Maturity = datenum('10-Sep-2003');
IBond.CouponRate = 0.05;
IBond.Period = 2;
IBond.Face =100;
IBond.Basis = 0;
IBond.EndMonthRule = 1;

IBond.CallType = 1;
IBond.CallStartDate = [datenum('10-Sep-1997')]';
IBond.CallExpiryDate = [datenum('10-Sep-1998')]';
IBond.CallStrike = 100;

IBond.PutType = [];
IBond.PutStartDate = [];
IBond.PutExpiryDate = [];
IBond.PutStrike = [];


%Write the bond out to disk
save d:\v5\toolbox\finance\findemos\bdtdemo\sampleoptionbond IBond;
