function Output = oneoptfn(action, Input2)
%ONEOPTFN Switchyard function for the one option GUI ONEOPT.
%
% Output = oneoptfn(action, Input2)
%


% Created by Greg Portmann (May 1997)

%       Copyright 1995-2002 The MathWorks, Inc. 
%       $Revision: 1.10 $   $Date: 2002/04/14 21:45:46 $ 

% Calls:  
% Called by: oneopt, axisfn


if nargin < 2
   Input2 = [];
end

Output = [];

switch(action)
   
case 'Initialize'
   % Set axis size
   oneoptfn('Resize');
   
   % Setup windows
   if get(findobj(gcf,'Tag','RadioGraph'),'Value') == 1
      oneoptfn('Setup Graph');      
   else
      oneoptfn('Setup Tree');      
   end
   
   oneoptfn('PlotPortfolio');
   
   set(gcf,'Visible','on');
   
  
case 'Directions'
   Input2 = 1;
   
   Output = '';
   Output = str2mat(Output, '         EVALUATING AND PRICING CALL AND PUT OPTIONS',' ');
   Output = str2mat(Output, '                                   Black-Scholes Formula');
   Output = str2mat(Output, '                                               and');
   Output = str2mat(Output, '                                      Binomial Trees');
   Output = str2mat(Output, '   ','','');
   Output = str2mat(Output, '   INTRODUCTION');
   Output = str2mat(Output, '   This application is designed to valuate a single call or put option.');
   Output = str2mat(Output, '   Two classical valuation methods will be used--the binomial tree and the');
   Output = str2mat(Output, '   Black-Scholes formula.  The calculated option value and the hedging ');
   Output = str2mat(Output, '   parameters are graphically displayed as a function of the six variables');
   Output = str2mat(Output, '   that define the option value (asset price, riskless return, years-to-expiration,');
   Output = str2mat(Output, '   volatility, and strike price).  For the binomial method, a tree diagram');
   Output = str2mat(Output, '   can also be displayed.');
   Output = str2mat(Output, '','');
   Output = str2mat(Output, '   DIRECTIONS');
   Output = str2mat(Output, '   1. Input the 6 factors needed to evaluate a put or call option:');
   Output = str2mat(Output, '       a. Current price of the underlying asset (range = 0 to infinity)');
   Output = str2mat(Output, '       b. Annualized payout return on the underlying asset (range = 1 to infinity)');
   Output = str2mat(Output, '       c. Annualized riskless return (range = 1 to infinity)');
   Output = str2mat(Output, '       d. Years-to-expiration (range = 0 to infinity)');
   Output = str2mat(Output, '       e. Annualized volatility of the underlying asset (range = 0 to infinity)');
   Output = str2mat(Output, '       f. Strike price (range = 0 to infinity)',' ');
   Output = str2mat(Output, '   2. Select the graphing range for each variable listed above.');
   Output = str2mat(Output, '       Note: the range can be specified in percent (%) or in absolute value.',' ');
   Output = str2mat(Output, '   3. Select the option type:');
   Output = str2mat(Output, '       a. Call');
   Output = str2mat(Output, '       b. Put',' ');
   Output = str2mat(Output, '   4. Select an evaluation method:');
   Output = str2mat(Output, '       a. Black-Scholes Formula');
   Output = str2mat(Output, '       b. Binomial Tree',' ');
   Output = str2mat(Output, '   The variables displayed in the graph are determined by the equation z = f(x,y).');   
   Output = str2mat(Output, '   5. Select the dependent variable, z, for the graph.');
   Output = str2mat(Output, '       a. Value of the option');
   Output = str2mat(Output, '       b. Delta of the option');
   Output = str2mat(Output, '       c. Gamma of the option');
   Output = str2mat(Output, '       d. Theta of the option');
   Output = str2mat(Output, '       e. Vega of the option');
   Output = str2mat(Output, '       f. Rho of the option');
   Output = str2mat(Output, '       g. Omega of the option (Black-Scholes elasticity)',' ');
   Output = str2mat(Output, '   6. Select the independent variables, x and y, for the graph.');
   Output = str2mat(Output, '       a. Current price of the underlying asset');
   Output = str2mat(Output, '       b. Annualized payout return of the underlying asset');
   Output = str2mat(Output, '       c. Annualized riskless return');
   Output = str2mat(Output, '       d. Years-to-expiration');
   Output = str2mat(Output, '       e. Annualized volatility of the underlying asset');
   Output = str2mat(Output, '       f. Strike price');
   Output = str2mat(Output, '       g. None -> 2-dimensional plot',' ');
   Output = str2mat(Output, '   Inputs for the binomial tree only');
   Output = str2mat(Output, '   7. Select the graphic:');
   Output = str2mat(Output, '       a. Graph of the option value and hedge parameters (default for Black-Scholes)');
   Output = str2mat(Output, '       b. Tree diagram (Note: tree diagrams obviously do not use the graphing range inputs)',' ');
   Output = str2mat(Output, '   8. Select the option type:');
   Output = str2mat(Output, '       a. European');
   Output = str2mat(Output, '       b. American',' ');
   Output = str2mat(Output, '   9. Input the desired tree size.');
   Output = str2mat(Output, '       Note: for large tree sizes the computation time can be quite long.  Hence,');
   Output = str2mat(Output, '       it is best to adjust all the other inputs before increasing the tree size.');
   Output = str2mat(Output, '','');
   Output = str2mat(Output, '   INPUT BOUNDS AND ERROR CHECKING');
   Output = str2mat(Output, '   Three different colors are used to signify the input status of a number.');
   Output = str2mat(Output, '   1. Black -> input is OK.');
   Output = str2mat(Output, '   2. Red   -> input is not recognizable (ex., strings or NaN are not allowed).');
   Output = str2mat(Output, '   3. Blue  -> input is out-of-bounds (ex., Rate of Return < 1).');
   Output = str2mat(Output, '','');
   Output = str2mat(Output, '   THE AXIS MENU');
   Output = str2mat(Output, '   1. The axis tool is a graphic user interface for changing the axis in 1-D and');
   Output = str2mat(Output, '       2-D graphs.  For the independent variables, the axis tool will override the');
   Output = str2mat(Output, '       graphing range input.  This is useful when the desire graphing range is');
   Output = str2mat(Output, '       not symmetric about the value field.  For 3-D graphs, the horizontal and vertical');
   Output = str2mat(Output, '       elevation angles can be rotated.');
   Output = str2mat(Output, '   2. Turn the axis grid on/off');
   Output = str2mat(Output, '   ');
   Output = str2mat(Output, '   ');
    
   
case 'PlotPortfolio'
   
   % Plot a "Working ..." message 
   cla;
   grid off
   %axis off
   %plot(0,0,'w');
   %xlabel(' ');
   %ylabel(' ');
   %zlabel(' ');
   %set(gca,'XTickLabel','');
   %set(gca,'YTickLabel','');
   %set(gca,'ZTickLabel','');
   text(.5,.5,'Working  . . .','Units','Normalized','FontUnits','Points','FontSize',16,'Horizontalalignment','center');
   set(findobj(gcf,'Tag','TextTree'),'String',' ');
   drawnow
   
   % If statement for each diagram type
   if get(findobj(gcf,'Tag','RadioBLS'),'Value')==1 & get(findobj(gcf,'Tag','RadioGraph'),'Value')==1
      % Black-Scholes hedge plot
      ErrStr = plothedge(Input2, 1);        
   elseif get(findobj(gcf,'Tag','RadioBIN'),'Value')==1 & get(findobj(gcf,'Tag','RadioGraph'),'Value')==1
      % Binary tree hedge plot
      ErrStr = plothedge(Input2, 0);        
   elseif get(findobj(gcf,'Tag','RadioBIN'),'Value')==1 & get(findobj(gcf,'Tag','RadioTree'),'Value')==1
      % Binary tree plot
      ErrStr = plottree(Input2);        
   else
      ErrStr = 'Error in plotting routine.';        
   end
   
   if ~isempty(ErrStr)
      cla
      grid off
      %axis off
      plot(0,0,'w');
      xlabel(' ');
      ylabel(' ');
      set(gca,'XTickLabel','');
      set(gca,'YTickLabel','');
      set(gca,'Units','Points');
      AxisPos = get(gca,'position');
      TextFontSize = 16;
      text((AxisPos(3)/2)-3*TextFontSize,(.5*AxisPos(4)),ErrStr,'Units','Points','FontUnits','Points','FontSize',TextFontSize);
      drawnow
   end
   
   
