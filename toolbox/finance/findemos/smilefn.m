function Output = smilefn(action, Input2)
%SMILEFN Switchyard function for the volatility smile GUI SMILE.
%
% Output = smilefn(action, Input2)
%


% Created by Greg Portmann (Sept 1997)

%       Copyright 1995-2002 The MathWorks, Inc. 
%       $Revision: 1.11 $   $Date: 2002/04/14 21:46:54 $ 

% Calls:  
% Called by: smile, axisfn

% Userdata Storage:    Current Asset Number     -> EditTextPremium
%                      Row # of asset to change -> PushButtonAdd
%                      Entire portfolio         -> Listbox1

if nargin < 2
   Input2 = [];
end

Output = [];

switch(action)
   
case 'Initialize'
   % Set axis size
   smilefn('Resize');
   smilefn('PlotPortfolio');
   
   % Setup windows
   set(findobj(gcbf,'Tag','EditTextPremium'),'Userdata',0);
   AssetSetup(0);   
   set(findobj(gcbf,'Tag','TextInfoWindow1'),'String',str2mat('Use the Edit menu to ','add a new investment.'),'ForegroundColor',[0 .5 0]);
   
   set(gcf,'Visible','on');
   
    
case 'Directions'
   Input2 = 1;
   
   % Use if you want different help window for each application
   if strcmp(lower(get(findobj(Input2,'Tag','PayoffMenu'),'Checked')),'on') == 1
      Output = ['  Payoff Diagram  '];
   elseif strcmp(lower(get(findobj(Input2,'Tag','ProbMenu'),'Checked')),'on') == 1
      Output = ['  Probability Diagram  '];
   elseif strcmp(lower(get(findobj(Input2,'Tag','HedgeMenu'),'Checked')),'on') == 1
      Output = ['  Hedging Diagram  '];
   else
      Output = '';
   end
   Output = '';
   Output = str2mat(Output, '                                       IMPLIED VOLATILITIES');
   Output = str2mat(Output, '','');
   Output = str2mat(Output, '   INTRODUCTION');
   Output = str2mat(Output, '   Given the underlying asset price, payout return, riskless return, premium,');
   Output = str2mat(Output, '   strike price, and years-to-expiration, the volatility of the underlying asset'); 
   Output = str2mat(Output, '   can found using the Black-Scholes equations.  This function uses a Newton''s');
   Output = str2mat(Output, '   search method to find the implied volatility.  The search iterates until the ');
   Output = str2mat(Output, '   computed Black-Scholes option price is within .1 cents of the premium (up to');
   Output = str2mat(Output, '   a maximum of 75 iterations).');
   Output = str2mat(Output, '','');
   Output = str2mat(Output, '   DIRECTIONS');
   Output = str2mat(Output, '   1. Input the 3 common factors needed to evaluate the volatility:');
   Output = str2mat(Output, '       a. Current price of the underlying asset (range = 0 to infinity)');
   Output = str2mat(Output, '       b. Annualized payout return on the underlying asset (range = 1 to infinity)');
   Output = str2mat(Output, '       c. Annualized riskless return (range = 1 to infinity)');
   Output = str2mat(Output, '   ');
   Output = str2mat(Output, '   2. Add new investments by selecting an asset type with the EDIT menu.');
   Output = str2mat(Output, '      There is no limit to the number of investments that one can add.');
   Output = str2mat(Output, '      The inputs for call or put options are the following.');
   Output = str2mat(Output, '      a.  Premium (range = -infinity to infinity)');
   Output = str2mat(Output, '      b.  Strike Price (range = 0 to infinity)');
   Output = str2mat(Output, '      c.  Years-To-Expiration (range = 0 to infinity)');
   Output = str2mat(Output, '      To delete the entire portfolio, use EDIT menu.  Any individual investment');
   Output = str2mat(Output, '      can be modified by selecting it in the listbox, then clicking on the modify');
   Output = str2mat(Output, '      pushbutton.  To cancel, click on any put or call the listbox.');
   Output = str2mat(Output, '');
   Output = str2mat(Output, '   3. Using the PLOT menu, select which assets to plot.');
   Output = str2mat(Output, '      a. Calls only');
   Output = str2mat(Output, '      b. Puts only');
   Output = str2mat(Output, '      c. Both calls and puts');
   Output = str2mat(Output, '');
   Output = str2mat(Output, '   4. Using the PLOT menu, select which Years-to-Expiration to plot.');
   Output = str2mat(Output, '      a. Same Years-to-Expiration');
   Output = str2mat(Output, '      b. All Years-to-Expiration');
   Output = str2mat(Output, '      When selecting all years-to-expiration, one line will be plotted.');
   Output = str2mat(Output, '      Green circles will designate calls and red squares will designate puts.');
   Output = str2mat(Output, '      When selecting the same years-to-expiration, one line for each ');
   Output = str2mat(Output, '      year-to-expiration will be plotted..');
   Output = str2mat(Output, '','');
   Output = str2mat(Output, '   EXAMPLES');
   Output = str2mat(Output, '   A 6 call, 6 put example can be graphed using the example menu.');
   Output = str2mat(Output, '','');
   Output = str2mat(Output, '   INPUT BOUNDS AND ERROR CHECKING');
   Output = str2mat(Output, '   Three different colors are used to signify the input status of a number.');
   Output = str2mat(Output, '   1. Black -> input is OK.');
   Output = str2mat(Output, '   2. Red   -> input is not recognizable (ex., strings or NaN are not allowed).');
   Output = str2mat(Output, '   3. Blue  -> input is out-of-bounds (ex., Rate of Return < 1).');
   Output = str2mat(Output, '');
   Output = str2mat(Output, '   Other errors, like a convergence problem of the Newton search, are');
   Output = str2mat(Output, '   reported in the text box in the lower right part of the display.');
   Output = str2mat(Output, '','');
   Output = str2mat(Output, '   THE AXIS MENU');
   Output = str2mat(Output, '   1. The axis tool is a graphic user interface for changing the axis.');
   Output = str2mat(Output, '   2. Turn the axis grid on/off');
   Output = str2mat(Output, '','');
   Output = str2mat(Output, '   SAVE AND RESTORE');
   Output = str2mat(Output, '   A portfolio can be saved and restored at a later time by using the FILE');
   Output = str2mat(Output, '   menu.  The only stipulation on the filename choice is that it must have');
   Output = str2mat(Output, '   a ".mat" extension.');
   Output = str2mat(Output, '');
   
