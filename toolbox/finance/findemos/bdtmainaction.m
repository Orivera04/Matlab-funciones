function bdtmainaction(action)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%    This is private file of the BDT Demo and is not meant to be called
%    directly by the user.
%
%Author: C. Bassignani, 05-20-98 
%   Copyright 1995-2002 The MathWorks, Inc. 
% $Revision: 1.10 $   $Date: 2002/04/14 21:46:18 $

switch(action)     
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%          ************* Callbacks from main GUI **************
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
     
case 'loadzerocurve'
     
     %Load a zero curve from disk
     getzerocrvgui;
          
case 'loadvolatilitycurve'
     
     %Load a volatility curve from disk
     getvolcrvgui;     
     
case 'loadcreditcurve'
     
     %Load a credit curve from disk
     getcreditcrvgui;
     
case 'loadbond'
     
     %Get file parameters and load the bond from disk
     getbondgui;     
     
case 'specifybondparams'
     
     %Call GUI for specification of bond parameters
     specbondroutine;
          
case 'calcprice'
     
     calcpriceroutine;    
     
case 'calcyield'
     
     calcyieldroutine;
     
case 'viewzerocrv'
     
     viewzerocrvgui;
     
     
case 'viewvolatilitycrv'
     
     viewvolatilitycrvgui;
     
case 'viewcreditcrv'
     
     viewcreditcrvgui;
     
case 'viewbdttree'
     
     viewbdttreegui;
     
case 'viewbond'
     
     viewbondgui;
     
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%      ********* Callbacks from GUI for Specifying Zero Curve *********
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
     
case 'speczerocrv'
     
     bdteditzerocurvegui;
     
case 'specvolatilitycrv'
     
     bdteditvolatilitycurvegui;
     
case 'speccreditcrv'
     
     bdteditcreditcurvegui;
     
case 'adjustres'
  
     bdtadjustresolution
     
otherwise
     
     return
     
end

%end of BDTMAINACTION function


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%            ************* CALLBACK SUBROUTINES **************
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function calcpriceroutine()

%Declare all global variables
global GZEROCURVE;
global GCREDITCURVE;
global GVOLATILITYCURVE;
global GIBOND;
global GDURATIONFLAG;
global GCONVEXITYFLAG;
global GVEGAFLAG;
global GACCURACY;
global GPRICE;
global GTREE;
global GCALCPRICEFLAG;

if (~isempty(GZEROCURVE) & ~isempty(GCREDITCURVE) &...
          ~isempty(GVOLATILITYCURVE) & ~isempty(GIBOND) &...
          ~isempty(GDURATIONFLAG) & ~isempty(GCONVEXITYFLAG) &...
          ~isempty(GVEGAFLAG) & ~isempty(GACCURACY))
         
     %Prepare input arguments to be passed to BDTBOND function
     SensitivityMeasures = [GDURATIONFLAG GCONVEXITYFLAG GVEGAFLAG];
     ZeroCurve = GZEROCURVE;
     CreditCurve = GCREDITCURVE;
     VolatilityCurve = GVOLATILITYCURVE;
     IBond = GIBOND;
     Accuracy = GACCURACY;
     
     %Get the handle of the message window in the main GUI
     EditErrorHandle = findobj(gcf, 'Tag', 'EditErrorMessage'); 
     
     %Set the error flag initially to zero
     ErrorFlag = 0;    
     
     % set the output variables initially to empty
     Price = [];
     Sensitivities = [];
     DiscTree = [];
     PriceTree = [];
     
     %Build all command strings
     CalculateString = 'set(EditErrorHandle, ''String'', ''Calculating Price....''); ';
     DrawNowString = 'drawnow; ';
     PointerChangeString = 'set(gcf, ''Pointer'', ''watch''); ';
     
     BaseString = ['[Price, Sensitivities, DiscTree, PriceTree]',...
               ' =  bdtbond(IBond, ZeroCurve, VolatilityCurve, ',...
               'Accuracy, CreditCurve, SensitivityMeasures);']; 
         
     
     DoneString = 'set(EditErrorHandle, ''String'', ''Done!''); ';          
     PointerChangeBackString = 'set(gcf, ''Pointer'', ''arrow'');';         
     
     CommandString = strcat(CalculateString, DrawNowString, ...
          PointerChangeString, BaseString);
     
     %Build error string and error catch command string
     ErrorString = 'Invalid bond or model parameters';     
     CommandErrorString = strcat(['set(EditErrorHandle,''String'', ErrorString); ErrorFlag = 1;set(gcf,''Pointer'',''arrow'');']) ;  
     
     %Try the calculation and catch any er
     eval(CommandString, CommandErrorString);                                
     % eval(CommandString)
     
     global GDISCTREE;
     
     GDISCTREE = DiscTree;
     
     if (~ErrorFlag & ~isempty(DiscTree))
          
          format short;
          
          %Get the handles for writing the output back to the GUI
          OptionFreePriceHandle = findobj(gcf, 'Tag', 'EditOptionFreePrice');
          OptionEmbedPriceHandle = findobj(gcf, 'Tag', 'EditOptionEmbedPrice');
          DurationHandle = findobj(gcf, 'Tag', 'EditDuration');             
          EffDurationHandle = findobj(gcf, 'Tag', 'EditEffDuration');       
          ConvexityHandle = findobj(gcf, 'Tag', 'EditConvexity');           
          EffConvexityHandle = findobj(gcf, 'Tag', 'EditEffConvexity');     
          VegaHandle = findobj(gcf, 'Tag', 'EditVega');                     
          set(OptionFreePriceHandle, 'String', Price.OptionFreePrice);      
          set(OptionEmbedPriceHandle, 'String', Price.OptionEmbedPrice);    
          set(DurationHandle, 'String', Sensitivities.Duration);            
          set(EffDurationHandle, 'String', Sensitivities.EffDuration);
          set(ConvexityHandle, 'String', Sensitivities.Convexity);  
          set(EffConvexityHandle, 'String', Sensitivities.EffConvexity);
          set(VegaHandle, 'String', Sensitivities.Vega);   
          
          %Plot the tree if it is valid
          if (DiscTree.ErrorFlag == 0)               
               TreeAxesHandle = findobj('Tag', 'AxesTree');
               axes(TreeAxesHandle);
               bdttrans(DiscTree);                         
               plotscale(0.10);
               set(gca, 'Tag', 'AxesTree');
               set(gca, 'XTick', []); 
               set(gca, 'YTick', []); 
          end
          
     CleanupString = strcat(DoneString, DrawNowString, ...
          PointerChangeBackString);     
          
     eval(CleanupString);
     format;
     
     end

     GPRICE = Price;
     
     GCALCPRICEFLAG = 1;     