case 'ReDrawTree'
   
   % Check for input errors
   AssetPrice = getassetprice;
   AssetReturn = getassetreturn;
   RisklessReturn = getrisklessreturn;
   Expiration = getyearstoexpiration;
   Volatility = getvolatility;
   StrikePrice = getstrikeprice;
   TreeSize = gettreesize; 
   if isnan(TreeSize) | isnan(AssetPrice) | isnan(AssetReturn) | isnan(RisklessReturn) | isnan(Expiration) | isnan(Volatility) | isnan(StrikePrice)
      ErrStr = '';
      ErrStr = str2mat(ErrStr, 'Input error.',' ');
      return
   end
   
   TreeMatrix1=get(findobj(gcf,'Tag','SliderHorizontal'),'Userdata');
   TreeMatrix2=get(findobj(gcf,'Tag','SliderVertical'),'Userdata');
   ColStart=round(get(findobj(gcf,'Tag','SliderHorizontal'),'value'));
   RowStart=round((gettreesize+1)/2 - get(findobj(gcf,'Tag','SliderVertical'),'value')+1);
   localdrawtree(TreeMatrix1, TreeMatrix2, RowStart, ColStart, gca);
   
case 'Setup Graph'
   
   % First resize
   oneoptfn('Resize');
   
   set(findobj(gcf,'Tag','PopupTree1'),'Enable','Off');
   set(findobj(gcf,'Tag','PopupTree1'),'Visible','Off');
   set(findobj(gcf,'Tag','PopupTree2'),'Enable','Off');
   set(findobj(gcf,'Tag','PopupTree2'),'Visible','Off');
   set(findobj(gcf,'Tag','TextTree'),'Visible','Off');
   
   set(findobj(gcf,'Tag','SliderHorizontal'),'Enable','Off');
   set(findobj(gcf,'Tag','SliderHorizontal'),'Visible','Off');
   set(findobj(gcf,'Tag','SliderVertical'),'Enable','Off');
   set(findobj(gcf,'Tag','SliderVertical'),'Visible','Off');
   
   set(findobj(gcf,'Tag','PopupVar1'),'Enable','On');
   set(findobj(gcf,'Tag','PopupVar1'),'Visible','On');
   set(findobj(gcf,'Tag','PopupVar2'),'Enable','On');
   set(findobj(gcf,'Tag','PopupVar2'),'Visible','On');
   set(findobj(gcf,'Tag','PopupVar3'),'Enable','On');
   set(findobj(gcf,'Tag','PopupVar3'),'Visible','On');
   set(findobj(gcf,'Tag','HedgingText1'),'Enable','On');
   set(findobj(gcf,'Tag','HedgingText1'),'Visible','On');
   set(findobj(gcf,'Tag','HedgingText2'),'Enable','On');
   set(findobj(gcf,'Tag','HedgingText2'),'Visible','On');
   set(findobj(gcf,'Tag','HedgingText3'),'Enable','On');
   set(findobj(gcf,'Tag','HedgingText3'),'Visible','On');
   
   set(findobj(gcf,'Tag','MenuAxisTool'),'Enable','On');

case 'Setup Tree'
   
   % First resize
   oneoptfn('Resize');
   
   set(findobj(gcf,'Tag','PopupTree1'),'Enable','On');
   set(findobj(gcf,'Tag','PopupTree1'),'Visible','On');
   set(findobj(gcf,'Tag','PopupTree2'),'Enable','On');
   set(findobj(gcf,'Tag','PopupTree2'),'Visible','On'); 
   set(findobj(gcf,'Tag','TextTree'),'Visible','On');
   
   set(findobj(gcf,'Tag','SliderHorizontal'),'Enable','On');
   set(findobj(gcf,'Tag','SliderHorizontal'),'Visible','On');
   set(findobj(gcf,'Tag','SliderVertical'),'Enable','On');
   set(findobj(gcf,'Tag','SliderVertical'),'Visible','On');
   
   set(findobj(gcf,'Tag','PopupVar1'),'Enable','Off');
   set(findobj(gcf,'Tag','PopupVar1'),'Visible','Off');
   set(findobj(gcf,'Tag','PopupVar2'),'Enable','Off');
   set(findobj(gcf,'Tag','PopupVar2'),'Visible','Off');
   set(findobj(gcf,'Tag','PopupVar3'),'Enable','Off');
   set(findobj(gcf,'Tag','PopupVar3'),'Visible','Off');
   set(findobj(gcf,'Tag','HedgingText1'),'Enable','Off');
   set(findobj(gcf,'Tag','HedgingText1'),'Visible','Off');
   set(findobj(gcf,'Tag','HedgingText2'),'Enable','Off');
   set(findobj(gcf,'Tag','HedgingText2'),'Visible','Off');
   set(findobj(gcf,'Tag','HedgingText3'),'Enable','Off');
   set(findobj(gcf,'Tag','HedgingText3'),'Visible','Off');
   
   set(findobj(gcf,'Tag','MenuAxisTool'),'Enable','Off');
   
case 'Resize'
   WidthMin = 4.2;
   HeightMin = 3.3;
   
   FigUnitStr = get(gcf,'Units');
   AxesUnitStr = get(gca,'Units');
   set(gcf,'Units','Inches');
   FigSize = get(gcf,'Position');
   
   FigX = FigSize(1); 
   FigWidth = FigSize(3); 
   FigY = FigSize(2); 
   FigHeight = FigSize(4);
   if FigWidth < WidthMin;
      FigWidth = WidthMin;
      FigX = FigX+FigSize(3)-WidthMin;
      if FigX < 0
         FigX = 0;
      end
      set(gcf,'Position',[FigX FigY FigWidth FigHeight]);
   end
   
   if FigHeight < HeightMin;
      FigHeight = HeightMin;
      FigY = FigY+FigSize(4)-HeightMin;
      if FigY < 0
         FigY = 0;
      end   
      set(gcf,'Position',[FigX FigY FigWidth FigHeight]);
   end
   
   
   % Get position popup controls
   UnitStr = get(findobj(gcf,'Tag','PopupVar3'),'Units');
   set(findobj(gcf,'Tag','PopupVar3'),'Units','Inches');
   HeadingSize = get(findobj(gcf,'Tag','PopupVar3'),'Position');
   set(findobj(gcf,'Tag','PopupVar3'),'Units',UnitStr);
    
   
   % Change axes size
   set(gcf,'Units','Inches');
   set(gca,'Units','Inches');
   FigSize = get(gcf,'position');
   FigWidth  = FigSize(3);
   FigHeight = FigSize(4);
   AxesSize = get(gca,'Position');
   
   if get(findobj(gcf,'Tag','RadioGraph'),'Value') == 1
      WidthBufferLeft  = .8;
      WidthBufferRight = .6;
      HeightBufferLower = .45;  % was .7
      HeightBufferUpper = .25;
      
      AxesXmin = WidthBufferLeft;
      AxesYmin = HeadingSize(2)+HeadingSize(4)+HeightBufferLower;
      AxesWidth = FigWidth-WidthBufferRight-WidthBufferLeft;
      AxesHeight = FigHeight-(HeadingSize(2)+HeadingSize(4)+HeightBufferLower)-HeightBufferUpper;
      set(gca,'Position',[AxesXmin AxesYmin AxesWidth AxesHeight]);
      
   else
      % Tree
      set(findobj(gcf,'Tag','SliderHorizontal'),'Units','Inches');
      set(findobj(gcf,'Tag','SliderVertical'),  'Units','Inches');
      
      WidthBufferLeft  = .8;
      WidthBufferRight = .6;
      HeightBufferLower = -.2;
      HeightBufferUpper = .0;
      
      HSliderPosition = get(findobj(gcf,'Tag','SliderHorizontal'),'Position');
      SliderWidth = HSliderPosition(4);
      
      AxesXmin = 0;
      AxesYmin = HeadingSize(2)+HeightBufferLower+SliderWidth;
      AxesWidth = FigWidth-SliderWidth;
      AxesHeight = FigHeight-(HeadingSize(2)+HeadingSize(4)+HeightBufferLower)-HeightBufferUpper-SliderWidth;
      
      set(gca,                                  'Position',[AxesXmin              AxesYmin+SliderWidth AxesWidth             AxesHeight]);
      set(findobj(gcf,'Tag','SliderHorizontal'),'Position',[0                     AxesYmin             FigWidth-SliderWidth  SliderWidth ]);
      set(findobj(gcf,'Tag','SliderVertical'),  'Position',[FigWidth-SliderWidth  AxesYmin+SliderWidth SliderWidth           AxesHeight]);
      
      % Resize popups
      set(gca, 'Units','Points');
      AxesSize = get(gca,'position');
      set(findobj(gcf,'Tag','PopupTree1'),'Position',[2 AxesSize(2)+AxesSize(4)-16 65 15]);
      set(findobj(gcf,'Tag','PopupTree2'),'Position',[2 AxesSize(2)+AxesSize(4)-33 65 15]);
      set(findobj(gcf,'Tag','TextTree'),  'Position',[1.5 AxesSize(2)+.25 130 10]);
   end
   
   % Reset units
   set(gcf,'Units',FigUnitStr);
   set(gca,'Units',AxesUnitStr);   