case 'PlotPortfolio'
   VolatilityMatrix = get(findobj(gcf,'Tag','Listbox1'),'Userdata');
   PlotFlag = get(findobj(gcf,'Tag','PlotMenu'),'Userdata');
   
   % Plot a "Working ..." message 
   cla;
   grid off
   text(.5,.5,'Working  . . .','Units','Normalized','FontUnits','Points','FontSize',16,'Horizontalalignment','center');
   drawnow

   
   if ~isempty(VolatilityMatrix)
      % Check for input errors
      if isnan(getassetprice) | isnan(getassetreturn) | isnan(getrisklessreturn) 
         % Input error
         cla;
         LineHandle = [];
         
         % Report error to Info1
         set(findobj(gcf,'Tag','TextInfoWindow1'),'String','Portfolio not plotted due to input error.','ForegroundColor',[1 0 0]);            
         return;
      end

      plotimpliedvolatility(Input2)
      
   else
      % Defaut plot for no assets in the portfolio
      cla
      hold off
      LineHandle = [];
      
      % Plot zero input payoff diagram
      plot(0,0,'w');
      
      % Add grid?
      if strcmp(lower(get(findobj(gcf,'Tag','MenuGridOn'),'Checked')),'on') == 1
         grid on
      end
      
      xlabel('Strike Price / Asset Price','Color',[0 0 .5]);
      ylabel('% Implied Volatility ','Color',[0 0 .5]);
      
      % Update axis tool if it is open
      if strcmp(lower(get(findobj(gcf,'Tag','MenuAxisTool'),'Checked')),'on')==1
         AxesHandle = gca;
         axisfn('Initialize', gca, get(findobj(gcf,'Tag','MenuAxisTool'),'Userdata') );
         axes(AxesHandle);
      end
      
      % Info1 
      set(findobj(gcf,'Tag','TextInfoWindow1'),'String',str2mat('Use the Edit menu to ','add a new investment.'),'ForegroundColor',[0 .5 0]);            
      
   end   
   
case 'AddAsset'
   % Add/Change an asset to VolatilityMatrix
   % VolatilityMatrix(:,1) = AssetNumber (4-Call, 5-Put)
   % VolatilityMatrix(:,2) = Premium
   % VolatilityMatrix(:,3) = StrikePrice
   % VolatilityMatrix(:,4) = Years-to-expiration
   
   % Get asset matrix and number
   AssetNumber = get(findobj(gcbf,'Tag','EditTextPremium'),'Userdata');
   
   % Get/Check inputs 
   Premium = getpremium;
   StrikePrice = getstrikeprice;
   Expiration = getyearstoexpiration;

   if isnan(Premium) | isnan(StrikePrice) | isnan(Expiration)
      return
   else
      % Remove buttons
      AssetSetup(0);
      
      VolatilityMatrix = get(findobj(gcbf,'Tag','Listbox1'),'Userdata');
      VolatilityMatrixStr = get(findobj(gcbf,'Tag','Listbox1'),'String');
      
      % Check if in change mode. If so, remove the asset, then add the new one
      str = get(findobj(gcbf,'Tag','PushButtonAdd'),'String');
      if strcmp(str(1,1:3),'Cha') == 1
         N = get(findobj(gcbf,'Tag','PushButtonAdd'),'Userdata');
         VolatilityMatrix(N,:) = [];
         VolatilityMatrixStr(N,:) = [];
      end
      
      
      % Add asset
      VolatilityMatrix = [VolatilityMatrix; AssetNumber Premium StrikePrice Expiration];
      
      
      if AssetNumber == 4
         % Call
         NewStr = sprintf('Call: t=%.2f, K=$%.2f, C=$%.2f', Expiration, StrikePrice, Premium);
      elseif AssetNumber == 5
         % Put
         NewStr = sprintf('Put: t=%.2f, K=$%.2f, C=$%.2f', Expiration, StrikePrice, Premium);
      end
      
      VolatilityMatrixStr = strvcat(VolatilityMatrixStr, NewStr);         
      
      % Arrange portfolio in asset order
      [VolatilityMatrix,i]=sortrows(VolatilityMatrix,[1 4 3]);
      VolatilityMatrixStr = VolatilityMatrixStr(i,:);
      
      
      % Save and display portfolio
      set(findobj(gcbf,'Tag','Listbox1'),'Userdata',VolatilityMatrix);
      set(findobj(gcbf,'Tag','Listbox1'),'String',VolatilityMatrixStr);
      if ~isempty(VolatilityMatrix)
         set(findobj(gcbf,'Tag','Listbox1'),'Value',find(i==size(VolatilityMatrix,1)));
      end
      
      % Plot portfolio
      smilefn('PlotPortfolio');
      
      AssetSetup(0);
   end   
   
   
