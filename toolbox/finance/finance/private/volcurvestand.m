function [ChkCurve, DefCurve] = volcurvestand()
%VOLCURVESTAND Volatility Curve Structure Defaults/Argument Checking Values
%
%     This is a private function that is not meant to be called directly
%     by the user.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Author(s): C. Bassignani, 04-18-98 
%   Copyright 1995-2002 The MathWorks, Inc. 
%$Revision: 1.6 $   $Date: 2002/04/14 21:52:21 $ 


%Assign all acceptable color values to the ChkTree structure
ChkCurve.VolatilityRates = [-inf 0 inf];
ChkCurve.CurveDates = [];
ChkCurve.TimeFactors = [-inf 0 inf];
ChkCurve.Compounding = [-1 0 1 2 3 4 6 12];
ChkCurve.Basis = [0 1 2 3];
ChkCurve.EndMonthRule = [0 1];


%Assian all default color values to the DefTree structure
DefCurve.VolatilityRates = [];
DefCurve.CurveDates = [];
DefCurve.TimeFactors = [];
DefCurve.Compounding = [2];
DefCurve.Basis = [0];
DefCurve.EndMonthRule = [1];

%end of VOLCURVESTAND function