case 'GetInput'
   Output = getcheckinput(Input2);
   
end
% End switch



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Main input checking function %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function Value = getcheckinput(tag)

Value = str2double(get(findobj(gcf,'Tag',tag),'string'));

if isempty(Value) | isnan(Value) | isinf(Value) | ~isreal(Value) | any(size(Value)~=[1 1]) 
   Value = NaN;
   set(findobj(gcf,'Tag',tag(5:length(tag))),'ForegroundColor',[1 0 0]);
   set(findobj(gcf,'Tag',tag),'ForegroundColor',[1 0 0]);
else
   % Special case input checking
   if strcmp(tag,'EditTextAssetPrice')==1
      if Value<=0
         Value = NaN;
         set(findobj(gcf,'Tag',tag(5:length(tag))),'ForegroundColor',[0 0 1]);
         set(findobj(gcf,'Tag',tag),'ForegroundColor',[0 0 1]);
      else
         Value = round(Value*100)/100;
         set(findobj(gcf,'Tag',tag),'string',num2str(Value(1,:)));
      end
   end
   
   if strcmp(tag,'EditTextAssetReturn')==1 & Value<1
      Value = NaN;
      set(findobj(gcf,'Tag',tag(5:length(tag))),'ForegroundColor',[0 0 1]);
      set(findobj(gcf,'Tag',tag),'ForegroundColor',[0 0 1]);
   end
   
   if strcmp(tag,'EditTextRisklessReturn')==1 & Value<1
      Value = NaN;
      set(findobj(gcf,'Tag',tag(5:length(tag))),'ForegroundColor',[0 0 1]);
      set(findobj(gcf,'Tag',tag),'ForegroundColor',[0 0 1]);
   end
   
   if strcmp(tag,'EditTextExpiration')==1 & Value<=0
      Value = NaN;
      set(findobj(gcf,'Tag',tag(5:length(tag))),'ForegroundColor',[0 0 1]);
      set(findobj(gcf,'Tag',tag),'ForegroundColor',[0 0 1]);
   end
   
   if strcmp(tag,'EditTextVolatility')==1 & Value<=0
      Value = NaN;
      set(findobj(gcf,'Tag',tag(5:length(tag))),'ForegroundColor',[0 0 1]);
      set(findobj(gcf,'Tag',tag),'ForegroundColor',[0 0 1]);
   end
   
   if strcmp(tag,'EditTextStrikePrice')==1
      if Value<=0
         Value = NaN;
         set(findobj(gcf,'Tag',tag(5:length(tag))),'ForegroundColor',[0 0 1]);
         set(findobj(gcf,'Tag',tag),'ForegroundColor',[0 0 1]);
      else
         Value = round(Value*100)/100;
         set(findobj(gcf,'Tag',tag),'string',num2str(Value));
      end
   end
   
   if strcmp(tag,'EditTextTreeSize')==1
      if Value<=0
         Value = NaN;
         set(findobj(gcf,'Tag',tag(5:length(tag))),'ForegroundColor',[0 0 1]);
         set(findobj(gcf,'Tag',tag),'ForegroundColor',[0 0 1]);
      else
         Value = ceil(Value);
         set(findobj(gcf,'Tag',tag),'string',num2str(Value));
      end
   end
end
if ~isnan(Value)
   set(findobj(gcf,'Tag',tag(5:length(tag))),'ForegroundColor',[0 0 0]);
   set(findobj(gcf,'Tag',tag),'ForegroundColor',[0 0 0]);
end

%End function


function Value = getcheckrange(tag)

% Return NaN if the edittext is NaN
Value2 = getcheckinput(tag(1:length(tag)-5));
if isnan(Value2)
   Value = NaN;
  return
end

% Get range, remove blanks
InString = get(findobj(gcf,'Tag',tag),'string');
InString = deblank(InString);

i = findstr(InString, '%');

if isempty(i)
   Value = str2double(InString);
   PercentFlag = 0;
else
   InString(i) = [];
   Value = str2double(InString);
   PercentFlag = 1;
end   

if isempty(Value) | isnan(Value) | isinf(Value) | ~isreal(Value) | any(size(Value)~=[1 1]) 
   Value = NaN;
   set(findobj(gcf,'Tag',tag(5:length(tag)-5)),'ForegroundColor',[1 0 0]);
   set(findobj(gcf,'Tag',tag),'ForegroundColor',[1 0 0]);
else
   % Input bounds checking
   %if Value <= 1e-10
   %   Value = NaN;
   %   set(findobj(gcf,'Tag',tag(5:length(tag)-5)),'ForegroundColor',[0 0 1]);
   %   set(findobj(gcf,'Tag',tag),'ForegroundColor',[0 0 1]);
   %end
end

if PercentFlag
   Value = Value2*Value/100;
end
if ~isnan(Value)
   set(findobj(gcf,'Tag',tag(5:length(tag)-5)),'ForegroundColor',[0 0 0]);
   set(findobj(gcf,'Tag',tag),'ForegroundColor',[0 0 0]);
end
Value = abs(Value);
if Value < 1e-6
   Value = 1e-6;
end

% End function


%%%%%%%%%%%%%%%%%%%
% Input Functions %
%%%%%%%%%%%%%%%%%%%

% Fixed inputs
function [AssetPrice, Range] = getassetprice
AssetPrice = getcheckinput('EditTextAssetPrice');
Range = getcheckrange('EditTextAssetPriceRange');
% End Function


function [AssetReturn, Range] = getassetreturn
AssetReturn = getcheckinput('EditTextAssetReturn');
Range = getcheckrange('EditTextAssetReturnRange');
% End Function


function [RisklessReturn, Range] = getrisklessreturn
RisklessReturn = getcheckinput('EditTextRisklessReturn');
Range = getcheckrange('EditTextRisklessReturnRange');
% End Function


function [Expiration, Range] = getyearstoexpiration
Expiration = getcheckinput('EditTextExpiration');
Range = getcheckrange('EditTextExpirationRange');
% End Function


function [Volatility, Range] = getvolatility
Volatility = getcheckinput('EditTextVolatility');
Range = getcheckrange('EditTextVolatilityRange');
% End Function


function [StrikePrice, Range] = getstrikeprice
StrikePrice = getcheckinput('EditTextStrikePrice');
Range = getcheckrange('EditTextStrikePriceRange');
% End Function


function TreeSize = gettreesize
TreeSize = getcheckinput('EditTextTreeSize');
% End Function


%%%%%%%%%%%%%%%%%%%%%
% Pricing Functions %
%%%%%%%%%%%%%%%%%%%%%

function price = getdollarprice(R, T)
% Present cost of a dollar at the expiration day
%
% R is rate of return (1+r), for example 1.15 for a 15% interest rate
% T is time in years
if nargin < 1
   R = getrisklessreturn;
end
if nargin < 2
   T = getyearstoexpiration;
end

% Continuous
%price = exp(-(R-1)*T);

% Discrete
price = 1/R^T;
% End Function


function CallPrice = getcallprice(StrikePrice)
if nargin < 1
   StrikePrice = getstrikeprice;
end

% Check for errors
AssetPrice = getassetprice;
AssetReturn = getassetreturn;
RisklessReturn = getrisklessreturn;
YearsToExpiration = getyearstoexpiration;
Volatility = getvolatility;

if isnan(AssetPrice) | isnan(StrikePrice) | isnan(RisklessReturn) | isnan(YearsToExpiration) | isnan(Volatility) | isnan(AssetReturn)
   CallPrice = NaN;
else
   % Add input checking for blsprice
   [CallPrice, PutPrice] = blsprice(AssetPrice, StrikePrice, log(RisklessReturn), getyearstoexpiration, Volatility, log(AssetReturn));
end
% End Function


function PutPrice = getputprice(StrikePrice)
if nargin < 1
   StrikePrice = getstrikeprice;