case 'ModifyAssetLine'
   % Get asset matrix
   VolatilityMatrix = get(findobj(gcbf,'Tag','Listbox1'),'Userdata');
   i = get(findobj(gcbf,'Tag','Listbox1'),'Value');
   
   % Setup Asset
   AssetSetup(VolatilityMatrix(i,1), VolatilityMatrix(i,2), VolatilityMatrix(i,3), VolatilityMatrix(i,4), i);   
   
   % Set listbox position
   set(findobj(gcbf,'Tag','Listbox1'),'Value',i);
   
   
case 'ChangeAssetLine'
   % Get the line handles
   LineHandle = get(gca,'Userdata');
   i = find(gcbo==LineHandle);
   set(findobj(gcbf,'Tag','Listbox1'),'Value',i);
   AssetSetup(0);
   
   
case 'ChangeAssetListbox'
   % Callback for listbox
   i = get(gcbo,'Value');
   AssetSetup(0);
   
   if strcmp(lower(get(findobj(gcf,'Tag','PlotMenu4'),'Checked')),'on')
      % Plot portfolio
      smilefn('PlotPortfolio');   
   end
   

case 'RemoveAsset'
   % Get asset matrix
   VolatilityMatrix = get(findobj(gcbf,'Tag','Listbox1'),'Userdata');
   VolatilityMatrixStr = get(findobj(gcbf,'Tag','Listbox1'),'String');
   
   % Remove Asset
   i = get(findobj(gcbf,'Tag','PushButtonAdd'),'Userdata');
   VolatilityMatrix(i,:) = [];
   VolatilityMatrixStr(i,:) = [];
      
   % Save and display portfolio
   set(findobj(gcbf,'Tag','Listbox1'),'Userdata',VolatilityMatrix);
   set(findobj(gcbf,'Tag','Listbox1'),'String',VolatilityMatrixStr);  
   
   % Move value up 1
   i = get(findobj(gcbf,'Tag','Listbox1'),'Value');
   if i-1 >= 1
      set(findobj(gcbf,'Tag','Listbox1'),'Value',i-1);
   end
   
   % Remove buttons
   AssetSetup(0);

   % Plot portfolio
   smilefn('PlotPortfolio');   
   
   
case 'AssetSetupZero'
   % Remove buttons
   AssetSetup(0);
   
case 'SelectAsset'
   % Go to add mode
   set(findobj(gcbf,'Tag','PushButtonAdd'),'String','Add');
   set(findobj(gcbf,'Tag','PushButtonRemove'),'Enable','Off');
   
   % Setup for the asset type
   AssetSetup(Input2);
   
 
case 'CheckInput'
   Output = getcheckinput(Input2);
   
   
case 'SavePortfolio'
   VolatilityMatrix = get(findobj(gcbf,'Tag','Listbox1'),'Userdata');
   VolatilityMatrixStr = get(findobj(gcbf,'Tag','Listbox1'),'String');
   if ~isempty(VolatilityMatrix)
      [FileName, FilePath] = uiputfile('*.mat', 'Save The Portfolio As (.mat extension)');
      if FileName~=0
         StartDir=pwd;eval(['cd ',FilePath]);
         eval(['save ',FileName,' VolatilityMatrix VolatilityMatrixStr']);
         eval(['cd ', StartDir]);
      end
   else
      set(findobj(gcbf,'Tag','TextInfoWindow1'),'String',str2mat('The portfolio is empty,','hence cannot be saved.'),'ForegroundColor',[1 0 0]);
   end
   
   
case 'LoadPortfolio'   
   [FileName, FilePath] = uigetfile('*.mat', 'Input A Portfolio File');
   if FileName~=0
      StartDir=pwd;eval(['cd ',FilePath]);
      eval(['load ',FileName]);
      if exist('VolatilityMatrix')==1 & exist('VolatilityMatrixStr')==1
         set(findobj(gcbf,'Tag','Listbox1'),'Userdata',VolatilityMatrix);
         set(findobj(gcbf,'Tag','Listbox1'),'String',VolatilityMatrixStr);  
         smilefn('PlotPortfolio');
      else
         set(findobj(gcbf,'Tag','TextInfoWindow1'),'String',str2mat('File did not contain','a proper portfolio.'),'ForegroundColor',[1 0 0]);
      end
      eval(['cd ', StartDir]);
   else
      set(findobj(gcbf,'Tag','TextInfoWindow1'),'String',str2mat('File not loaded.',' '),'ForegroundColor',[0 .5 0]);
   end
   
   
case 'Resize'
   WidthMin = 4.6;
   HeightMin = 3;
   
   UnitStr = get(gcbf,'Units');
   set(gcbf,'Units','Inches');
   FigSize = get(gcbf,'Position');
   
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
      set(gcbf,'Position',[FigX FigY FigWidth FigHeight]);
   end
   
   if FigHeight < HeightMin;
      FigHeight = HeightMin;
      FigY = FigY+FigSize(4)-HeightMin;
      if FigY < 0
         FigY = 0;
      end   
      set(gcbf,'Position',[FigX FigY FigWidth FigHeight]);
   end
   
   set(gcbf,'Units',UnitStr);
   
   % Get position of TextHeading and position axes
   UnitStr = get(findobj(gcbf,'Tag','TextPortfolioPrice'),'Units');
   set(findobj(gcbf,'Tag','TextPortfolioPrice'),'Units','Inches');
   HeadingSize = get(findobj(gcbf,'Tag','TextPortfolioPrice'),'Position');
   set(findobj(gcbf,'Tag','TextPortfolioPrice'),'Units',UnitStr);     
   
   WidthBufferLeft  = .7;  % was .6
   WidthBufferRight = .2;
   HeightBufferLower = .6;
   HeightBufferUpper = .25; % .1
   
   % Change axes size
   UnitStr = get(gca,'Units');
   set(gca,'Units','Inches');
   AxesSize = get(gca,'Position');
   p=[0+WidthBufferLeft HeadingSize(2)+HeadingSize(4)+HeightBufferLower FigWidth-WidthBufferRight-WidthBufferLeft FigHeight-(HeadingSize(2)+HeadingSize(4)+HeightBufferLower)-HeightBufferUpper];
   set(gca,'Position',p);
   set(gca,'Units',UnitStr);   
   
