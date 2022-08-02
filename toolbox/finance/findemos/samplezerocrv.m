function samplezerocrv()
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%    This is private file of the BDT Demo and is not meant to be called
%    directly by the user.
%
%Author: C. Bassignani, 05-20-98 
%   Copyright 1995-2002 The MathWorks, Inc. 
%$Revision: 1.4 $   $Date: 0000/00/00 00:00:00

%Generate a fitted zero curve
load treasurydata;
[ZeroRates, CurveDates] = termfit(0.5, Bonds, Prices, MSettle);
%ZeroRates = 0.05*ones(size(CurveDates));


%Build the zero curve structure
ZeroCurve.ZeroRates = ZeroRates;
ZeroCurve.CurveDates = CurveDates;
ZeroCurve.Compounding = 2;
ZeroCurve.Basis = 0;
ZeroCurve.EndMonthRule = 1;


%Write curve out to disk
save d:\v5\toolbox\finance\findemos\bdtdemo\samplezerocrv ZeroCurve;