end

% Check for errors
AssetPrice = getassetprice;
AssetReturn = getassetreturn;
RisklessReturn = getrisklessreturn;
YearsToExpiration = getyearstoexpiration;
Volatility = getvolatility;

if isnan(AssetPrice) | isnan(StrikePrice) | isnan(RisklessReturn) | isnan(YearsToExpiration) | isnan(Volatility) | isnan(AssetReturn)
   PutPrice = NaN;
else
   % Add input checking for blsprice
   [CallPrice, PutPrice] = blsprice(AssetPrice, StrikePrice, log(RisklessReturn), getyearstoexpiration, Volatility, log(AssetReturn));
end
% End Function


function price = getforwardprice(DeliveryPrice)
if nargin < 1
   DeliveryPrice = getstrikeprice;
end

AssetPrice = getassetprice;
AssetReturn = getassetreturn;
RisklessReturn = getrisklessreturn;
YearsToExpiration = getyearstoexpiration;

% If the delivery price is a variable
price = AssetPrice*exp(-log(AssetReturn)*YearsToExpiration) - DeliveryPrice*exp(-(log(RisklessReturn))*YearsToExpiration);
% End Function



%%%%%%%%%%%%%%%%%%%%%%
% Plotting Functions %
%%%%%%%%%%%%%%%%%%%%%%

function ErrStr = plothedge(Input1, BLSFlag)

ErrStr = '';

if nargin < 2
   BLSFlag = 1;
end


% Get/check inputs
[AssetPrice, AssetPriceRange] = getassetprice;
[AssetReturn, AssetReturnRange] = getassetreturn;
[RisklessReturn, RisklessReturnRange] = getrisklessreturn;
[Expiration, ExpirationRange] = getyearstoexpiration;
[Volatility, VolatilityRange] = getvolatility;
[StrikePrice, StrikePriceRange] = getstrikeprice;

if isnan(AssetPrice) | isnan(AssetReturn) | isnan(RisklessReturn) | isnan(Expiration) | isnan(Volatility) | isnan(StrikePrice)
   ErrStr = '';
   ErrStr = str2mat(ErrStr, 'Input error.',' ');
   return
end
if isnan(AssetPriceRange) | isnan(AssetReturnRange) | isnan(RisklessReturnRange) | isnan(ExpirationRange) | isnan(VolatilityRange) | isnan(StrikePriceRange)
   ErrStr = '';
   ErrStr = str2mat(ErrStr, 'Input error.',' ');
   return
end

if BLSFlag == 0
   TreeSize = gettreesize;
   if isnan(TreeSize)
      ErrStr = '';
      ErrStr = str2mat(ErrStr, 'Input error.',' ');
      return
   end
   
   CallFlag = get(findobj(gcf,'Tag','RadioCall'),'value');
   AmericanFlag = get(findobj(gcf,'Tag','RadioAmerican'),'value');
end

Var1 = get(findobj(gcf,'Tag','PopupVar1'),'Value');
Var2 = get(findobj(gcf,'Tag','PopupVar2'),'Value');
if Var2==7 | Var1==Var2
   % 2-D plot
   if BLSFlag
      N = 200;
   else
      N = 25;
   end
else
   % 3-D plot
   if BLSFlag
      N = 50;
   else
      N = 10;
   end
end


% If the axis tool calls plotoneopt, then use input1 for the axis size
Percent = .5;   % Determines axis length
if Var1 == 1
   if ~isempty(Input1)
      Xmin = Input1(1);
      Xmax = Input1(2);
   else
      x = AssetPrice;
      %Xmin = min(x) - Percent*abs(min(x));
      %Xmax = max(x) + Percent*abs(max(x));
      Range = AssetPriceRange;
      Xmin = x - Range;
      Xmax = x + Range;      
   end
   Xmin = max([Xmin eps]);
   AssetPrice = linspace(Xmin, Xmax, N);
   Xstr = 'AssetPrice';
   Var1Label = 'Asset Price';
elseif Var1 == 2
   if ~isempty(Input1)
      Xmin = Input1(1);
      Xmax = Input1(2);
   else
      x = AssetReturn;
      %Xmin = min(x) - Percent*abs(min(x));
      %Xmax = max(x) + Percent*abs(max(x));
      Range = AssetReturnRange;
      Xmin = x - Range;
      Xmax = x + Range;      
   end
   
   if Xmin < 1
      %if isempty(Input1)
      %   Xmax = Xmax + (1-Xmin);
      %end
      Xmin = 1;
   end
   AssetReturn = linspace(Xmin, Xmax, N);
   Xstr = 'AssetReturn';
   Var1Label = 'Asset Return';
elseif Var1 == 3
   if ~isempty(Input1)
      Xmin = Input1(1);
      Xmax = Input1(2);
   else
      x = RisklessReturn;
      %Xmin = min(x) - Percent*abs(min(x));
      %Xmax = max(x) + Percent*abs(max(x));
      Range = RisklessReturnRange;
      Xmin = x - Range;
      Xmax = x + Range;      
   end
   
   if Xmin < 1
      %if isempty(Input1)
      %   Xmax = Xmax + (1-Xmin);
      %end
      Xmin = 1;
   end
   RisklessReturn = linspace(Xmin, Xmax, N);
   Xstr = 'RisklessReturn';
   Var1Label = 'Riskless Return';
elseif Var1 == 4
   if ~isempty(Input1)
      Xmin = Input1(1);
      Xmax = Input1(2);
   else
      x = Expiration;
      %Xmin = min(x) - Percent*abs(min(x));
      %Xmax = max(x) + Percent*abs(max(x));
      Range = ExpirationRange;
      Xmin = x - Range;
      Xmax = x + Range;
   end
   Xmin = max([Xmin eps]);
   Expiration= linspace(Xmin, Xmax, N);
   Xstr = 'Expiration';
   Var1Label = 'Years-to-Expiration';
elseif Var1 == 5
   if ~isempty(Input1)
      Xmin = Input1(1);
      Xmax = Input1(2);
   else
      x = Volatility;
      %Xmin = min(x) - Percent*abs(min(x));
      %Xmax = max(x) + Percent*abs(max(x));
      Range = VolatilityRange;
      Xmin = x - Range;
      Xmax = x + Range;
   end
   Xmin = max([Xmin eps]);
   Volatility = linspace(Xmin, Xmax, N);
   Xstr = 'Volatility';
   Var1Label = 'Volatility';
elseif Var1 == 6
   if ~isempty(Input1)
      Xmin = Input1(1);
      Xmax = Input1(2);
   else
      x = StrikePrice;
      %Xmin = min(x) - Percent*abs(min(x));
      %Xmax = max(x) + Percent*abs(max(x));
      Range = StrikePriceRange;
      Xmin = x - Range;
      Xmax = x + Range;
   end
   Xmin = max([Xmin eps]);
   StrikePrice = linspace(Xmin, Xmax, N);
   Xstr = 'StrikePrice';
   Var1Label = 'Strike Price';
else
   error('Var1>6');
end

if Var1 == Var2
   Var2=7;
   Ystr=[];
elseif Var2 == 1
   if ~isempty(Input1)
      Xmin = Input1(3);
      Xmax = Input1(4);
   else
      x = AssetPrice;
      %Xmin = min(x) - Percent*abs(min(x));
      %Xmax = max(x) + Percent*abs(max(x));
      Range = AssetPriceRange;
      Xmin = x - Range;
      Xmax = x + Range;
   end
   Xmin = max([Xmin eps]);
   AssetPrice = linspace(Xmin, Xmax, N);
   Ystr = 'AssetPrice';
   Var2Label = 'Asset Price';
elseif Var2 == 2
   if ~isempty(Input1)
      Xmin = Input1(3);
      Xmax = Input1(4);
   else
      x = AssetReturn;
      %Xmin = min(x) - Percent*abs(min(x));
      %Xmax = max(x) + Percent*abs(max(x));
      Range = AssetReturnRange;
      Xmin = x - Range;
      Xmax = x + Range;      
   end
   
   if Xmin < 1
      %if isempty(Input1)
      %   Xmax = Xmax + (1-Xmin);
      %end
      Xmin = 1;
   end
   AssetReturn = linspace(Xmin, Xmax, N);
   Ystr = 'AssetReturn';
   Var2Label = 'Asset Return';