case 'GetInput'
   Output = getcheckinput(Input2);
   
case 'Example1' 
   % Set S,d,r
   AssetPrice = 100;
   set(findobj(gcf,'Tag','EditTextAssetPrice'),'String',sprintf('%.2f',AssetPrice));
   AssetReturn = 1;
   set(findobj(gcf,'Tag','EditTextAssetReturn'),'String',sprintf('%.2f',AssetReturn));
   RisklessReturn = 1.15;
   set(findobj(gcf,'Tag','EditTextRisklessReturn'),'String',sprintf('%.2f',RisklessReturn));
   
   % VolatilityMatrix
   % VolatilityMatrix(:,1) = AssetNumber (4-Call, 5-Put)
   % VolatilityMatrix(:,2) = Premium
   % VolatilityMatrix(:,3) = StrikePrice
   % VolatilityMatrix(:,4) = Years-to-expiration
   VolatilityMatrix = [ ...
			4 28.19 85 1; ...
         4 24.33 90 1; ...
         4 20.70 95 1; ...
         4 17.55 100 1; ...
         4 15.02 105 1; ...
         4 13.21 110 1; ...
         4 11.92 115 1; ...
			5 2.10 85 1; ...
         5 2.70 90 1; ...
         5 3.52 95 1; ...
         5 4.82 100 1; ...
         5 6.60 105 1; ...
         5 9.05 110 1; ...
         5 11.92 115 1];
   VolatilityMatrixStr =[];
   for i = 1:size(VolatilityMatrix,1)
      if VolatilityMatrix(i,1) == 4
         % Call
         NewStr = sprintf('Call: t=%.2f, K=$%.2f, C=$%.2f', VolatilityMatrix(i,4), VolatilityMatrix(i,3), VolatilityMatrix(i,2));
      elseif VolatilityMatrix(i,1) == 5
         % Put
         NewStr = sprintf('Put: t=%.2f, K=$%.2f, P=$%.2f', VolatilityMatrix(i,4), VolatilityMatrix(i,3), VolatilityMatrix(i,2));
      end
      
      VolatilityMatrixStr = strvcat(VolatilityMatrixStr, NewStr);         
   end
   
   % Arrange portfolio in asset order
   [VolatilityMatrix,i]=sortrows(VolatilityMatrix,[1 4 3]);
   VolatilityMatrixStr = VolatilityMatrixStr(i,:);
   
   
   % Save and display portfolio
   set(findobj(gcf,'Tag','Listbox1'),'Userdata',VolatilityMatrix);
   set(findobj(gcf,'Tag','Listbox1'),'String',VolatilityMatrixStr);
   set(findobj(gcf,'Tag','Listbox1'),'value',1);
   
   
   % Plot portfolio
   smilefn('PlotPortfolio');
      
   AssetSetup(0);

end
% End switch



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Main input checking function %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function Value = getcheckinput(tag);
Value = str2double(get(findobj(gcf,'Tag',tag),'string'));

if isempty(Value) | isnan(Value) | isinf(Value) | ~isreal(Value) | any(size(Value)~=[1 1]) 
   Value = NaN;
   set(findobj(gcf,'Tag',tag(5:length(tag))),'ForegroundColor',[1 0 0]);
else
   % Special case input checking
   AssetNumber = get(findobj(gcbf,'Tag','EditTextPremium'),'Userdata');
   
   % Edit inputs
   if strcmp(tag,'EditTextPremium')==1
      %if Value==0
      %   Value = NaN;
      %   set(findobj(gcf,'Tag',tag(5:length(tag))),'ForegroundColor',[0 0 1]);
      %else
         Value = round(Value*100)/100;
         set(findobj(gcf,'Tag',tag),'string',num2str(Value));
      %end
   end
   
   if strcmp(tag,'EditTextStrikePrice')==1
      if Value<=0
         Value = NaN;
         set(findobj(gcf,'Tag',tag(5:length(tag))),'ForegroundColor',[0 0 1]);
      else
         Value = round(Value*100)/100;
         set(findobj(gcf,'Tag',tag),'string',num2str(Value));
      end
   end

   % Common inputs
   if strcmp(tag,'EditTextAssetPrice')==1
      if Value<=0
         Value = NaN;
         set(findobj(gcf,'Tag',tag(5:length(tag))),'ForegroundColor',[0 0 1]);
      else
         Value = round(Value*100)/100;
         set(findobj(gcf,'Tag',tag),'string',num2str(Value(1,:)));
      end
   end
   
   if strcmp(tag,'EditTextAssetReturn')==1 & Value<1
      Value = NaN;
      set(findobj(gcf,'Tag',tag(5:length(tag))),'ForegroundColor',[0 0 1]);
   end
   
   if strcmp(tag,'EditTextRisklessReturn')==1 & Value<1
      Value = NaN;
      set(findobj(gcf,'Tag',tag(5:length(tag))),'ForegroundColor',[0 0 1]);
   end
   
   if strcmp(tag,'EditTextExpiration')==1 & Value<=0
      Value = NaN;
      set(findobj(gcf,'Tag',tag(5:length(tag))),'ForegroundColor',[0 0 1]);
   end
   
   if strcmp(tag,'EditTextVolatility')==1 & Value<=0
      Value = NaN;
      set(findobj(gcf,'Tag',tag(5:length(tag))),'ForegroundColor',[0 0 1]);
   end
end

if ~isnan(Value)
   set(findobj(gcf,'Tag',tag(5:length(tag))),'ForegroundColor',[0 0 0]);
