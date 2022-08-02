function bigplotcreditcrv()
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%    This is private file of the BDT Demo and is not meant to be called
%    directly by the user.
%
%Author: C. Bassignani, 05-20-98 
%   Copyright 1995-2002 The MathWorks, Inc. 
%$Revision: 1.5 $   $Date: 0000/00/00 00:00:00


%Unpack the zero curve from the global variable
global GCREDITCURVE;

CreditCurve = GCREDITCURVE;

%If the zero curve is not empty, plot it in the axes of the current figure
%window
if (~isempty(CreditCurve))
     
     CreditCurveAxesHandle = findobj('Tag', 'AxesViewCreditCrv');                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           
     
     axes(CreditCurveAxesHandle);                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       
     
     CurveDates = CreditCurve.CurveDates;                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               
     CreditRates = CreditCurve.CreditRates;                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  
     
     plot(CurveDates, CreditRates);
     
     dateaxis;
     
     plotscale(0.10);
     
     set(gca, 'YLim', [0 (max(CreditRates) + 300)]);
          
     xlabel('Maturity Date');
     ylabel('Credit Spread');
     
end