elseif Var2 == 3
   if ~isempty(Input1)
      Xmin = Input1(3);
      Xmax = Input1(4);
   else
      x = RisklessReturn;
      %Xmin = min(x) - Percent*abs(min(x));
      %Xmax = max(x) + Percent*abs(max(x));
      Range = RisklessReturnRange;
      Xmin = x - Range;
      Xmax = x + Range;      
   end
   
   if Xmin < 1
      %if isempty(Input1)
      %   Xmax = Xmax + (1-Xmin);
      %end
      Xmin = 1;
   end
   RisklessReturn = linspace(Xmin, Xmax, N);
   Ystr = 'RisklessReturn';
   Var2Label = 'Riskless Return';
elseif Var2 == 4
   if ~isempty(Input1)
      Xmin = Input1(3);
      Xmax = Input1(4);
   else
      x = Expiration;
      %Xmin = min(x) - Percent*abs(min(x));
      %Xmax = max(x) + Percent*abs(max(x));
      Range = ExpirationRange;
      Xmin = x - Range;
      Xmax = x + Range;
   end
   Xmin = max([Xmin eps]);
   Expiration= linspace(Xmin, Xmax, N);
   Ystr = 'Expiration';
   Var2Label = 'Years-to-Expiration';
elseif Var2 == 5
   if ~isempty(Input1)
      Xmin = Input1(3);
      Xmax = Input1(4);
   else
      x = Volatility;
      %Xmin = min(x) - Percent*abs(min(x));
      %Xmax = max(x) + Percent*abs(max(x));
      Range = VolatilityRange;
      Xmin = x - Range;
      Xmax = x + Range;
   end
   Xmin = max([Xmin eps]);
   Volatility = linspace(Xmin, Xmax, N);
   Ystr = 'Volatility';
   Var2Label = 'Volatility';
elseif Var2 == 6
   if ~isempty(Input1)
      Xmin = Input1(1);
      Xmax = Input1(2);
   else
      x = StrikePrice;
      %Xmin = min(x) - Percent*abs(min(x));
      %Xmax = max(x) + Percent*abs(max(x));
      Range = StrikePriceRange;
      Xmin = x - Range;
      Xmax = x + Range;
   end
   Xmin = max([Xmin eps]);
   StrikePrice = linspace(Xmin, Xmax, N);
   Ystr = 'StrikePrice';
   Var2Label = 'Strike Price';
elseif Var2 == 7
   Ystr = [];
   Var2Label = ' ';
else
   error('Var2>7');
end   


Var3 = get(findobj(gcf,'Tag','PopupVar3'),'Value');
if Var3 == 1
   HedgeFuncName = 'price';
   Var3Label = 'Value';
elseif Var3 == 2
   HedgeFuncName = 'delta';
   Var3Label = 'Delta';
elseif Var3 == 3
   HedgeFuncName = 'gamma';
   Var3Label = 'Gamma';
elseif Var3 == 4
   HedgeFuncName = 'theta';
   Var3Label = 'Theta';
elseif Var3 == 5
   HedgeFuncName = 'vega';
   Var3Label = 'Vega';
elseif Var3 == 6
   HedgeFuncName = 'rho';
   Var3Label = 'Rho';
elseif Var3 == 7
   HedgeFuncName = 'lambda1';  % Changed blslambda
   Var3Label = 'Omega';
else
   error('Var3>7');
end


cla
hold off
Ztotal = 0;

% Make dependent variable axis
if Var2 == 7
   % 2-Dim plot
else
   % 3-Dim plot
   eval(['[',Xstr,',',Ystr,']=meshgrid(',Xstr,',',Ystr,');']);
end

if get(findobj(gcf,'Tag','RadioCall'),'Value') == 1
   Zstr = 'Call';
   AssetLabel = [' of a Call'];
   LineColor = [0 .75 0];
   RGB = [0 .75 0];
else
   Zstr = 'Put';
   AssetLabel = [' of a Put'];
   LineColor = 'r';
   RGB = [1 0 0];
end

if BLSFlag
   % Use Black-Scholes equations
   if Var3==3 | Var3==5
      eval(['Call=bls',       lower(HedgeFuncName),'(AssetPrice, StrikePrice, log(RisklessReturn), Expiration, Volatility, log(AssetReturn));']);
      Put = Call;
   else
      eval(['[Call, Put]=bls',lower(HedgeFuncName),'(AssetPrice, StrikePrice, log(RisklessReturn), Expiration, Volatility, log(AssetReturn));']);
   end
else
   % Use binary tree equations
   if Var3==1
      eval([Zstr,'=localbinpricevec(AssetPrice, StrikePrice, log(RisklessReturn), Expiration, TreeSize, Volatility, CallFlag, AmericanFlag, log(AssetReturn));']);
   elseif Var3==2 | Var3==3 | Var3==4 | Var3==7
      eval(['[value, delta, gamma, theta, lambda1]=localbinhedge(AssetPrice, StrikePrice, log(RisklessReturn), Expiration, TreeSize, Volatility, CallFlag, AmericanFlag, log(AssetReturn));']);
      eval([Zstr,'=',lower(HedgeFuncName),';']);
   elseif Var3==5 
      eval([Zstr,'=localbinvega(AssetPrice, StrikePrice, log(RisklessReturn), Expiration, TreeSize, Volatility, CallFlag, AmericanFlag, log(AssetReturn));']);
   elseif Var3==6 
      eval([Zstr,'=localbinrho(AssetPrice, StrikePrice, log(RisklessReturn), Expiration, TreeSize, Volatility, CallFlag, AmericanFlag, log(AssetReturn));']);
   else
      error('Var3 error.')
   end
end


% Plot
if Var2 == 7
   % 2-Dim plot
   LineStyle = ['-'];
   eval(['plot(',Xstr,',',Zstr,', ''Linestyle'', LineStyle, ''Color'', LineColor,''LineWidth'',1.75);']);
   hold on
   xlabel(Var1Label,'Color',[0 0 .5]);
   ylabel([Var3Label AssetLabel],'Color',[0 0 .5]);
else
   eval(['mesh(',Xstr,',',Ystr,',',Zstr,');']);  
   
   view([35, 40]);
   xlabel(Var1Label,'Color',[0 0 .5]);
   ylabel(Var2Label,'Color',[0 0 .5]);
   zlabel([Var3Label AssetLabel],'Color',[0 0 .5]);
   
   hold on
   
   % Mesh automatically puts a grid on
   set(findobj(gcf,'Tag','MenuGridOn'),'Checked','on');
   set(findobj(gcf,'Tag','MenuGridOff'),'Checked','off');
   
   %set(gcf,'Color',[.8 .8 .8]-.045);  %???? bug
end


% Axis does not scale that well, force the full axis
%axis tight
a = axis;
if length(a)==4
   if a(3)==0 | a(3)==1 | a(4)==0 | a(4)==1
      % Expand the axis a little
      p = .05;
      a3 = a(3);
      a4 = a(4);
      a(3) = a(3) - p*abs(a4-a3);
      a(4) = a(4) + p*abs(a4-a3);
   end
   eval(['axis([min(min(',Xstr,')) max(max(',Xstr,')) a(3) a(4)]);']);
elseif length(a)==6
   eval(['axis([min(min(',Xstr,')) max(max(',Xstr,')) min(min(',Ystr,')) max(max(',Ystr,')) a(5) a(6)]);']);
end

hold off;

% Add grid
if strcmp(lower(get(findobj(gcf,'Tag','MenuGridOn'),'Checked')),'on')==1
   grid on
end


% Update axis tool if it open
if strcmp(lower(get(findobj(gcf,'Tag','MenuAxisTool'),'Checked')),'on')==1 & isempty(Input1)
   AxesHandle = gca;
   axisfn('Initialize', gca, get(findobj(gcf,'Tag','MenuAxisTool'),'Userdata') );
   axes(AxesHandle);
end
% End function



function ErrStr = plottree(Input1)

ErrStr = '';

% Get inputs
[AssetPrice, AssetPriceRange] = getassetprice;
[AssetReturn, AssetReturnRange] = getassetreturn;
[RisklessReturn, RisklessReturnRange] = getrisklessreturn;
[Expiration, ExpirationRange] = getyearstoexpiration;
[Volatility, VolatilityRange] = getvolatility;
[StrikePrice, StrikePriceRange] = getstrikeprice;
TreeSize = gettreesize;
CallFlag = get(findobj(gcf,'Tag','RadioCall'),'value');
AmericanFlag = get(findobj(gcf,'Tag','RadioAmerican'),'value');