end
%End function


function AssetSetup(AssetNumber, Premium, StrikePrice, Expiration, ChangeAssetRow)
if nargin < 2
   Premium = 0;
end
if nargin < 3
   % Default strike price
   StrikePrice = getassetprice;
end

if nargin < 4
   % Default years-to-expiration
   Expiration = 1;
end

if nargin < 5
   % Default: add mode
   ChangeAssetRow = 0;
end


% Get asset matrix
VolatilityMatrix = get(findobj(gcbf,'Tag','Listbox1'),'Userdata');


% Put asset number in userdata
set(findobj(gcbf,'Tag','EditTextPremium'),'Userdata',AssetNumber);

set(findobj(gcbf,'Tag','Listbox1'),'Units','points');
if AssetNumber==1 | AssetNumber==2 | AssetNumber==3 | AssetNumber==4 | AssetNumber==5
   % Shrink Listbox1
   set(findobj(gcbf,'Tag','Listbox1'),'position',[10 48 144.5+10 36]);
   
   % Setup Modify button
   set(findobj(gcbf,'Tag','PushButtonModify'),'Visible','Off');
else
   % Enlarge Listbox1
   set(findobj(gcbf,'Tag','Listbox1'),'position',[10 17 144.5+10 67]);
   
   % Setup Modify button
   set(findobj(gcbf,'Tag','PushButtonModify'),'Visible','On');
   if isempty(VolatilityMatrix)
      set(findobj(gcbf,'Tag','PushButtonModify'),'Enable','Off');
      set(findobj(gcbf,'Tag','PushButtonModify'),'String','Modify');
   else
      set(findobj(gcbf,'Tag','PushButtonModify'),'Enable','On');
      i = get(findobj(gcbf,'Tag','Listbox1'),'Value');
      if VolatilityMatrix(i,1) == 4
         set(findobj(gcbf,'Tag','PushButtonModify'),'String',sprintf('Modify Call, t=%.2f, K=$%.2f', VolatilityMatrix(i,4), VolatilityMatrix(i,3)));
      elseif VolatilityMatrix(i,1) == 5
         set(findobj(gcbf,'Tag','PushButtonModify'),'String',sprintf('Modify Put, t=%.2f, K=$%.2f', VolatilityMatrix(i,4), VolatilityMatrix(i,3)));
      else
         set(findobj(gcbf,'Tag','PushButtonModify'),'String','Modify');
      end
   end
end

% Set starting point for inputs
set(findobj(gcbf,'Tag','EditTextPremium'),'string',num2str(Premium));
set(findobj(gcbf,'Tag','EditTextStrikePrice'),'string',num2str(StrikePrice));
set(findobj(gcbf,'Tag','EditTextExpiration'),'string',num2str(Expiration));


% Set visibility on/off
set(findobj(gcbf,'Tag','PushButtonAdd'),'Visible','On');
set(findobj(gcbf,'Tag','PushButtonCancel'),'Visible','On');
set(findobj(gcbf,'Tag','PushButtonRemove'),'Visible','Off');
set(findobj(gcbf,'Tag','TextPremium'),'Visible','On');
set(findobj(gcbf,'Tag','EditTextPremium'),'Visible','On');
%set(findobj(gcbf,'Tag','TextInfoWindow1'),'Visible','Off');

if AssetNumber == 1
   % Stock
   set(findobj(gcbf,'Tag','TextStrikePrice'),'Visible','Off');
   set(findobj(gcbf,'Tag','EditTextStrikePrice'),'Visible','Off');
   set(findobj(gcbf,'Tag','EditTextStrikePrice'),'String','-1');
   
   set(findobj(gcbf,'Tag','PushButtonAdd'),'String','Add Asset');
   set(findobj(gcbf,'Tag','TextPremium'),'String','Units (long (+), short(-))');
   
elseif AssetNumber == 2
   % borrow
   set(findobj(gcbf,'Tag','TextStrikePrice'),'Visible','Off');
   set(findobj(gcbf,'Tag','EditTextStrikePrice'),'Visible','Off');
   set(findobj(gcbf,'Tag','EditTextStrikePrice'),'String','-1');
   
   set(findobj(gcbf,'Tag','PushButtonAdd'),'String','Add Cash');
   set(findobj(gcbf,'Tag','TextPremium'),'String','$ (Lend (+), Borrow (-))');
   
elseif AssetNumber == 3
   % Forward
   set(findobj(gcbf,'Tag','TextStrikePrice'),'Visible','Off');
   set(findobj(gcbf,'Tag','EditTextStrikePrice'),'Visible','Off');   
   set(findobj(gcbf,'Tag','EditTextStrikePrice'),'String','-1');
   
   set(findobj(gcbf,'Tag','PushButtonAdd'),'String','Add Forward');
   set(findobj(gcbf,'Tag','TextPremium'),'String','Premium');
   set(findobj(gcbf,'Tag','TextStrikePrice'),'String','Delivery Price');
elseif AssetNumber == 4
   % Call
   set(findobj(gcbf,'Tag','TextPremium'),'Visible','On');
   set(findobj(gcbf,'Tag','EditTextPremium'),'Visible','On');
   set(findobj(gcbf,'Tag','TextStrikePrice'),'Visible','On');
   set(findobj(gcbf,'Tag','EditTextStrikePrice'),'Visible','On');
   set(findobj(gcbf,'Tag','TextExpiration'),'Visible','On');
   set(findobj(gcbf,'Tag','EditTextExpiration'),'Visible','On');
   
   set(findobj(gcbf,'Tag','PushButtonAdd'),'String','Add Call');
   set(findobj(gcbf,'Tag','TextStrikePrice'),'String','Strike Price');
   set(findobj(gcbf,'Tag','TextPremium'),'String','Premium');
   