end

%end of CALCPRICEROUTINE subroutine


function calcyieldroutine()

global GIBOND;
global GPRICE;
global GCALCPRICEFLAG;

IBond = GIBOND;
Price = GPRICE;


if (~isempty(IBond) & ~isempty(Price) & GCALCPRICEFLAG)
     
     OptionFreePrice = Price.OptionFreePrice;
     OptionEmbedPrice = Price.OptionEmbedPrice;
     CouponRate = IBond.CouponRate;
     Settle = IBond.Settle;
     Maturity = IBond.Maturity;
     Period = IBond.Period;
     Basis = IBond.Basis;
     EndMonthRule = IBond.EndMonthRule;
     IssueDate = IBond.IssueDate;
     FirstCouponDate = IBond.FirstCouponDate;
     LastCouponDate = IBond.LastCouponDate;
     StartDate = IBond.StartDate;
     Face = IBond.Face;
     
     EditErrorHandle = findobj(gcf, 'Tag', 'EditErrorMessage');          
     %Clear the error message window
     set(EditErrorHandle, 'String', '');
     drawnow;
     
     YieldErrorFlag = 0;
     
     CalculatingString = 'set(EditErrorHandle, ''String'', ''Calculating Yield....''); ';
         
     PointerChangeString = 'set(gcf, ''Pointer'', ''watch''); ';
     PointerChangeBackString = 'set(gcf, ''Pointer'', ''arrow'');';
     
     DoneString = 'set(EditErrorHandle, ''String'', ''Done!'');, ';      
     CleanupString = strcat(DoneString, PointerChangeBackString, 'drawnow;');
     
     NoOptYieldCalcString = strcat(['Yield = bndyield(OptionFreePrice, '...
          'CouponRate, Settle, Maturity, Period, Basis, '...
          'EndMonthRule, IssueDate, FirstCouponDate, '...
          'LastCouponDate, StartDate, Face); ']);

     OptYieldCalcString = strcat(['EffYield = bndyield(OptionEmbedPrice, '...
          'CouponRate, Settle, Maturity, Period, Basis, '...
          'EndMonthRule, IssueDate, FirstCouponDate, '...
          'LastCouponDate, StartDate, Face); ']);

     OASpreadCalcString = 'OASpread = EffYield - Yield; ';

YieldCommandString = strcat(CalculatingString, PointerChangeString, ...
     'drawnow; ', NoOptYieldCalcString, OptYieldCalcString, ...
     OASpreadCalcString);

     YieldErrorMessage = 'Unable to calculate yield!';
     YieldErrorString = strcat(['set(EditErrorHandle, ''String'', '...
          'YieldErrorMessage); YieldErrorFlag = 1;set(gcf,''Pointer'',''arrow'');']);

     eval(YieldCommandString, YieldErrorString);

     if (~YieldErrorFlag)
     
          format bank;          
          
          %Get the handles for writing the output back to the GUI
          YieldHandle = findobj(gcf, 'Tag', 'EditYield');           
          EffYieldHandle = findobj(gcf, 'Tag', 'EditEffYield');     
          OASpreadHandle = findobj(gcf, 'Tag', 'EditOASpread');     
          set(YieldHandle, 'String', Yield);                        
          set(EffYieldHandle, 'String', EffYield);                  
          set(OASpreadHandle, 'String', OASpread);
          
          eval(CleanupString);
          format;
     end
     
     
else
     
     EditErrorHandle = findobj(gcf, 'Tag', 'EditErrorMessage');
     set(EditErrorHandle, 'String', 'Price not calculated!');
     drawnow;
end



%end of CALCYIELDROUTINE subroutine


function specbondroutine()

     
global GIBOND;
     
IBond = GIBOND;

if (isempty(IBond))
     bondspecgui;
else
     bondspecgui(IBond);
end


function bdtadjustresolution(Figure, defPixelPerInch)
% place uicontrols correctly on some unix systems

if nargin<2,
  defPixelPerInch = 96;
end

if nargin<1,
  Figure = gcf;
end

actPixelPerInch = get(0,'ScreenPixelsPerInch');

if (actPixelPerInch==defPixelPerInch)
  return
else
  Scale = defPixelPerInch/actPixelPerInch;
end

hList = get(Figure, 'children');

for i=1:length(hList),
  Units = get(hList(i), 'Units');

  switch Units
    case 'points'
      Pos = Scale*get(hList(i), 'Position');
      set(hList(i), 'Position', Pos);
      
  end
end