if isnan(TreeSize) | isnan(AssetPrice) | isnan(AssetReturn) | isnan(RisklessReturn) | isnan(Expiration) | isnan(Volatility) | isnan(StrikePrice)
   ErrStr = '';
   ErrStr = str2mat(ErrStr, 'Input error.',' ');
   return
end


% Compute tree
[AssetMatrix, ValueMatrix, u, d, p, EarlyExerciseMatrix] = localbinprice(AssetPrice, StrikePrice, log(RisklessReturn), Expiration, Expiration/TreeSize, Volatility, CallFlag, AmericanFlag, log(AssetReturn));
set(findobj(gcf,'Tag','TextTree'),'String',sprintf('u=%.4f, d=%.4f, p=%.4f',u,d,p));

if get(findobj(gcf,'Tag','PopupTree1'),'value') == 1
   TreeMatrix1 = 'Symbols';
elseif get(findobj(gcf,'Tag','PopupTree1'),'value') == 2
   TreeMatrix1 = AssetMatrix;      
elseif get(findobj(gcf,'Tag','PopupTree1'),'value') == 3
   TreeMatrix1 = ValueMatrix;      
else
   TreeMatrix1 = rand(TreeSize+1);
end


if get(findobj(gcf,'Tag','PopupTree2'),'value') == 1
   TreeMatrix2 = 'Symbols';
elseif get(findobj(gcf,'Tag','PopupTree2'),'value') == 2
   TreeMatrix2 = AssetMatrix;      
elseif get(findobj(gcf,'Tag','PopupTree2'),'value') == 3
   TreeMatrix2 = ValueMatrix;      
else
   TreeMatrix2 = rand(TreeSize+1);
end


% Set slider value and limits
NumRows = TreeSize+1;
NumCols = NumRows;
if NumCols < 4
   NumCols = 4;
end
set(findobj(gcf,'Tag','SliderHorizontal'), ...
   'SliderStep', [1/(NumCols-2) .1+1/(NumCols-2)], ...
   'Value', 1, ...
   'Min', 1, ...
   'Max', NumCols-1);
set(findobj(gcf,'Tag','SliderVertical'), ...
   'SliderStep', [1/NumRows .1+1/NumRows], ...
   'Value', NumRows/2, ...
   'Min', 0, ...
   'Max', NumRows);

% Plot
%ColStart=round(get(findobj(gcf,'Tag','SliderHorizontal'),'value'));
%RowStart=round((TreeSize+1)/2)-round(get(findobj(gcf,'Tag','SliderVertical'),'value'))+1;
%localdrawtree(TreeMatrix1, TreeMatrix2, RowStart, ColStart);
localdrawtree(TreeMatrix1, TreeMatrix2, 1, 1, gca, EarlyExerciseMatrix);

% Store tree
set(findobj(gcf,'Tag','SliderHorizontal'),'Userdata', TreeMatrix1);
set(findobj(gcf,'Tag','SliderVertical'),  'Userdata', TreeMatrix2);

% close axis tool if it open
if strcmp(lower(get(findobj(gcf,'Tag','MenuAxisTool'),'Checked')),'on')==1 & isempty(Input1)
   AxesHandle = gca;
   close(get(findobj(gcf,'Tag','MenuAxisTool'),'Userdata'));
   axes(AxesHandle);
end

% End function



function localdrawtree(A, B, RowStart, ColStart, Axes_Handle, EarlyExerciseMatrix)

NumRows = gettreesize+1;
NumCols = NumRows;

if nargin == 0
	A = rand(10);
	B = rand(10);
	RowStart = 1;
   ColStart = 1;
   Axes_Handle = gca;
   EarlyExerciseMatrix = zeros(NumRows,NumCols);
elseif nargin == 1
	B = rand(10);
	RowStart = 1;
	ColStart = 1;
   Axes_Handle = gca;
   EarlyExerciseMatrix = zeros(NumRows,NumCols);
elseif nargin == 2
	RowStart = 1;
	ColStart = 1;
   Axes_Handle = gca;
   EarlyExerciseMatrix = zeros(NumRows,NumCols);
elseif nargin == 3
	RowStart = 1;
	ColStart = 1;
   Axes_Handle = gca;
   EarlyExerciseMatrix = zeros(NumRows,NumCols);
elseif nargin == 4
   Axes_Handle = gca;
   EarlyExerciseMatrix = zeros(NumRows,NumCols);
elseif nargin == 5
   EarlyExerciseMatrix = zeros(NumRows,NumCols);
end


% Make axis current, clear, set to inches, and find extent 
axes(Axes_Handle);
cla
hold off
plot(0,0);
xlabel('');
ylabel('');
zlabel('');
%axis off  does not allow color changes

UnitStr = get(Axes_Handle,'Units');
set(Axes_Handle,'Units','Inches');
AxesSize = get(Axes_Handle,'position');
XLim = AxesSize(3);
YLim = AxesSize(4);
set(Axes_Handle,'XLim',[0 XLim]);
set(Axes_Handle,'YLim',[0 YLim]);
set(Axes_Handle,'Xtick',[]);
set(Axes_Handle,'Ytick',[]);


font = 9;
H1 = 2*(1/72)*font;
XlineLength = .75;
XLineBuffer = (.8)*(1/72)*font;
Yoffset = 2 * H1 * (RowStart-1);


StopFlag = 0;
Flag1 = get(findobj(gcf,'Tag','PopupTree1'),'value');
Flag2 = get(findobj(gcf,'Tag','PopupTree2'),'value');
x=-XlineLength+.25;
for Col = ColStart:NumCols
   % Check for the number of char wide num2str returns, change CharWidth accordingly
   CharWidth = 5;
   
   % Should jump rows
   RowStart1 = floor(.75 - YLim/H1/4 +(Col-1)/2 + Yoffset/H1/2);
   if RowStart1 < 1
      RowStart1 = 1;
   end
   
   for Row = RowStart1:Col
      % Stop if greater than axes width
      if (x+XlineLength) > XLim
         %if (x+XlineLength+CharWidth*(.6)*font*(1/72)) > XLim
         %disp('Column stop')
         StopFlag = 1;
         break;
      end
      
      y = (YLim/2) - (2*H1*(Row-1)) + H1*(Col-ColStart) + H1*(ColStart-1) + Yoffset;
      
      if y<YLim+H1/2 &  y>-H1/2
         %[Col Row x y]
         % Draw line
         if Col > 1
            if Row ~= 1
               % Draw "bottom" line
               if EarlyExerciseMatrix(Row-1,Col-1) == 1
                  % Earily evaluation
                  line([x+XLineBuffer  x+XlineLength-XLineBuffer],[y+H1 y],'color',[0 .7 0]);
               else
                  % No earily evaluation
                  line([x+XLineBuffer  x+XlineLength-XLineBuffer],[y+H1 y],'color','k');
               end
            end
            if Row ~= Col
               % Draw "top" line
               if EarlyExerciseMatrix(Row,Col-1) == 1
                  % Earily evaluation
                  line([x+XLineBuffer  x+XlineLength-XLineBuffer],[y-H1 y],'color',[0 .7 0]);
               else
                  % No earily evaluation
                  line([x+XLineBuffer  x+XlineLength-XLineBuffer],[y-H1 y],'color','k');
               end
            end
         end
         
         % Write text
         if Flag1==1
            Dn = Row-1;
            Up = Col - Dn - 1;
            text(x + XlineLength, y+H1/3, sprintf('Su^{%d}d^{%d}', Up, Dn),'color','b');
         elseif Flag1==2 | Flag1==3
            text(x + XlineLength, y+H1/3, sprintf('%.2f',A(Row,Col)),'color','b');
         else
            text(x + XlineLength, y+H1/3, sprintf('%f',A(Row,Col)),'color','b');
         end
         
         if Flag2==1
            Dn = Row-1;
            Up = Col - Dn - 1;
            text(x + XlineLength, y-H1/3, sprintf('Su^{%d}d^{%d}', Up, Dn),'color','r');
         elseif Flag2==2 | Flag2==3
            text(x + XlineLength, y-H1/3, sprintf('%.2f',B(Row,Col)),'color','r');
         else
            text(x + XlineLength, y-H1/3, sprintf('%f',B(Row,Col)),'color','r');
         end
      end
      
      if y <= -H1/2
         %disp('Row  break')
			break;
		end
	end
	x = x + CharWidth*(.6)*font*(1/72) + XlineLength;
   
   %drawnow
   %axes(Axes_Handle);

	if StopFlag == 1
		break
	end
end


% return axes units
set(Axes_Handle,'Units',UnitStr);   


% Color
set(gca,'color',[1 1 1]);
% End function