elseif AssetNumber == 5
   % Put
   set(findobj(gcbf,'Tag','TextPremium'),'Visible','On');
   set(findobj(gcbf,'Tag','EditTextPremium'),'Visible','On');
   set(findobj(gcbf,'Tag','TextStrikePrice'),'Visible','On');
   set(findobj(gcbf,'Tag','EditTextStrikePrice'),'Visible','On');
   set(findobj(gcbf,'Tag','TextExpiration'),'Visible','On');
   set(findobj(gcbf,'Tag','EditTextExpiration'),'Visible','On');
   
   set(findobj(gcbf,'Tag','PushButtonAdd'),'String','Add Put');
   set(findobj(gcbf,'Tag','TextStrikePrice'),'String','Strike Price');
   set(findobj(gcbf,'Tag','TextPremium'),'String','Premium');
   
else
   % No asset
   set(findobj(gcbf,'Tag','PushButtonAdd'),'Visible','Off');
   set(findobj(gcbf,'Tag','PushButtonRemove'),'Visible','Off');
   set(findobj(gcbf,'Tag','PushButtonCancel'),'Visible','Off');
   set(findobj(gcbf,'Tag','TextPremium'),'Visible','Off');
   set(findobj(gcbf,'Tag','EditTextPremium'),'Visible','Off');
   set(findobj(gcbf,'Tag','TextStrikePrice'),'Visible','Off');
   set(findobj(gcbf,'Tag','EditTextStrikePrice'),'Visible','Off');
   set(findobj(gcbf,'Tag','TextExpiration'),'Visible','Off');
   set(findobj(gcbf,'Tag','EditTextExpiration'),'Visible','Off');
 %  set(findobj(gcbf,'Tag','TextInfoWindow1'),'Visible','On');   
end
   
   
% For asset numbers 1,2,and 3, change amount if the asset currently exists
if AssetNumber==1 | AssetNumber==2 | AssetNumber==3
      
   % If the asset already exists, just change it
   if isempty(VolatilityMatrix)
      ii = [];
   else
      ii = find(VolatilityMatrix(:,1)==AssetNumber);
   end
   
   if ~isempty(ii)
      % Change asset
      ChangeAssetRow = ii;
      set(findobj(gcbf,'Tag','EditTextPremium'),'String',num2str(VolatilityMatrix(ii,2)));
   end
end

if ChangeAssetRow > 0
   % Go to change mode
   if AssetNumber==1
      set(findobj(gcbf,'Tag','PushButtonAdd'),'String','Change Asset');
   elseif AssetNumber==2
      set(findobj(gcbf,'Tag','PushButtonAdd'),'String','Change Cash');
   elseif AssetNumber==3
      set(findobj(gcbf,'Tag','PushButtonAdd'),'String','Change Forward');
   elseif AssetNumber==4
      set(findobj(gcbf,'Tag','PushButtonAdd'),'String','Change Call');
   elseif AssetNumber==5
      set(findobj(gcbf,'Tag','PushButtonAdd'),'String','Change Put');
   end
   
   set(findobj(gcbf,'Tag','PushButtonAdd'),'Userdata',ChangeAssetRow);
   set(findobj(gcbf,'Tag','PushButtonRemove'),'Enable','On');
   set(findobj(gcbf,'Tag','PushButtonRemove'),'Visible','On');
   set(findobj(gcbf,'Tag','PushButtonCancel'),'Visible','Off');
   
   % Shrink add-button size
   %set(findobj(gcbf,'Tag','PushButtonAdd'),'position',[10 36 97 12]);
else
   % Enlarge add-button size
   %set(findobj(gcbf,'Tag','PushButtonAdd'),'position',[10 36 144.5 12]);
   %set(findobj(gcbf,'Tag','PushButtonAdd'),'position',[10 36 97 12]);
   
   % Enable cancel button
   set(findobj(gcbf,'Tag','PushButtonCancel'),'Enable','On');
end

% Varify that inputs are correct and text color is correct
getpremium;
getstrikeprice;
getyearstoexpiration;
pause(0);
% End Function



%%%%%%%%%%%%%%%%%%%
% Input Functions %
%%%%%%%%%%%%%%%%%%%

% Fixed inputs
function AssetPrice = getassetprice
AssetPrice = getcheckinput('EditTextAssetPrice');
% End Function


function AssetReturn = getassetreturn
AssetReturn = getcheckinput('EditTextAssetReturn');
% End Function


function RisklessReturn = getrisklessreturn
RisklessReturn = getcheckinput('EditTextRisklessReturn');
% End Function


function Expiration = getyearstoexpiration
Expiration = getcheckinput('EditTextExpiration');
% End Function


function Volatility = getvolatility
Volatility = 1.2222;
% End Function


% Asset input functions
function Premium = getpremium
Premium = getcheckinput('EditTextPremium');
% End Function


function StrikePrice = getstrikeprice
StrikePrice = getcheckinput('EditTextStrikePrice');
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




%%%%%%%%%%%%%%%%%%%%%%
% Plotting Functions %
%%%%%%%%%%%%%%%%%%%%%%

function plotimpliedvolatility(Input1)
set(findobj(gcf,'Tag','TextInfoWindow1'),'String','Computing the implied volatilities.','ForegroundColor',[0 .5 0]);
pause(0);
   
VolatilityMatrix = get(findobj(gcf,'Tag','Listbox1'),'Userdata');
SelectedAsset = get(findobj(gcbf,'Tag','Listbox1'),'Value');
SelectedAssetExpiration = VolatilityMatrix(SelectedAsset,4);

% Plot payoff diagram         
cla;
hold off;
LineHandle = [];

StockPrice = getassetprice;
AssetReturn = getassetreturn;
RisklessReturn = getrisklessreturn;


