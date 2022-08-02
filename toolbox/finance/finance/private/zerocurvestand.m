function [ChkCurve, DefCurve] = zerocurvestand()
%ZEROCURVESTAND Zero Curve Structure Defaults/Argument Checking Values
%
%     This is a private function that is not meant to be called directly
%     by the user.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Author(s): C. Bassignani, 04-18-98 
%   Copyright 1995-2002 The MathWorks, Inc. 
%$Revision: 1.5 $   $Date: 2002/04/14 21:52:24 $ 


%Assign all acceptable color values to the ChkTree structure
ChkCurve.ZeroRates = [-inf 0 inf];
ChkCurve.CurveDates = [];
ChkCurve.TimeFactors = [-inf 0 inf];
ChkCurve.Compounding = [-1 0 2 3 4 6 12 365];
ChkCurve.Basis = [0 1 2 3];
ChkCurve.EndMonthRule = [0 1];


%Assian all default color values to the DefTree structure
DefCurve.ZeroRates = [];
DefCurve.CurveDates = [];
DefCurve.TimeFactors = [];
DefCurve.Compounding = [2];
DefCurve.Basis = [0];
DefCurve.EndMonthRule = [1];

%end of ZEROCURVESTAND function