function [lc,lp] = blslambda1(so,x,r,t,sig,q)  
%BLSLAMBDA Black-Scholes elasticity.  

% Changed due to vectorizing problem of the FTB blslambda  ????

if nargin < 5  
  error(sprintf('Missing one of SO, X, R, T, and SIG.'))  
end  
if any(so <= 0 | x <= 0 | r < 0 | t <=0 | sig < 0)  
  error(sprintf('Enter SO, X, and T > 0. Enter R and S >= 0.'))  
end  
if nargin < 6  
  q = zeros(size(so));  
end  
  

[cprice, pprice] = blsprice(so,x,r,t,sig,q);  
[cdelta, pdelta] = blsdelta(so,x,r,t,sig,q);  
lc = so.*cdelta./cprice;
lp = so.*pdelta./pprice;
% End function



function [pr,opt,u,d,p,EarlyExerciseMatrix] = localbinprice(so,x,r,t,dt,sig,CallFlag,AmericanFlag,q,div,exdiv) 
%BINPRICE Binomial put and call pricing. 
%       [PR,OPT] = BINPRICE(SO,X,R,T,DT,SIG,FLAG,Q,DIV,EXDIV)  
%       prices an option using a binomial pricing model.  SO is the underlying 
%       asset price, X is the option exercise price, R is the risk-free 
%       interest rate, T is the option’s time until maturity in years, DT 
%       is the time increment within T, SIG is the assetüs volatility, FLAG 
%       specifies whether the option is a call (CallFlag = else) or a put (CallFlag = 0), 
%       Q is the dividend rate, DIV is the dividend payment at an ex-dividend 
%       date, EXDIV.  EXDIV is specified in number of periods.  All inputs to 
%       this function are scalar values except DIV and EXDIV which are 1-by-n 
%       vectors.  For each dividend payment, there must be a corresponding 
%       ex-dividend date.  By default q, div, and EXDIV equal 0.  If a value 
%       is entered for the dividend rate q, DIV and EXDIV should equal 0 or 
%       not be entered.  If values are entered for DIV and EXDIV, set Q = 0. 
% 
%       [P,O] = binprice(52,50,.1,5/12,1/12,.4,0,0,2.06,3.5) returns 
%       the asset price and option value at each node of the binary 
%       tree. 
% 
%       P = 
% 
%        52.0000   58.1367   65.0226   72.7494   79.3515   89.0642 
%              0   46.5642   52.0336   58.1706   62.9882   70.6980 
%              0         0   41.7231   46.5981   49.9992   56.1192 
%              0         0         0   37.4120   39.6887   44.5467 
%              0         0         0         0   31.5044   35.3606 
%              0         0         0         0         0   28.0688 
% 
%       O = 
% 
%         4.4404    2.1627    0.6361         0         0         0 
%              0    6.8611    3.7715    1.3018         0         0 
%              0         0   10.1591    6.3785    2.6645         0 
%              0         0         0   14.2245   10.3113    5.4533 
%              0         0         0         0   18.4956   14.6394 
%              0         0         0         0         0   21.9312 
% 
%       See also BLSPRICE. 
% 
%       Reference: Options, Futures, and Other Derivative Securities, 
%                  2nd Edition, Hull, Chapter 14. 
 
%       Author(s): C.F. Garvin, 5-10-95 

% Added AmericanFlag to distingush between american and european options

if nargin < 9
  q = 0; 
end 
if nargin < 10 
  div = 0; 
  exdiv = 0; 
end 
if nargin < 8
  error(sprintf('Missing one of SO, X, R, T, DT, SIG, FLAG, and AMFLAG.')) 
end 
if q ~= 0 & exist('div') 
  if div ~= 0 
    disp(char(7)) 
    fprintf(['??? Error using ==> binprice\n',... 
             'DIV and EXDIV must be zero for non-zero dividend rate, Q.\n\n']) 
    return 
  end 
end 
 
% Calculate the probability of an upward price movement 
u = exp(sig.*sqrt(dt)); 
d = 1./u; 
a = exp((r-q).*dt); 
p = (a-d)./(u-d); 
 