% VolatilityMatrix(:,1) = AssetNumber (4-Call, 5-Put)
% VolatilityMatrix(:,2) = Premium
% VolatilityMatrix(:,3) = StrikePrice
% VolatilityMatrix(:,4) = Years-to-expiration

if strcmp(lower(get(findobj(gcf,'Tag','PlotMenu1'),'Checked')),'on')
   % Call only
   i = find(VolatilityMatrix(:,1)==5);
   VolatilityMatrix(i,:) = [];
   MessageStr = 'calls';
elseif strcmp(lower(get(findobj(gcf,'Tag','PlotMenu2'),'Checked')),'on')
   % Puts only
   i = find(VolatilityMatrix(:,1)==4);
   VolatilityMatrix(i,:) = [];
   MessageStr = 'puts';
else
   % Both calls and puts
   MessageStr = 'assets';
end

if isempty(VolatilityMatrix)
   plot(0, 0, 'w');
   xlabel('Strike Price / Asset Price','Color',[0 0 .5]);
   ylabel('% Implied Volatility ','Color',[0 0 .5]);
   set(findobj(gcf,'Tag','TextInfoWindow1'),'String',str2mat('No assets to plot.'),'ForegroundColor',[1 0 0]); 
   return
end


if strcmp(lower(get(findobj(gcf,'Tag','PlotMenu4'),'Checked')),'on')
   % Plot only assets with the same years-to-expiration as the selected asset
%   i = find(VolatilityMatrix(:,4)==SelectedAssetExpiration);
%   VolatilityMatrix = VolatilityMatrix(i,:);   
else
   % All years-to-expiration
end

if isempty(VolatilityMatrix)
   plot(0, 0, 'w');
   xlabel('Strike Price / Asset Price','Color',[0 0 .5]);
   ylabel('% Implied Volatility ','Color',[0 0 .5]);
   set(findobj(gcf,'Tag','TextInfoWindow1'),'String',str2mat('No assets to plot.'),'ForegroundColor',[1 0 0]); 
   return
end


% Arrange portfolio in asset order of strike price
[VolatilityMatrix,i] = sortrows(VolatilityMatrix, 3);
x = VolatilityMatrix(:,3);

icall = find(VolatilityMatrix(:,1)==4);
iput  = find(VolatilityMatrix(:,1)==5);

if isempty(icall)
   volatilitycall = [];
   xcall = [];
else
   volatilitycall = blsimpvcall(StockPrice, VolatilityMatrix(icall,3), log(RisklessReturn), VolatilityMatrix(icall,4), VolatilityMatrix(icall,2), log(AssetReturn));
   xcall = x(icall);
   plot(xcall/StockPrice, 100*volatilitycall, 'o','color',[0 .75 0]);
   hold on
end
if isempty(iput)
   volatilityput = [];
   xput = [];
else
   volatilityput = blsimpvput(StockPrice, VolatilityMatrix(iput,3), log(RisklessReturn), VolatilityMatrix(iput,4), VolatilityMatrix(iput,2), log(AssetReturn));
   xput = x(iput);
   plot(xput/StockPrice, 100*volatilityput, 'sr');
   hold on
end
volatility = [volatilitycall; volatilityput];
xtotal = [xcall; xput];
Exptotal = [VolatilityMatrix(icall,4); VolatilityMatrix(iput,4)];
[x,i] = sortrows(xtotal);
volatility = volatility(i);
Exptotal = Exptotal(i);


% Check for errors
ErrorNumber = 0;
if any(isnan(volatility))
   i = find(isnan(volatility)==1);
   x(i) = [];
   volatility(i) = [];
   Exptotal(i) = [];
   ErrorNumber = length(i);
end


% Plot
if length(x) > 0
   if strcmp(lower(get(findobj(gcf,'Tag','PlotMenu4'),'Checked')),'on')
      % Plot only assets with the same years-to-expiration as the selected asset
      j = Exptotal;
      k = 1;
      while any(isfinite(j))
         i = find(Exptotal==Exptotal(k));
         if ~isempty(i)
            %            plot(x(i)/StockPrice, 100*volatility(i), 'Color',[.4 0 0],'LineWidth',1.2);
            ColorOrderMatrix = get(gca,'colororder');
            plot(x(i)/StockPrice, 100*volatility(i), 'Color',ColorOrderMatrix(k,:), 'LineWidth',1.2);
            axis tight
         end
         j(i) = NaN;
         k = k + 1;
      end      
   else
      % All years-to-expiration
      plot(x/StockPrice, 100*volatility, 'LineWidth',1.2);
      %plot(x/StockPrice, 100*volatility, 'Color',[.4 0 0],'LineWidth',1.2);
      axis tight
   end
   
else
   hold off
   plot(0, 0, 'w');
   ErrorNumber = -1;
end

xlabel('Strike Price / Asset Price','Color',[0 0 .5]);
if strcmp(lower(get(findobj(gcf,'Tag','PlotMenu1'),'Checked')),'on')
   ylabel('% Implied Volatility (Calls Only)','Color',[0 0 .5]);
elseif strcmp(lower(get(findobj(gcf,'Tag','PlotMenu2'),'Checked')),'on')
   ylabel('% Implied Volatility (Puts Only)','Color',[0 0 .5]);
else
   ylabel('% Implied Volatility ','Color',[0 0 .5]);   
end


% Set axis
if ~isempty(Input1)
   if length(Input1) >= 4
      axis([Input1(1) Input1(2) Input1(3) Input1(4)]);
   end
