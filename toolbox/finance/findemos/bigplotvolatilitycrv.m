function bigplotvolatilitycrv()
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%    This is private file of the BDT Demo and is not meant to be called
%    directly by the user.
%
%Author: C. Bassignani, 05-20-98 
%   Copyright 1995-2002 The MathWorks, Inc. 
%$Revision: 1.5 $   $Date: 0000/00/00 00:00:00


%Unpack the zero curve from the global variable
global GVOLATILITYCURVE;

VolatilityCurve = GVOLATILITYCURVE;

%If the zero curve is not empty, plot it in the axes of the current figure
%window
if (~isempty(VolatilityCurve))
     
     VolatilityCurveAxesHandle = findobj('Tag', 'AxesViewVolatilityCrv');                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           
     
     axes(VolatilityCurveAxesHandle);                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       
     
     CurveDates = VolatilityCurve.CurveDates;                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               
     VolatilityRates = VolatilityCurve.VolatilityRates;                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  
     
     plot(CurveDates, VolatilityRates);
     
     dateaxis;
     
     plotscale(0.10);
     
     set(gca, 'YLim', [0 (max(VolatilityRates) + 0.03)]);
     
     xlabel('Maturity Date');
     ylabel('Volatility Rate');
     
end