nper = round(t/dt);             % Number of periods after time zero 
npp = nper+1;                   % Number of periods including time zero 
jspan = -fix(nper*.5);          % j-th node offset number  
ispan = rem(t/dt,2);            % i-th node offset number 
i = ispan:(nper+ispan);         % i-th node numbers 
j = (jspan:(nper+jspan))';      % j-th node numbers 
jex = j(:,ones(size(i')));      % expand i and j to eliminate for loop 
iex = i(ones(size(j)),:); 
 
pvdiv = div.*exp(-exdiv.*dt.*r);  % Find present value of all dividends 
so = so-sum(pvdiv(:));            % Find current price - div present values 
 
% Asset price at nodes, matrix is flipped so tree appears correct visually 
pr = triu(fliplr(flipud(so.*u.^jex.*d.^(iex-jex))));   
 
if exist('div')                 % Present value of future dividends at nodes 
  lendiv = length(div(:)); 
  lenexdiv = length(exdiv(:)); 
  if lendiv ~= lenexdiv 
    error(sprintf('Number of dividend and ex-dividend entries must be equal.')) 
  end 
  dpvtot = zeros(npp);          % Preallocate matrix 
  for y = 1:lenexdiv 
    z = (exdiv(y):-1:0);        % Create vector from 0 to ex-div date 
    dpv = div(y)*exp(-z*dt*r);  % Discount dividends nodes 
    dpvmat = [dpv(ones(npp,1),:) zeros(npp,npp-length(dpv))]; % Expand matrix 
    dpvtot = dpvtot + dpvmat;   % Add next discounted dividend to total 
  end 
  m = find(pr~=0);              % Find nodes where option will have value 
  pr(m) = pr(m)+dpvtot(m);      % combine div pv's and prices to get new prices 
end 
opt = zeros(size(pr));
EarlyExerciseMatrix = zeros(size(pr));

if AmericanFlag
   % American option
   if CallFlag                          % Option is a call 
      opt(:,npp) = max(pr(:,npp)-x,0);  % Determine option values from prices 
      for n = nper:-1:1 
         k = 1:n; 
         % Probable option values discounted back one time step 
         discopt = (p*opt(k,n+1)+(1-p)*opt(k+1,n+1))*exp(-r*dt); 
         % Option value is max of current price - X or discopt 
         opt(:,n) = [max(pr(1:n,n)-x,discopt);zeros(npp-n,1)];
         if n == nper
            EarlyExerciseMatrix(1:n,n) = max(x-pr(1:n,n),zeros(n,1)) < discopt;
         else
            EarlyExerciseMatrix(:,n) = [EarlyExerciseMatrix(nper-n+1:nper+1,nper);zeros(nper-n,1)];
         end
      end 
   else                                 % Option is a put 
      opt(:,npp) = max(x-pr(:,npp),0);  % Determine option values from prices 
      for n = nper:-1:1 
         k = 1:n; 
         % Probable option values discounted back one time step 
         discopt = (p*opt(k,n+1)+(1-p)*opt(k+1,n+1))*exp(-r*dt); 
         % Option value is max of X - current price or discopt 
         opt(:,n) = [max(x-pr(1:n,n),discopt);zeros(npp-n,1)]; 
         if n == nper
            EarlyExerciseMatrix(1:n,n) = max(x-pr(1:n,n),zeros(n,1)) < discopt;
         else
            EarlyExerciseMatrix(1:n,n) = [EarlyExerciseMatrix(1:n,nper)];
         end
      end 
   end
else
   % European option
   if CallFlag                          % Option is a call 
      opt(:,npp) = max(pr(:,npp)-x,0);  % Determine option values from prices 
      for n = nper:-1:1 
         k = 1:n; 
         % Probable option values discounted back one time step 
         discopt = (p*opt(k,n+1)+(1-p)*opt(k+1,n+1))*exp(-r*dt); 
         % Option value the discopt
         opt(:,n) = [discopt;zeros(npp-n,1)]; 
      end 
   else                                 % Option is a put 
      opt(:,npp) = max(x-pr(:,npp),0);  % Determine option values from prices 
      for n = nper:-1:1 
         k = 1:n; 
         % Probable option values discounted back one time step 
         discopt = (p*opt(k,n+1)+(1-p)*opt(k+1,n+1))*exp(-r*dt); 
         % Option value is the discopt 
         opt(:,n) = [discopt;zeros(npp-n,1)]; 
      end 
   end
end
% End function



function value = localbinpricevec(so,x,r,t,TreeSize,sig,CallFlag,AmericanFlag,q,div,exdiv) 
%BINPRICEVEC Binomial put and call pricing (vectorized). 
if nargin < 9
  q = 0; 
end 
if nargin < 10 
  div = 0; 
  exdiv = 0; 
end 
if nargin < 8
  error(sprintf('Missing one of SO, X, R, T, TreeSize, SIG, FLAG, and AMFLAG.')) 
end 
if q ~= 0 & exist('div') 
  if div ~= 0 
    disp(char(7)) 
    fprintf(['??? Error using ==> binprice\n',... 
             'DIV and EXDIV must be zero for non-zero dividend rate, Q.\n\n']) 
    return 
  end 
end 

m = max([size(so,1) size(x,1) size(r,1) size(t,1) size(sig,1) size(q,1)]);
n = max([size(so,2) size(x,2) size(r,2) size(t,2) size(sig,2) size(q,2)]);

I = ones(m,n);
if size(so) == [m n]
else
   so = so * I;
end
if size(x) == [m n]
else
   x = x * I;
end
if size(r) == [m n]
else
   r = r * I;
end
if size(t) == [m n]
else
   t = t * I;
end
if size(sig) == [m n]
else
   sig = sig * I;
end
if size(q) == [m n]
else
   q = q * I;
end

value = I;

for i = 1:m
   for j = 1:n
      dt = t(i,j)/TreeSize;
      [AssetMat, OptionMat] = localbinprice(so(i,j),x(i,j),r(i,j),t(i,j),dt,sig(i,j),CallFlag,AmericanFlag,q(i,j),div,exdiv);
      value(i,j) = OptionMat(1,1);
   end
end
% End function



function [value, delta, gamma, theta, lambda] = localbinhedge(so,x,r,t,TreeSize,sig,CallFlag,AmericanFlag,q,div,exdiv) 
%BINHEDGE Binomial put and call hedge parameters(vectorized). 
if nargin < 9
  q = 0; 
end 
if nargin < 10 
  div = 0; 
  exdiv = 0; 
end 
if nargin < 8
  error(sprintf('Missing one of SO, X, R, T, TreeSize, SIG, FLAG, and AMFLAG.')) 
end 
if q ~= 0 & exist('div') 
  if div ~= 0 
    disp(char(7)) 
    fprintf(['??? Error using ==> binprice\n',... 
             'DIV and EXDIV must be zero for non-zero dividend rate, Q.\n\n']) 
    return 
  end 
end 

m = max([size(so,1) size(x,1) size(r,1) size(t,1) size(sig,1) size(q,1)]);
n = max([size(so,2) size(x,2) size(r,2) size(t,2) size(sig,2) size(q,2)]);

I = ones(m,n);
if size(so) == [m n]
else
   so = so * I;
end
if size(x) == [m n]
else
   x = x * I;
end
if size(r) == [m n]
else
   r = r * I;
end
if size(t) == [m n]
else
   t = t * I;
end
if size(sig) == [m n]
else
   sig = sig * I;
end
if size(q) == [m n]
else
   q = q * I;
end

value = I;
delta = I;
gamma = I;
theta = I;
lambda = I;


for i = 1:m
   for j = 1:n
      dt = t(i,j)/TreeSize;
      [AssetMat, OptionMat] = localbinprice(so(i,j),x(i,j),r(i,j),t(i,j),dt,sig(i,j),CallFlag,AmericanFlag,q(i,j),div,exdiv);
      
      del = exp(q(i,j)*t(i,j)/TreeSize);
      
      value(i,j) = OptionMat(1,1);
      
      delta(i,j) = (OptionMat(1,2)-OptionMat(2,2))/(del*(AssetMat(1,2)-AssetMat(2,2)));
      
      delta1     = (OptionMat(1,3)-OptionMat(2,3))/(del*(AssetMat(1,3)-AssetMat(2,3)));
      
      delta2     = (OptionMat(2,3)-OptionMat(3,3))/(del*(AssetMat(2,3)-AssetMat(3,3)));
      
      gamma(i,j) = (delta1 - delta2)/(del*(AssetMat(1,2)-AssetMat(2,2)));
      
      theta(i,j) = (OptionMat(2,3)-OptionMat(1,1))/(2*dt);
      
      if OptionMat(1,1) == 0
         lambda(i,j)= NaN;
      else
         lambda(i,j)= delta(i,j) * AssetMat(1,1) / OptionMat(1,1);
      end
   end
end
% End function



function rho = localbinrho(so,x,r,t,TreeSize,sig,CallFlag,AmericanFlag,q,div,exdiv) 
%BINHEDGE Binomial rho (vectorized). 

DeltaR = .0001;  % ?????

if nargin < 9
  q = 0; 
end 
if nargin < 10 
  div = 0; 
  exdiv = 0; 
end 
if nargin < 8
  error(sprintf('Missing one of SO, X, R, T, TreeSize, SIG, FLAG, and AMFLAG.')) 
end 
if q ~= 0 & exist('div') 
  if div ~= 0 
    disp(char(7)) 
    fprintf(['??? Error using ==> binprice\n',... 
             'DIV and EXDIV must be zero for non-zero dividend rate, Q.\n\n']) 
    return 
  end 
end 

m = max([size(so,1) size(x,1) size(r,1) size(t,1) size(sig,1) size(q,1)]);
n = max([size(so,2) size(x,2) size(r,2) size(t,2) size(sig,2) size(q,2)]);

I = ones(m,n);
if size(so) == [m n]
else
   so = so * I;
end
if size(x) == [m n]
else
   x = x * I;
end
if size(r) == [m n]
else
   r = r * I;
end
if size(t) == [m n]
else
   t = t * I;
end
if size(sig) == [m n]
else
   sig = sig * I;
end
if size(q) == [m n]
else
   q = q * I;
end

rho = I;

for i = 1:m
   for j = 1:n
      dt = t(i,j)/TreeSize;
      [AssetMat1, OptionMat1] = localbinprice(so(i,j),x(i,j),r(i,j),t(i,j),dt,sig(i,j),CallFlag,AmericanFlag,q(i,j),div,exdiv);
      [AssetMat2, OptionMat2] = localbinprice(so(i,j),x(i,j),r(i,j)+DeltaR,t(i,j),dt,sig(i,j),CallFlag,AmericanFlag,q(i,j),div,exdiv);
      
      rho(i,j)= (OptionMat2(1,1) - OptionMat1(1,1)) / DeltaR;
   end
end
% End function



function vega = localbinvega(so,x,r,t,TreeSize,sig,CallFlag,AmericanFlag,q,div,exdiv) 
%BINHEDGE Binomial vega (vectorized). 

DeltaSig = .0001;  % ?????

if nargin < 9
  q = 0; 
end 
if nargin < 10 
  div = 0; 
  exdiv = 0; 
end 
if nargin < 8
  error(sprintf('Missing one of SO, X, R, T, TreeSize, SIG, FLAG, and AMFLAG.')) 
end 
if q ~= 0 & exist('div') 
  if div ~= 0 
    disp(char(7)) 
    fprintf(['??? Error using ==> binprice\n',... 
             'DIV and EXDIV must be zero for non-zero dividend rate, Q.\n\n']) 
    return 
  end 
end 

m = max([size(so,1) size(x,1) size(r,1) size(t,1) size(sig,1) size(q,1)]);
n = max([size(so,2) size(x,2) size(r,2) size(t,2) size(sig,2) size(q,2)]);

I = ones(m,n);
if size(so) == [m n]
else
   so = so * I;
end
if size(x) == [m n]
else
   x = x * I;
end
if size(r) == [m n]
else
   r = r * I;
end
if size(t) == [m n]
else
   t = t * I;
end
if size(sig) == [m n]
else
   sig = sig * I;
end
if size(q) == [m n]
else
   q = q * I;
end

vega = I;

for i = 1:m
   for j = 1:n
      dt = t(i,j)/TreeSize;
      [AssetMat1, OptionMat1] = localbinprice(so(i,j),x(i,j),r(i,j),t(i,j),dt,sig(i,j),CallFlag,AmericanFlag,q(i,j),div,exdiv);
      [AssetMat2, OptionMat2] = localbinprice(so(i,j),x(i,j),r(i,j),t(i,j),dt,sig(i,j)+DeltaSig,CallFlag,AmericanFlag,q(i,j),div,exdiv);
      
      vega(i,j)= (OptionMat2(1,1) - OptionMat1(1,1)) / DeltaSig;
   end
end
% End function