else
   % Expand the axis a little
   a = axis;
      p = .05;
      
      a1 = a(1);
      a2 = a(2);
      a(1) = a(1) - p*abs(a2-a1);
      a(2) = a(2) + p*abs(a2-a1);
      
      a3 = a(3);
      a4 = a(4);
      a(3) = a(3) - p*abs(a4-a3);
      a(4) = a(4) + p*abs(a4-a3);
      axis([a(1) a(2) a(3) a(4)])
      
   % Update axis tool if it is open
   if strcmp(lower(get(findobj(gcf,'Tag','MenuAxisTool'),'Checked')),'on')==1
      AxesHandle = gca;
      axisfn('Initialize', gca, get(findobj(gcf,'Tag','MenuAxisTool'),'Userdata') );
      axes(AxesHandle);
   end
end

% Add grid
if strcmp(lower(get(findobj(gcf,'Tag','MenuGridOn'),'Checked')),'on')==1
   grid on
end

hold off
drawnow

% Info1
if ErrorNumber > 0
   set(findobj(gcf,'Tag','TextInfoWindow1'),'String',str2mat('The implied volatilities could not',['be found for ',num2str(ErrorNumber),' of the ',MessageStr,'.']),'ForegroundColor',[0 .5 0]);
elseif ErrorNumber == -1
   set(findobj(gcf,'Tag','TextInfoWindow1'),'String',str2mat('The implied volatilities could not',[' be found for any of the ',MessageStr,'.']),'ForegroundColor',[0 .5 0]);
elseif size(VolatilityMatrix,1) == 1
   set(findobj(gcf,'Tag','TextInfoWindow1'),'String',str2mat('Use the Edit menu to ','add a new investment.'),'ForegroundColor',[0 .5 0]); 
else
   set(findobj(gcf,'Tag','TextInfoWindow1'),'String',str2mat('Click on the portfolio list ','  to select an investment.'),'ForegroundColor',[0 .5 0]);
end
pause(0);
% End function


function [sig, err, i] = blsimpvcall(so,x,r,t,call,q,maxiter,tol) 
%BLSIMPV1 Black-Scholes implied volatility. 
%       [V, err, NITER] = BLSIMPV1(SO,X,R,T,CALL,Q,MAXITER,TOL) returns the implied
%       volatility of an underlying asset given the current asset price SO,
%       the exercise price X, the risk free interest rate R, the time to
%       maturity in years T, the call option value call, and Q is the
%       dividend rate of the asset.  The default Q is 0.  This function
%       solves for the implied volatility V, using Newton-Raphson method.
%       MAXITER is the maximum number of iterations used in solving for V.  By
%       default, MAXITER = 50.
%       
%
 
if nargin < 5 
  error('Missing one of SO, X, R, T, and Call.') 
end 

if nargin < 6 
  q = zeros(size(so)); 
end

if nargin < 7
  maxiter = 75;         % Maximum number of iterations 
end 
 
if nargin < 8
   tol = .001;           % Toloerance on search (in dollars)
end 

err = 0;

sig = .2*ones(size(so));      % Initialize volatility, delta, and iteration count 
Price = blsprice(so,x,r,t,sig,q);
sig = .2*ones(size(Price));   % just so that sig is dimensioned properly 

% Using Newton's method to solve for implied volatility 
for i = 1:maxiter
  Vega = blsvega(so,x,r,t,sig,q);
  if any(Vega == 0)
     j = find(Vega == 0);
     Vega(j) = eps;
     sig = sig - (Price-call)./Vega;
     
     if length(call) == 1
        sig(j) = sig(j) - (Price(j)-call)./10000;
     else
        sig(j) = sig(j) - (Price(j)-call(j))./10000;
     end
  else
     sig = sig - (Price-call)./Vega;
  end
  
  if any(sig <= 0)
     j = find(sig <= 0);
     sig(j) = eps;
  end
  
  Price = blsprice(so,x,r,t,sig,q); 
  if all(abs(Price-call) < tol) 
     % Round off sig to .001
     sig = round(1000*sig)/1000;
     return 
  end 
end 

if i == maxiter 
   err = 1;
   j = find(abs(Price-call) > tol);
   sig(j) = NaN;
end

% Round off sig to .001
sig = round(1000*sig)/1000;


function [sig, err, i] = blsimpvput(so,x,r,t,put,q,maxiter,tol) 
 
if nargin < 5 
  error('Missing one of SO, X, R, T, and Put.') 
end 

if nargin < 6 
  q = zeros(size(so)); 
end

if nargin < 7
  maxiter = 75;         % Maximum number of iterations 
end 
 
if nargin < 8
   tol = .001;           % Toloerance on search (in dollars)
end 

err = 0;

sig = .2*ones(size(so));      % Initialize volatility, delta, and iteration count 
[tmp, Price] = blsprice(so,x,r,t,sig,q);
sig = .2*ones(size(Price));   % just so that sig is dimensioned properly 

% Using Newton's method to solve for implied volatility 
for i = 1:maxiter
  Vega = blsvega(so,x,r,t,sig,q);
  if any(Vega == 0)
     j = find(Vega == 0);
     Vega(j) = eps;
     sig = sig - (Price-put)./Vega;
     
     if length(put) == 1
        sig(j) = sig(j) - (Price(j)-put)./10000;
     else
        sig(j) = sig(j) - (Price(j)-put(j))./10000;
     end
  else
     sig = sig - (Price-put)./Vega;
  end
  
  if any(sig <= 0)
     j = find(sig <= 0);
     sig(j) = eps;
  end
  
  [tmp,Price] = blsprice(so,x,r,t,sig,q); 
  if all(abs(Price-put) < tol) 
     % Round off sig to .001
     sig = round(1000*sig)/1000;
     return 
  end 
end 

if i == maxiter 
   err = 1;
   j = find(abs(Price-put) > tol);
   sig(j) = NaN;
end

% Round off sig to .001
sig = round(1000*sig)/1000;
