function Output = payofffn(action, Input2)
%PAYOFFFN Switchyard function for the profit/loss GUI PAYOFF.
%
%   Output = payofffn(action, Input2)
%

% Created by Greg Portmann (May 1997)

%       Copyright 1995-2002 The MathWorks, Inc. 
%       $Revision: 1.9 $   $Date: 2002/04/14 21:45:52 $ 

% Calls:  
% Called by: payoff, axisfn

% Userdata Storage:    Current Asset Number     -> EditTextNumShares
%                      Row # of asset to change -> PushButtonAdd
%                      Entire portfolio         -> Listbox1

if nargin < 2
   Input2 = [];
end

Output = [];

switch(action)
   
case 'Initialize'
   % Set axis size
   payofffn('Resize');
   payofffn('PlotPortfolio');
   
   % Setup windows
   set(findobj(gcbf,'Tag','EditTextNumShares'),'Userdata',0);
   AssetSetup(0);   
   set(findobj(gcbf,'Tag','TextInfoWindow1'),'String',str2mat('Use the Edit menu to ','add a new investment.'),'ForegroundColor',[0 .5 0]);            
   
   set(gcf,'Visible','on');
      

case 'Directions'
   Input2 = 1;
   
   % Use if you want different help window for each application
   %if strcmp(lower(get(findobj(Input2,'Tag','PayoffMenu'),'Checked')),'on') == 1
   %   Output = ['  Payoff Diagram  '];
   %elseif strcmp(lower(get(findobj(Input2,'Tag','ProbMenu'),'Checked')),'on') == 1
   %   Output = ['  Probability Diagram  '];
   %elseif strcmp(lower(get(findobj(Input2,'Tag','HedgeMenu'),'Checked')),'on') == 1
   %   Output = ['  Hedging Diagram  '];
   %else
   %   Output = '';
   %end
   
   Output = '';
   Output = str2mat(Output, '           EVALUATING AND PRICING A PORTFOLIO OF OPTIONS');
   Output = str2mat(Output, '                        WITH A COMMON YEARS-TO-EXPIRATION');
   Output = str2mat(Output, '                                       (Using Black-Scholes)');
   Output = str2mat(Output, '','');
   Output = str2mat(Output, '   INTRODUCTION');
   Output = str2mat(Output, '   This application is designed to evaluate a portfolio of calls, puts, cash,');
   Output = str2mat(Output, '   forwards, and the underlying asset.  The call and puts options are valued ');
   Output = str2mat(Output, '   using the Black-Scholes formula.  There are four type of displays.',' ');
   Output = str2mat(Output, '                                Profit/Loss Diagram');
   Output = str2mat(Output, '                                Probability Function');
   Output = str2mat(Output, '                                Cumulative Distribution Function (CDF)');
   Output = str2mat(Output, '                                Hedging Diagram');
   Output = str2mat(Output, '   ');
   Output = str2mat(Output, '   ');
   Output = str2mat(Output, '   DIRECTIONS');
   Output = str2mat(Output, '   1. Input the 5 common factors needed to evaluate the portfolio value:');
   Output = str2mat(Output, '       a. Current price of the underlying asset (range = 0 to infinity)');
   Output = str2mat(Output, '       b. Annualized payout return on the underlying asset (range = 1 to infinity)');
   Output = str2mat(Output, '       c. Annualized riskless return (range = 1 to infinity)');
   Output = str2mat(Output, '       d. Years-to-expiration (range = 0 to infinity)');
   Output = str2mat(Output, '       e. Annualized volatility of the underlying asset (range = 0 to infinity)');
   Output = str2mat(Output, '');
   Output = str2mat(Output, '   2. Add new investments by selecting an asset type with the EDIT menu.');
   Output = str2mat(Output, '      There is no limit to the number of investments that one can add.');
   Output = str2mat(Output, '      The five types of investments are the following.');
   Output = str2mat(Output, '      a. Asset -> The underlying asset. ');
   Output = str2mat(Output, '                        Plot color: blue');
   Output = str2mat(Output, '                        + long, - short');
   Output = str2mat(Output, '                        The number of shares cannot equal zero and will');
   Output = str2mat(Output, '                        be rounded to nearest share.  Once added to the');
   Output = str2mat(Output, '                        portfolio, one can only change the number of');
   Output = str2mat(Output, '                        shares held.');
   Output = str2mat(Output, '      b. Cash  -> Dollars invested at the riskless rate');
   Output = str2mat(Output, '                        Plot color: magenta');
   Output = str2mat(Output, '                        + lend, - borrow');
   Output = str2mat(Output, '                        The amount of cash cannot equal zero and will');
   Output = str2mat(Output, '                        be rounded to the nearest cent.');
   Output = str2mat(Output, '      c. Forward -> Forward contracts in the underlying asset');
   Output = str2mat(Output, '                            Plot color: cyan');
   Output = str2mat(Output, '                            + long, - short');
   Output = str2mat(Output, '                            The number of contracts cannot equal zero');
   Output = str2mat(Output, '                            and will be rounded to nearest contract.');
   Output = str2mat(Output, '                            Once added to the portfolio, one can only');
   Output = str2mat(Output, '                            change the number of contracts held.');
   Output = str2mat(Output, '      d. Calls -> Call contracts in the underlying asset');
   Output = str2mat(Output, '                       Plot color: green');
   Output = str2mat(Output, '                       + long, - short');
   Output = str2mat(Output, '                       The number of contracts cannot equal zero');
   Output = str2mat(Output, '                       and will be rounded to nearest contract.');
   Output = str2mat(Output, '                       The strike price range is 0 to infinity.');
   Output = str2mat(Output, '      e. Puts -> Put contracts in the underlying asset');
   Output = str2mat(Output, '                      Plot color: red');
   Output = str2mat(Output, '                      + long, - short');
   Output = str2mat(Output, '                      The number of contracts cannot equal zero');
   Output = str2mat(Output, '                      and will be rounded to nearest contract.');
   Output = str2mat(Output, '                      The strike price range is 0 to infinity.');
   Output = str2mat(Output, '      To delete the entire portfolio, use EDIT menu.  Any individual investment');
   Output = str2mat(Output, '      can be modified by selecting it in the listbox, then clicking on the modify');
   Output = str2mat(Output, '      pushbutton.  Note: for 2-D plots, clicking on a plotted line also selects the');
   Output = str2mat(Output, '      investment.');
   Output = str2mat(Output, '');
   Output = str2mat(Output, '   3. Using the PLOT menu, select the display type.');
   Output = str2mat(Output, '      a. Profit/Loss Diagram');
   Output = str2mat(Output, '      b. Probability Function:  stair case plot of the probability that the profit/loss');
   Output = str2mat(Output, '                                            will be within the width of the each stair.');
   Output = str2mat(Output, '      c. Cumulative Distribution Function (CDF)');
   Output = str2mat(Output, '      d. Hedging Diagram');
   Output = str2mat(Output, '');
   Output = str2mat(Output, '   4. Using the PLOT menu, select whether or not to plot the total portfolio.');
   Output = str2mat(Output, '      The total portfolio is plotted in brown.');
   Output = str2mat(Output, '');
   Output = str2mat(Output, '   5. Using the PLOT menu, select which time value of money to use.');
   Output = str2mat(Output, '      In order to compute the payoff, the value of the portfolio at the final time');
   Output = str2mat(Output, '      is subtracted from the initial time.');
   Output = str2mat(Output, '      a. Mixed   - the dollar value of the portfolio at the Years-to-Expiration is substracted');
   Output = str2mat(Output, '                         from the initial portfolio value (ignoring the time value difference).');
   Output = str2mat(Output, '      b. Present - all dollars values converted to the present value, then substracted.');
   Output = str2mat(Output, '      c. Future  - all dollars values converted to the future  value, then substracted.');
   Output = str2mat(Output, '');
   Output = str2mat(Output, '   For the hedging diagram,');   
   Output = str2mat(Output, '   the variables displayed in the graph are determined by the equation z = f(x,y).');
   Output = str2mat(Output, '   6. Select the dependent variable, z, for the graph.');
   Output = str2mat(Output, '       a. Value of the option');
   Output = str2mat(Output, '       b. Delta of the option');
   Output = str2mat(Output, '       c. Gamma of the option');
   Output = str2mat(Output, '       d. Theta of the option');
   Output = str2mat(Output, '       e. Vega of the option');
   Output = str2mat(Output, '       f. Rho of the option');
   Output = str2mat(Output, '       g. Omega of the option (Black-Scholes elasticity)',' ');
   Output = str2mat(Output, '   7. Select the independent variables, x and y, for the graph.');
   Output = str2mat(Output, '       a. Current price of the underlying asset');
   Output = str2mat(Output, '       b. Annualized payout return of the underlying asset');
   Output = str2mat(Output, '       c. Annualized riskless return');
   Output = str2mat(Output, '       d. Years-to-expiration');
   Output = str2mat(Output, '       e. Annualized volatility of the underlying asset');
   Output = str2mat(Output, '       f. Strike price');
   Output = str2mat(Output, '       g. None -> 2-dimensional plot',' ');
   Output = str2mat(Output, '','');
   Output = str2mat(Output, '   INPUT BOUNDS AND ERROR CHECKING');
   Output = str2mat(Output, '   Three different colors are used to signify the input status of a number.');
   Output = str2mat(Output, '   1. Black -> input is OK.');
   Output = str2mat(Output, '   2. Red   -> input is not recognizable (ex., strings or NaN are not allowed).');
   Output = str2mat(Output, '   3. Blue  -> input is out-of-bounds (ex., Rate of Return < 1).');
   Output = str2mat(Output, '','');
   Output = str2mat(Output, '   THE AXIS MENU');
   Output = str2mat(Output, '   1. The axis tool is a graphic user interface for changing the axis in 1-D and');
   Output = str2mat(Output, '       2-D graphs.  For 3-D graphs, the horizontal and vertical elevation angles');
   Output = str2mat(Output, '       can be rotated.');
   Output = str2mat(Output, '   2. Turn the axis grid on/off');
   Output = str2mat(Output, '','');
   Output = str2mat(Output, '   SAVE AND RESTORE');
   Output = str2mat(Output, '   A portfolio can be saved and restored at a later time by using the FILE');
   Output = str2mat(Output, '   menu.  The only stipulation on the filename choice is that it must have');
   Output = str2mat(Output, '   a ".mat" extension.');
   Output = str2mat(Output, '');
   
   
case 'PlotPortfolio'
   PortfolioMatrix = get(findobj(gcf,'Tag','Listbox1'),'Userdata');
   PlotFlag = get(findobj(gcf,'Tag','PlotMenu'),'Userdata');
   
   % Plot a "Working ..." message 
   cla;
   grid off
   text(.5,.5,'Working  . . .','Units','Normalized','FontUnits','Points','FontSize',16,'Horizontalalignment','center');
   drawnow
   
   if ~isempty(PortfolioMatrix)
      % Check for input errors
      if isnan(getcallprice(100))
         % Input error
         cla;
         LineHandle = [];
         
         % Report error to Info1
         set(findobj(gcf,'Tag','TextInfoWindow1'),'String','Portfolio not plotted due to input error.','ForegroundColor',[1 0 0]);            
         
         % Clear portfolio price string
         set(findobj(gcf,'Tag','TextPortfolioPrice'),'String',['Current Portfolio'],'ForegroundColor',[0 0 0]);
         return;
      end

      % If statement for each diagram type
      if strcmp(lower(get(findobj(gcf,'Tag','PayoffMenu'),'Checked')),'on') == 1
         plotpayoff(Input2);        
      elseif strcmp(lower(get(findobj(gcf,'Tag','ProbMenu'),'Checked')),'on') == 1
         % Plot probability function
         plotprobability(0);
      elseif strcmp(lower(get(findobj(gcf,'Tag','CDFMenu'),'Checked')),'on') == 1
         % Plot CDF
         plotprobability(1);
      elseif strcmp(lower(get(findobj(gcf,'Tag','HedgeMenu'),'Checked')),'on') == 1
         % Plot hedging diagram  
         plothedge(Input2);
      end
      
   else
      % Defaut plot for no assets in the portfolio
      cla
         
      hold off
      LineHandle = [];
      
      if strcmp(lower(get(findobj(gcf,'Tag','PayoffMenu'),'Checked')),'on') == 1
         % Plot zero input payoff diagram
         if ~isnan(getcallprice(100))
            StockPrice = getassetprice;
            
            % Add "axis" lines
            if ~isempty(Input2)
               a = Input2;
            else
               a = [StockPrice-.2*abs(StockPrice) StockPrice+.2*abs(StockPrice) -1 1];
            end   
            plot([a(1) a(2)],[0 0],'k','LineWidth',.05); hold on
            plot([StockPrice StockPrice],[a(3) a(4)],'k','LineWidth',.05);
            axis([StockPrice-.2*abs(StockPrice) StockPrice+.2*abs(StockPrice) -1 1]);
            hold off
            
            % Add grid?
            if strcmp(lower(get(findobj(gcf,'Tag','MenuGridOn'),'Checked')),'on') == 1
               grid on
            end
            
            xlabel('Future Asset Price','Color',[0 0 .5]);
            ylabel('Profit/Loss','Color',[0 0 .5]);
                        
         end
      elseif strcmp(lower(get(findobj(gcf,'Tag','ProbMenu'),'Checked')),'on') == 1
         % Plot zero input probability function
         cla
         plot(0,0,'w');
         xlabel('Profit/Loss','Color',[0 0 .5]);
         ylabel('Probability','Color',[0 0 .5]);
      elseif strcmp(lower(get(findobj(gcf,'Tag','CDFMenu'),'Checked')),'on') == 1
         % Plot zero input CDF 
         cla
         plot(0,0,'w');
         xlabel('Profit/Loss','Color',[0 0 .5]);
         ylabel('CDF','Color',[0 0 .5]);
      elseif strcmp(lower(get(findobj(gcf,'Tag','HedgeMenu'),'Checked')),'on') == 1
         % Plot zero input hedging diagram
         cla
         plot(0,0,'w');
         xlabel(' ');
         ylabel(' ');
      end
      
      % Update axis tool if it is open
      if strcmp(lower(get(findobj(gcf,'Tag','MenuAxisTool'),'Checked')),'on')==1
         AxesHandle = gca;
         axisfn('Initialize', gca, get(findobj(gcf,'Tag','MenuAxisTool'),'Userdata') );
         axes(AxesHandle);
      end
      
      % Info1 
      set(findobj(gcf,'Tag','TextInfoWindow1'),'String',str2mat('Use the Edit menu to ','add a new investment.'),'ForegroundColor',[0 .5 0]);            
      
      % Clear portfolio price string
      set(findobj(gcf,'Tag','TextPortfolioPrice'),'String',['Current Portfolio'],'ForegroundColor',[0 0 0]);
   end   
   
case 'AddAsset'
   % Add/Change an asset
   
   % Get asset matrix and number
   AssetNumber = get(findobj(gcf,'Tag','EditTextNumShares'),'Userdata');
   
   % Get/Check inputs 
   NumShares = getnumshares;
   StrikePrice = getstrikeprice;
   
   if isnan(NumShares)
      return
   elseif isnan(StrikePrice) & (AssetNumber==4 | AssetNumber==5)
      return
   else
      % Remove buttons
      AssetSetup(0);
      
      PortfolioMatrix = get(findobj(gcf,'Tag','Listbox1'),'Userdata');
      PortfolioMatrixStr = get(findobj(gcf,'Tag','Listbox1'),'String');
      
      % Check if in change mode. If so, remove the asset, then add the new one
      str = get(findobj(gcf,'Tag','PushButtonAdd'),'String');
      if strcmp(str(1,1:3),'Cha') == 1
         N = get(findobj(gcf,'Tag','PushButtonAdd'),'Userdata');
         PortfolioMatrix(N,:) = [];
         PortfolioMatrixStr(N,:) = [];
      end
      
      % Check if the exact asset already exists, just change the number of shares (contracts)
      if isempty(PortfolioMatrix)
         ii = [];
      else
         i = find(PortfolioMatrix(:,1)==AssetNumber);
         ii = find(PortfolioMatrix(i,3)==StrikePrice);
      end
      
      if ~isempty(ii)
         % Change an existing asset
         NumShares = PortfolioMatrix(i(ii),2) + NumShares;
         PortfolioMatrix(i(ii),:) = [];
         PortfolioMatrixStr(i(ii),:) = [];
      end
      
      % Add asset
      if NumShares ~= 0
         PortfolioMatrix = [PortfolioMatrix; AssetNumber NumShares StrikePrice];
         
         if abs(NumShares) == 1
            s='';
         else
            s='s';
         end
         
         if AssetNumber == 1
            % Stock
            NewStr = sprintf('%d Asset%s', NumShares, s);
         elseif AssetNumber == 2
            % Borrow
            NewStr = sprintf('$%.02f Cash', NumShares);
         elseif AssetNumber == 3
            % Forward
            NewStr = sprintf('%d Forward%s', NumShares, s);
         elseif AssetNumber == 4
            % Call
            NewStr = sprintf('%d Call%s, K = $%.2f', NumShares, s, StrikePrice);
         elseif AssetNumber == 5
            % Put
            NewStr = sprintf('%d Put%s, K = $%.2f', NumShares, s, StrikePrice);         
         end
         
         PortfolioMatrixStr = strvcat(PortfolioMatrixStr, NewStr);         
      end  
      
      % Arrange portfolio in asset order
      [PortfolioMatrix,i]=sortrows(PortfolioMatrix,[1 3 2]);
      PortfolioMatrixStr = PortfolioMatrixStr(i,:);
      
      
      % Save and display portfolio
      set(findobj(gcf,'Tag','Listbox1'),'Userdata',PortfolioMatrix);
      set(findobj(gcf,'Tag','Listbox1'),'String',PortfolioMatrixStr);
      if ~isempty(PortfolioMatrix)
         set(findobj(gcf,'Tag','Listbox1'),'Value',find(i==size(PortfolioMatrix,1)));
      end
      
      % Plot portfolio
      payofffn('PlotPortfolio');
      
      AssetSetup(0);
   end   
   
   
case 'ModifyAssetLine'
   % Get asset matrix
   PortfolioMatrix = get(findobj(gcf,'Tag','Listbox1'),'Userdata');
   i = get(findobj(gcf,'Tag','Listbox1'),'Value');
   
   % Setup Asset
   AssetSetup(PortfolioMatrix(i,1), PortfolioMatrix(i,2), PortfolioMatrix(i,3), i);   
   
   % Set listbox position
   set(findobj(gcf,'Tag','Listbox1'),'Value',i);
   
   
case 'ChangeAssetLine'
   % Get the line handles
   LineHandle = get(gca,'Userdata');
   i = find(gcbo==LineHandle);
   set(findobj(gcf,'Tag','Listbox1'),'Value',i);
   AssetSetup(0);
   
   % Get asset matrix
   %PortfolioMatrix = get(findobj(gcbf,'Tag','Listbox1'),'Userdata');
   
   % Setup Asset
   %AssetSetup(PortfolioMatrix(i,1), PortfolioMatrix(i,2), PortfolioMatrix(i,3), i);   
   
   % Set listbox position
   %set(findobj(gcbf,'Tag','Listbox1'),'Value',i);
   
   
case 'ChangeAssetListbox'
   i = get(gcbo,'Value');
   AssetSetup(0);
   
   % Replot only if 3-D hedging plot
   Var1 = get(findobj(gcf,'Tag','PopupVar1'),'Value');
   Var2 = get(findobj(gcf,'Tag','PopupVar2'),'Value');
   if strcmp(lower(get(findobj(gcf,'Tag','HedgeMenu'),'Checked')),'on')==1
      if Var2==6 | Var1==Var2
         % Don't replot
      else
         % Plot portfolio
         payofffn('PlotPortfolio');
      end
   end
   
   % Get asset matrix
   %PortfolioMatrix = get(findobj(gcbf,'Tag','Listbox1'),'Userdata');
   
   % Setup Asset
   %AssetSetup(PortfolioMatrix(i,1), PortfolioMatrix(i,2), PortfolioMatrix(i,3), i);   
   
   
case 'RemoveAsset'
   % Get asset matrix
   PortfolioMatrix = get(findobj(gcf,'Tag','Listbox1'),'Userdata');
   PortfolioMatrixStr = get(findobj(gcf,'Tag','Listbox1'),'String');
   
   % Remove Asset
   i = get(findobj(gcf,'Tag','PushButtonAdd'),'Userdata');
   PortfolioMatrix(i,:) = [];
   PortfolioMatrixStr(i,:) = [];
      
   % Save and display portfolio
   set(findobj(gcf,'Tag','Listbox1'),'Userdata',PortfolioMatrix);
   set(findobj(gcf,'Tag','Listbox1'),'String',PortfolioMatrixStr);  
   
   % Move value up 1
   i = get(findobj(gcf,'Tag','Listbox1'),'Value');
   if i-1 >= 1
      set(findobj(gcf,'Tag','Listbox1'),'Value',i-1);
   end
   
   % Remove buttons
   AssetSetup(0);

   % Plot portfolio
   payofffn('PlotPortfolio');   
   
   
case 'AssetSetupZero'
   % Remove buttons
   AssetSetup(0);
   
case 'SelectAsset'
   % Go to add mode
   set(findobj(gcf,'Tag','PushButtonAdd'),'String','Add');
   set(findobj(gcf,'Tag','PushButtonRemove'),'Enable','Off');
   
   % Setup for the asset type
   AssetSetup(Input2);
   
   
case 'SetAssetCost'
   % Get asset number
   AssetNumber = get(findobj(gcf,'Tag','EditTextNumShares'),'Userdata');
   
   % Don't change text if an input error exists
   if isnan(getcallprice(100))
      % RHS error
   %elseif AssetNumber == 3
   %   % Forward
   %   if ~isnan(getforwardprice)
   %      set(findobj(gcbf,'Tag','TextAssetCost'),'string',sprintf('Forward Price = $%.2f', getforwardprice));
   %      set(findobj(gcbf,'Tag','TextAssetCost'),'ForegroundColor',[0 0 0 ]);
   %   end
      
   elseif AssetNumber == 4
      if ~isnan(getcallprice)
         % Call
         set(findobj(gcf,'Tag','TextAssetCost'),'string',sprintf('Call Price = $%.2f', getcallprice));
         set(findobj(gcf,'Tag','TextAssetCost'),'ForegroundColor',[0 0 0 ]);
      end
      
   elseif AssetNumber == 5
      % Put
      if ~isnan(getputprice)
         set(findobj(gcf,'Tag','TextAssetCost'),'string',sprintf('Put Price = $%.2f', getputprice));
         set(findobj(gcf,'Tag','TextAssetCost'),'ForegroundColor',[0 0 0 ]);
      end
      
   else
      % Stock, borrowing, or no asset
      set(findobj(gcbf,'Tag','TextAssetCost'),'string',' ');
   end 
   
   
case 'CheckInput'
   Output = getcheckinput(Input2);
   
   
case 'SavePortfolio'
   PortfolioMatrix = get(findobj(gcbf,'Tag','Listbox1'),'Userdata');
   PortfolioMatrixStr = get(findobj(gcbf,'Tag','Listbox1'),'String');
   if ~isempty(PortfolioMatrix)
      [FileName, FilePath] = uiputfile('*.mat', 'Save The Portfolio As (.mat extension)');
      if FileName~=0
         StartDir=pwd;eval(['cd ',FilePath]);
         eval(['save ',FileName,' PortfolioMatrix PortfolioMatrixStr']);
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
      if exist('PortfolioMatrix')==1 & exist('PortfolioMatrixStr')==1
         set(findobj(gcbf,'Tag','Listbox1'),'Userdata',PortfolioMatrix);
         set(findobj(gcbf,'Tag','Listbox1'),'String',PortfolioMatrixStr);  
         payofffn('PlotPortfolio');
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
   
   UnitStr = get(gcf,'Units');
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
   
   set(gcf,'Units',UnitStr);
   
   % Get position of TextHeading and position axes
   if strcmp(lower(get(findobj(gcf,'Tag','HedgeMenu'),'Checked')),'on') == 1
      UnitStr = get(findobj(gcf,'Tag','PopupVar3'),'Units');
      set(findobj(gcf,'Tag','PopupVar3'),'Units','Inches');
      HeadingSize = get(findobj(gcf,'Tag','PopupVar3'),'Position');
      set(findobj(gcf,'Tag','PopupVar3'),'Units',UnitStr);
      
      WidthBufferLeft  = .8;
      WidthBufferRight = .6;
      HeightBufferLower = .75;
      HeightBufferUpper = .25;
   else
      UnitStr = get(findobj(gcf,'Tag','TextPortfolioPrice'),'Units');
      set(findobj(gcf,'Tag','TextPortfolioPrice'),'Units','Inches');
      HeadingSize = get(findobj(gcf,'Tag','TextPortfolioPrice'),'Position');
      set(findobj(gcf,'Tag','TextPortfolioPrice'),'Units',UnitStr);     
      
      WidthBufferLeft  = .6;
      WidthBufferRight = .2;
      HeightBufferLower = .6;
      HeightBufferUpper = .25; % .1
   end
   
   % Change axes size
   UnitStr = get(gca,'Units');
   set(gca,'Units','Inches');
   AxesSize = get(gca,'Position');
   p=[0+WidthBufferLeft HeadingSize(2)+HeadingSize(4)+HeightBufferLower FigWidth-WidthBufferRight-WidthBufferLeft FigHeight-(HeadingSize(2)+HeadingSize(4)+HeightBufferLower)-HeightBufferUpper];
   set(gca,'Position',p);
   set(gca,'Units',UnitStr);   
   
case 'GetInput'
   Output = getcheckinput(Input2);
   
case 'Example'
   % PortfolioMatrix
   % PortfolioMatrix(:,1) = AssetNumber (1-asset 2-cash 3-forward 4-Call 5-Put)
   % PortfolioMatrix(:,2) = NumShars
   % PortfolioMatrix(:,3) = StrikePrice
   
   % Set S,d,r,t,sig
   AssetPrice = 100;
   AssetReturn = 1;
   RisklessReturn = 1.15;
   Expiration = 1;
   Volatility = .3;
   
   set(findobj(gcf,'Tag','PlotMenu'),'Userdata',2);
   set(findobj(gcf,'Tag','PlotMenu1'),'Checked','off');
   set(findobj(gcf,'Tag','PlotMenu2'),'Checked','on');
   set(findobj(gcf,'Tag','PlotMenu3'),'Checked','off');
   
   if Input2 == 1
      PortfolioMatrix = [ ...
            4 1 100];
      set(findobj(gcf,'Tag','PlotMenu'),'Userdata',1);
      set(findobj(gcf,'Tag','PlotMenu1'),'Checked','on');
      set(findobj(gcf,'Tag','PlotMenu2'),'Checked','off');
      set(findobj(gcf,'Tag','PlotMenu3'),'Checked','off');
   elseif Input2 == 2
      PortfolioMatrix = [ ...
            4 -1 100];
      set(findobj(gcf,'Tag','PlotMenu'),'Userdata',1);
      set(findobj(gcf,'Tag','PlotMenu1'),'Checked','on');
      set(findobj(gcf,'Tag','PlotMenu2'),'Checked','off');
      set(findobj(gcf,'Tag','PlotMenu3'),'Checked','off');
   elseif Input2 == 3
      PortfolioMatrix = [ ...
            5 1 100];
      set(findobj(gcf,'Tag','PlotMenu'),'Userdata',1);
      set(findobj(gcf,'Tag','PlotMenu1'),'Checked','on');
      set(findobj(gcf,'Tag','PlotMenu2'),'Checked','off');
      set(findobj(gcf,'Tag','PlotMenu3'),'Checked','off');
   elseif Input2 == 4
      PortfolioMatrix = [ ...
            5 -1 100];
      set(findobj(gcf,'Tag','PlotMenu'),'Userdata',1);
      set(findobj(gcf,'Tag','PlotMenu1'),'Checked','on');
      set(findobj(gcf,'Tag','PlotMenu2'),'Checked','off');
      set(findobj(gcf,'Tag','PlotMenu3'),'Checked','off');
   elseif Input2 == 5
      % Synthetic Call
      PortfolioMatrix = [ ...
            1 1 NaN; ...
            2 -100/1.15 NaN; ...
            5 1 100];
   elseif Input2 == 6
      % Covered Call
      PortfolioMatrix = [ ...
            1 1 NaN; ...
            4 -1 100];
   elseif Input2 == 7
      % Protective Put
      PortfolioMatrix = [ ...
            1 1 NaN; ...
            5 1 100];
   elseif Input2 == 8
      % Synthetic Future
      PortfolioMatrix = [ ...
            4 1  115; ...
            5 -1 115];
   elseif Input2 == 9
      % Bull Spread
      PortfolioMatrix = [ ...
            4 1  90; ...
            4 -1 110];
   elseif Input2 == 10
      % Bear Spread
      PortfolioMatrix = [ ...
            5 -1  90; ...
            5  1 110];
   elseif Input2 == 11
      % Bull Cylinder
      PortfolioMatrix = [ ...
            5 -1  90; ...
            4  1 110];
   elseif Input2 == 12
      % Bear Cylinder
      PortfolioMatrix = [ ...
            5  1  90; ...
            4 -1 110];
   elseif Input2 == 13
      % Straddle
      PortfolioMatrix = [ ...
            4  1 100; ...
            5  1 100];
   elseif Input2 == 14
      % Strangle
      PortfolioMatrix = [ ...
            5  1  90; ...
            4  1 110];
   elseif Input2 == 15
      % Collar
      PortfolioMatrix = [ ...
            1  1  NaN; ...
            5  1  90; ...
            4 -1 110];
   elseif Input2 == 16
      % Range Forward
      PortfolioMatrix = [ ...
            3  1  NaN; ...
            4 -1  128.6; ...
            5  1  105];
   elseif Input2 == 17
      % Back Spread
      PortfolioMatrix = [ ...
            4 -1 100; ...
            4  2 110];
   elseif Input2 == 18
      % Strap
      PortfolioMatrix = [ ...
            4  2 100; ...
            5  1 100];
   elseif Input2 == 19
      % Butterfly Spread
      PortfolioMatrix = [ ...
            4  1  90; ...
            4 -2 100; ...
            4  1 110];
   elseif Input2 == 20
      % Condor
      PortfolioMatrix = [ ...
            4  1  90; ...
            4 -1  95; ...
            4 -1 105; ...
            4  1 110];
   elseif Input2 == 21
      % Seagull
      PortfolioMatrix = [ ...
            5 -1  90; ...
            4  1 100; ...
            4 -1 110];
   else
      return;
   end
   
   set(findobj(gcf,'Tag','EditTextAssetPrice'),'String',sprintf('%.2f',AssetPrice));
   set(findobj(gcf,'Tag','EditTextAssetReturn'),'String',sprintf('%.2f',AssetReturn));
   set(findobj(gcf,'Tag','EditTextRisklessReturn'),'String',sprintf('%.2f',RisklessReturn));
   set(findobj(gcf,'Tag','EditTextExpiration'),'String',sprintf('%.2f',Expiration));
   set(findobj(gcf,'Tag','EditTextVolatility'),'String',sprintf('%.2f',Volatility));
   
   PortfolioMatrixStr = [];
   for i = 1:size(PortfolioMatrix,1)
      AssetNumber = PortfolioMatrix(i,1);
      NumShares = PortfolioMatrix(i,2);
      StrikePrice = PortfolioMatrix(i,3);
      
      if abs(NumShares) == 1
         s='';
      else
         s='s';
      end
      
      if AssetNumber == 1
         % Stock
         NewStr = sprintf('%d Asset%s', NumShares, s);
      elseif AssetNumber == 2
         % Borrow
         NewStr = sprintf('$%.02f Cash', NumShares);
      elseif AssetNumber == 3
         % Forward
         NewStr = sprintf('%d Forward%s', NumShares, s);
      elseif AssetNumber == 4
         % Call
         NewStr = sprintf('%d Call%s, K = $%.2f', NumShares, s, StrikePrice);
      elseif AssetNumber == 5
         % Put
         NewStr = sprintf('%d Put%s, K = $%.2f', NumShares, s, StrikePrice);         
      end
      
      PortfolioMatrixStr = strvcat(PortfolioMatrixStr, NewStr);
   end
   
   
   % Arrange portfolio in asset order
   [PortfolioMatrix,i]=sortrows(PortfolioMatrix,[1 3 2]);
   PortfolioMatrixStr = PortfolioMatrixStr(i,:);
   
   
   % Save and display portfolio
   set(findobj(gcf,'Tag','Listbox1'),'Userdata',PortfolioMatrix);
   set(findobj(gcf,'Tag','Listbox1'),'String',PortfolioMatrixStr);
   set(findobj(gcf,'Tag','Listbox1'),'value',1);
   
   
   % Plot portfolio
   payofffn('PlotPortfolio');
   
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
   AssetNumber = get(findobj(gcf,'Tag','EditTextNumShares'),'Userdata');
   
   % Edit inputs
   if strcmp(tag,'EditTextNumShares')==1
      if Value==0
         Value = NaN;
         set(findobj(gcf,'Tag',tag(5:length(tag))),'ForegroundColor',[0 0 1]);
      else
         if AssetNumber == 2
            Value = round(Value*100)/100;
         else
            Value = round(Value);    
         end
         set(findobj(gcf,'Tag',tag),'string',num2str(Value));
      end
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


function AssetSetup(AssetNumber, NumberOfShares, StrikePrice, ChangeAssetRow)
if nargin < 2
   if AssetNumber == 2
      NumberOfShares = 0;
   else
      NumberOfShares = 1;
   end
end
if nargin < 3
   % Default strike price
   StrikePrice = getassetprice;
end

if nargin < 4
   % Default: add mode
   ChangeAssetRow = 0;
end


% Get asset matrix
PortfolioMatrix = get(findobj(gcbf,'Tag','Listbox1'),'Userdata');


% Put asset number in userdata
set(findobj(gcbf,'Tag','EditTextNumShares'),'Userdata',AssetNumber);

set(findobj(gcbf,'Tag','Listbox1'),'Units','points');
if AssetNumber==1 | AssetNumber==2 | AssetNumber==3 | AssetNumber==4 | AssetNumber==5
   % Shrink Listbox1
   set(findobj(gcbf,'Tag','Listbox1'),'position',[10 48 144.5 36]);
   
   % Setup Modify button
   set(findobj(gcbf,'Tag','PushButtonModify'),'Visible','Off');
else
   % Enlarge Listbox1
   set(findobj(gcbf,'Tag','Listbox1'),'position',[10 35 144.5 49]);
   
   % Setup Modify button
   set(findobj(gcbf,'Tag','PushButtonModify'),'Visible','On');
   if isempty(PortfolioMatrix)
      set(findobj(gcbf,'Tag','PushButtonModify'),'Enable','Off');
      set(findobj(gcbf,'Tag','PushButtonModify'),'String','Modify');
   else
      set(findobj(gcbf,'Tag','PushButtonModify'),'Enable','On');
      i = get(findobj(gcbf,'Tag','Listbox1'),'Value');
      if PortfolioMatrix(i,1) == 1
         set(findobj(gcbf,'Tag','PushButtonModify'),'String','Modify Asset');
      elseif PortfolioMatrix(i,1) == 2
         set(findobj(gcbf,'Tag','PushButtonModify'),'String','Modify Cash');
      elseif PortfolioMatrix(i,1) == 3
         set(findobj(gcbf,'Tag','PushButtonModify'),'String','Modify Forward');
      elseif PortfolioMatrix(i,1) == 4
         set(findobj(gcbf,'Tag','PushButtonModify'),'String',sprintf('Modify Call, K = $%.2f', PortfolioMatrix(i,3)));
      elseif PortfolioMatrix(i,1) == 5
         set(findobj(gcbf,'Tag','PushButtonModify'),'String',sprintf('Modify Put, K = $%.2f', PortfolioMatrix(i,3)));
      else
         set(findobj(gcbf,'Tag','PushButtonModify'),'String','Modify');
      end
   end
end

% Set starting point for inputs
set(findobj(gcbf,'Tag','EditTextNumShares'),'string',num2str(NumberOfShares));
set(findobj(gcbf,'Tag','EditTextStrikePrice'),'string',num2str(StrikePrice));


% Set string for asset cost
payofffn('SetAssetCost');
set(findobj(gcbf,'Tag','TextAssetCost'),'Visible','On');


% Set visibility on/off
set(findobj(gcbf,'Tag','PushButtonAdd'),'Visible','On');
set(findobj(gcbf,'Tag','PushButtonCancel'),'Visible','On');
set(findobj(gcbf,'Tag','PushButtonRemove'),'Visible','Off');
set(findobj(gcbf,'Tag','TextNumShares'),'Visible','On');
set(findobj(gcbf,'Tag','EditTextNumShares'),'Visible','On');
set(findobj(gcbf,'Tag','TextInfoWindow1'),'Visible','Off');

if AssetNumber == 1
   % Stock
   set(findobj(gcbf,'Tag','TextStrikePrice'),'Visible','Off');
   set(findobj(gcbf,'Tag','EditTextStrikePrice'),'Visible','Off');
   set(findobj(gcbf,'Tag','EditTextStrikePrice'),'String','-1');
   
   set(findobj(gcbf,'Tag','PushButtonAdd'),'String','Add Asset');
   set(findobj(gcbf,'Tag','TextNumShares'),'String','Units (long (+), short(-))');
   
elseif AssetNumber == 2
   % borrow
   set(findobj(gcbf,'Tag','TextStrikePrice'),'Visible','Off');
   set(findobj(gcbf,'Tag','EditTextStrikePrice'),'Visible','Off');
   set(findobj(gcbf,'Tag','EditTextStrikePrice'),'String','-1');
   
   set(findobj(gcbf,'Tag','PushButtonAdd'),'String','Add Cash');
   set(findobj(gcbf,'Tag','TextNumShares'),'String','$ (Lend (+), Borrow (-))');
   
elseif AssetNumber == 3
   % Forward
   set(findobj(gcbf,'Tag','TextStrikePrice'),'Visible','Off');
   set(findobj(gcbf,'Tag','EditTextStrikePrice'),'Visible','Off');   
   set(findobj(gcbf,'Tag','EditTextStrikePrice'),'String','-1');
   
   set(findobj(gcbf,'Tag','PushButtonAdd'),'String','Add Forward');
   set(findobj(gcbf,'Tag','TextNumShares'),'String','Units (long (+), short(-))');
   set(findobj(gcbf,'Tag','TextStrikePrice'),'String','Delivery Price');
elseif AssetNumber == 4
   % Call
   set(findobj(gcbf,'Tag','TextStrikePrice'),'Visible','On');
   set(findobj(gcbf,'Tag','EditTextStrikePrice'),'Visible','On');
   
   set(findobj(gcbf,'Tag','PushButtonAdd'),'String','Add Call');
   set(findobj(gcbf,'Tag','TextNumShares'),'String','Units (long (+), short(-))');
   set(findobj(gcbf,'Tag','TextStrikePrice'),'String','Strike Price');
   
elseif AssetNumber == 5
   % Put
   set(findobj(gcbf,'Tag','TextStrikePrice'),'Visible','On');
   set(findobj(gcbf,'Tag','EditTextStrikePrice'),'Visible','On');
   
   set(findobj(gcbf,'Tag','PushButtonAdd'),'String','Add Put');
   set(findobj(gcbf,'Tag','TextNumShares'),'String','Units (long (+), short(-))');
   set(findobj(gcbf,'Tag','TextStrikePrice'),'String','Strike Price');
   
else
   % No asset
   set(findobj(gcbf,'Tag','PushButtonAdd'),'Visible','Off');
   set(findobj(gcbf,'Tag','PushButtonRemove'),'Visible','Off');
   set(findobj(gcbf,'Tag','PushButtonCancel'),'Visible','Off');
   set(findobj(gcbf,'Tag','TextNumShares'),'Visible','Off');
   set(findobj(gcbf,'Tag','EditTextNumShares'),'Visible','Off');
   set(findobj(gcbf,'Tag','TextStrikePrice'),'Visible','Off');
   set(findobj(gcbf,'Tag','EditTextStrikePrice'),'Visible','Off');
   set(findobj(gcbf,'Tag','TextInfoWindow1'),'Visible','On');
   
end
   
   
% For asset numbers 1,2,and 3, change amount if the asset currently exists
if AssetNumber==1 | AssetNumber==2 | AssetNumber==3
      
   % If the asset already exists, just change it
   if isempty(PortfolioMatrix)
      ii = [];
   else
      ii = find(PortfolioMatrix(:,1)==AssetNumber);
   end
   
   if ~isempty(ii)
      % Change asset
      ChangeAssetRow = ii;
      set(findobj(gcbf,'Tag','EditTextNumShares'),'String',num2str(PortfolioMatrix(ii,2)));
   end
end

if ChangeAssetRow > 0
   % Go to change asset mode
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
     
   % PushButtonRemove and Cancel was [109.5 36 45 12]
   % PushButtonAdd was [10 36 97 12]
   set(findobj(gcbf,'Tag','PushButtonCancel'),'Enable','On');
   set(findobj(gcbf,'Tag','PushButtonCancel'),'Visible','On');
   
   set(findobj(gcbf,'Tag','PushButtonAdd'),   'position',[10 36 68 12]);
   set(findobj(gcbf,'Tag','PushButtonRemove'),'position',[10+68+1 36 38 12]);
   set(findobj(gcbf,'Tag','PushButtonCancel'),'position',[10+69+38+1 36 36 12]);
else
   % Add asset mode
   
   % Enlarge add and cancel button sizes
   %set(findobj(gcbf,'Tag','PushButtonAdd'),   'position',[10 36 144.5 12]);
   set(findobj(gcbf,'Tag','PushButtonAdd'),   'position',[10 36 97 12]);
   set(findobj(gcbf,'Tag','PushButtonCancel'),'position',[109.5 36 45 12]);
   
   % Enable cancel button
   set(findobj(gcbf,'Tag','PushButtonCancel'),'Enable','On');
   set(findobj(gcbf,'Tag','PushButtonCancel'),'Visible','On');
end

% Varify that inputs are correct and text color is correct
getnumshares;
getstrikeprice;

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
Volatility = getcheckinput('EditTextVolatility');
% End Function


% Asset input functions
function NumShares = getnumshares
NumShares = getcheckinput('EditTextNumShares');
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
price = round(100*price)/100;
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
CallPrice = round(100*CallPrice)/100;
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
PutPrice = round(100*PutPrice)/100;
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
price = round(100*price)/100;
% End Function



%%%%%%%%%%%%%%%%%%%%%%
% Plotting Functions %
%%%%%%%%%%%%%%%%%%%%%%

function plotpayoff(Input1)

PortfolioMatrix = get(findobj(gcf,'Tag','Listbox1'),'Userdata');
PlotFlag = get(findobj(gcf,'Tag','PlotMenu'),'Userdata');

% Plot payoff diagram         
cla;
hold off;
LineHandle = [];

StockPrice = getassetprice;
AssetReturn = getassetreturn;
RisklessReturn = getrisklessreturn;
YearsToExpiration = getyearstoexpiration;

% Find X-axis size
i=find(PortfolioMatrix(:,3)>0);
if isempty(i)
   if isempty(find(PortfolioMatrix(:,1)==1))
      % No underlying asset in the portfolio
      x = [StockPrice];
   else
      % Underlying asset is in the portfolio, expand X-axis based on Asset Return
      x = [StockPrice; (StockPrice-(StockPrice*exp((AssetReturn-1)*YearsToExpiration)-StockPrice))];
   end
else
   if isempty(find(PortfolioMatrix(:,1)==1))
      % No underlying asset in the portfolio, include all strike prices
      x = [StockPrice; PortfolioMatrix(i,3)];
   else
      % Underlying asset is in the portfolio, expand X-axis based on Asset Return, include all strike prices
      x = [StockPrice; (StockPrice-(StockPrice*exp((AssetReturn-1)*YearsToExpiration)-StockPrice)); PortfolioMatrix(i,3)];
   end
end
Percent = .5;
Xmin = min(x) - Percent*abs(min(x));
Xmin = max([Xmin 0]);
Xmax = max(x) + Percent*abs(max(x));
StockVector = linspace(Xmin, Xmax, 250);

% If the axis tool calls plotpayoff, then use input1 for the axis size
if ~isempty(Input1)
   if length(Input1) == 4
      Xmin = Input1(1);
      Xmax = Input1(2);
      StockVector = linspace(Xmin,Xmax,250);
   end
end

TotalAssetLine = zeros(size(StockVector));
TotalCost = 0;
for i = 1:size(PortfolioMatrix,1)         
   [AssetLine, Cost, LineColor] = profitlossline(PortfolioMatrix(i,1), PortfolioMatrix(i,2), PortfolioMatrix(i,3), StockVector, StockPrice, AssetReturn, RisklessReturn, YearsToExpiration);
   
   % Total portfolio line and cost
   TotalAssetLine = TotalAssetLine + AssetLine;
   TotalCost = TotalCost + Cost;

   if PlotFlag==1 
      LineStyle = ['-'];
   else
      LineStyle = ['--'];
   end
   
   if PlotFlag==1 | PlotFlag == 2
      % Plot asset line
      LineHandle(i,1) = plot(StockVector, AssetLine, 'Linestyle', LineStyle, 'Color', LineColor,'LineWidth',1.5); hold on;
      set(LineHandle(i,1),'ButtonDownFcn','payofffn(''ChangeAssetLine'');');
   end   
end

if PlotFlag==2 | PlotFlag==3
   % Plot total profit loss
   plot(StockVector, TotalAssetLine,'Color',[.4 0 0],'LineWidth',3.0); hold on
end


% If one asset, replot so that the change function will work
if size(PortfolioMatrix,1)==1 & PlotFlag==2
   LineHandle(1,1) = plot(StockVector, AssetLine, 'Linestyle', LineStyle, 'Color', LineColor,'LineWidth',1.5); hold on;
   set(LineHandle(1,1),'ButtonDownFcn','payofffn(''ChangeAssetLine'');');
end

xlabel('Future Asset Price','Color',[0 0 .5]);
ylabel('Profit/Loss','Color',[0 0 .5]);

% Set axis
if ~isempty(Input1)
   if length(Input1) == 4
      axis(Input1);
   else
      a = axis;
      axis([Xmin Xmax a(3) a(4)]);
      
      % Make axis symmetric about zero in Y
      a = axis;
      amax = max(abs([a(3) a(4)]));
      axis([a(1) a(2) -amax amax]);
   end
else
   a = axis;
   axis([Xmin Xmax a(3) a(4)]);
   
   % Make axis symmetric about zero in Y
   a = axis;
   amax = max(abs([a(3) a(4)]));
   axis([a(1) a(2) -amax amax]);
   
   % Update axis tool if it is open
   if strcmp(lower(get(findobj(gcf,'Tag','MenuAxisTool'),'Checked')),'on')==1
      AxesHandle = gca;
      axisfn('Initialize', gca, get(findobj(gcf,'Tag','MenuAxisTool'),'Userdata') );
      axes(AxesHandle);
   end
end


% Add "axis" lines
a = axis;
plot([a(1) a(2)],[0 0],'k','LineWidth',.01);
plot([StockPrice StockPrice],[a(3) a(4)],'k','LineWidth',.01);


% Add grid
if strcmp(lower(get(findobj(gcf,'Tag','MenuGridOn'),'Checked')),'on')==1
   grid on
end

hold off
drawnow

%set(gca,'Tag','Axes1');  % not being used ????

% Store the handles in the userdata for the figure
set(gca,'Userdata',LineHandle);
set(gca,'tag','Axes1');  % tag gets errased by plot!

% Info1
if size(PortfolioMatrix,1) == 1
   set(findobj(gcf,'Tag','TextInfoWindow1'),'String',str2mat('Use the Edit menu to ','add a new investment.'),'ForegroundColor',[0 .5 0]);            
else
   set(findobj(gcf,'Tag','TextInfoWindow1'),'String',str2mat('Click on a plotted line or the','portfolio list to select an investment.'),'ForegroundColor',[0 .5 0]);
end

% Compute the total price of the portfolio and print to TextPortfolioPrice
TotalCost = round(100*TotalCost)/100;
set(findobj(gcf,'Tag','TextPortfolioPrice'),'String',['Current Portfolio ',sprintf('(Value = $%.2f)',TotalCost)],'ForegroundColor',[0 0 0]);

% End function



function plothedge(Input1)

ErrStr = '';

% Get inputs
PortfolioMatrix = get(findobj(gcf,'Tag','Listbox1'),'Userdata');
AssetNumber = get(findobj(gcf,'Tag','Listbox1'),'Value');
PlotFlag = get(findobj(gcf,'Tag','PlotMenu'),'Userdata');

AssetPrice = getassetprice;
AssetReturn = getassetreturn;
RisklessReturn = getrisklessreturn;
Expiration = getyearstoexpiration;
Volatility = getvolatility;


Var2 = get(findobj(gcf,'Tag','PopupVar2'),'Value');
if Var2 == 6
   N = 200;
else
   N = 50;
end


% If the axis tool calls plotpayoff, then use input1 for the axis size
Percent = .5;   % Determines axis length
Var1 = get(findobj(gcf,'Tag','PopupVar1'),'Value');
if Var1 == 1
   if ~isempty(Input1)
      Xmin = Input1(1);
      Xmax = Input1(2);
   else
      x = AssetPrice;
      Xmin = min(x) - Percent*abs(min(x));
      Xmax = max(x) + Percent*abs(max(x));
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
      Xmin = min(x) - Percent*abs(min(x));
      Xmax = max(x) + Percent*abs(max(x));
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
      Xmin = min(x) - Percent*abs(min(x));
      Xmax = max(x) + Percent*abs(max(x));
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
      Xmin = min(x) - Percent*abs(min(x));
      Xmax = max(x) + Percent*abs(max(x));
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
      Xmin = min(x) - Percent*abs(min(x));
      Xmax = max(x) + Percent*abs(max(x));
   end
   Xmin = max([Xmin eps]);
   Volatility = linspace(Xmin, Xmax, N);
   Xstr = 'Volatility';
   Var1Label = 'Volatility';
else
   error('Var1>5');
end

if Var1 == Var2
   Var2=6;
   Ystr=[];
   N = 200;
elseif Var2 == 1
   if ~isempty(Input1)
      Xmin = Input1(3);
      Xmax = Input1(4);
   else
      x = AssetPrice;
      Xmin = min(x) - Percent*abs(min(x));
      Xmax = max(x) + Percent*abs(max(x));
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
      Xmin = min(x) - Percent*abs(min(x));
      Xmax = max(x) + Percent*abs(max(x));
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
      Xmin = min(x) - Percent*abs(min(x));
      Xmax = max(x) + Percent*abs(max(x));
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
      Xmin = min(x) - Percent*abs(min(x));
      Xmax = max(x) + Percent*abs(max(x));
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
      Xmin = min(x) - Percent*abs(min(x));
      Xmax = max(x) + Percent*abs(max(x));
   end
   Xmin = max([Xmin eps]);
   Volatility = linspace(Xmin, Xmax, N);
   Ystr = 'Volatility';
   Var2Label = 'Volatility';
elseif Var2 == 6
   Ystr = [];
   Var2Label = ' ';
else
   error('Var2>6');
end   


Var3 = get(findobj(gcf,'Tag','PopupVar3'),'Value');
if Var3 == 1
   FuncName = 'Price';
   Var3Label = 'Value';
elseif Var3 == 2
   FuncName = 'Delta';
   Var3Label = 'Delta';
elseif Var3 == 3
   FuncName = 'Gamma';
   Var3Label = 'Gamma';
elseif Var3 == 4
   FuncName = 'Theta';
   Var3Label = 'Theta';
elseif Var3 == 5
   FuncName = 'Vega';
   Var3Label = 'Vega';
elseif Var3 == 6
   FuncName = 'Rho';
   Var3Label = 'Rho';
elseif Var3 == 7
   FuncName = 'lambda1';  % Changed blslambda
   Var3Label = 'Omega';
else
   error('Var3>7');
end


cla
hold off
Ztotal = 0;

% Make dependent variable axis
if Var2 == 6
   % 2-Dim plot
else
   % 3-Dim plot
   eval(['[',Xstr,',',Ystr,']=meshgrid(',Xstr,',',Ystr,');']);
end

for i = 1:size(PortfolioMatrix,1)         
   
   if PortfolioMatrix(i,1) == 1
      Zstr = 'Asset';
      if PortfolioMatrix(i,2) == 1
         AssetLabel = sprintf(' of %d Asset', PortfolioMatrix(i,2));
      else
         AssetLabel = sprintf(' of %d Assets', PortfolioMatrix(i,2));
      end
      LineColor = 'b';
      RGB = [0 0 1];
      
      if Var3==1
         eval([Zstr,' = AssetPrice .* AssetReturn.^Expiration .* ones(size(',Xstr,'));']);
      elseif Var3==2
         eval([Zstr,' = AssetReturn.^Expiration .* ones(size(',Xstr,'));']);
      elseif Var3 == 4
         eval([Zstr,' = log(AssetReturn) .* AssetPrice .* Expiration .* AssetReturn.^Expiration .* ones(size(',Xstr,'));']);
      elseif Var3 == 7
         eval([Zstr,' = ones(size(',Xstr,'));']);
      else
         eval([Zstr,' = zeros(size(',Xstr,'));']);
      end
            
   elseif PortfolioMatrix(i,1) == 2
      Zstr = 'Cash';
      %AssetLabel = [' of Cash'];
      if PortfolioMatrix(i,2) == 1
         AssetLabel = sprintf(' of %d dollar', PortfolioMatrix(i,2));
      else
         AssetLabel = sprintf(' of %d dollars', PortfolioMatrix(i,2));
      end
      LineColor = 'm';
      RGB = [1 0 1];
      
      if Var3==1
         eval([Zstr,' = RisklessReturn.^Expiration .* ones(size(',Xstr,'));']);
      elseif Var3 == 4
         eval([Zstr,' = log(RisklessReturn) .* RisklessReturn.^Expiration .* ones(size(',Xstr,'));']);
      elseif Var3 == 6
         eval([Zstr,' = Expiration .* RisklessReturn.^(Expiration-1) .* ones(size(',Xstr,'));']);
      else
         eval([Zstr,' = zeros(size(',Xstr,'));']);
      end
      
   elseif PortfolioMatrix(i,1) == 3
      DeliveryPrice = PortfolioMatrix(i,3);
      Zstr = 'Forward';
      %AssetLabel = [' of Forward'];
      if PortfolioMatrix(i,2) == 1
         AssetLabel = sprintf(' of %d Forward', PortfolioMatrix(i,2));
      else
         AssetLabel = sprintf(' of %d Forwards', PortfolioMatrix(i,2));
      end
      LineColor = 'c';
      RGB = [0 1 1];
      
      if Var3==1
         eval([Zstr,' = zeros(size(',Xstr,'));']);
      elseif Var3 == 2
         eval([Zstr,' = AssetReturn.^(-Expiration) .* ones(size(',Xstr,'));']);
      elseif Var3 == 4
         eval([Zstr,' = AssetPrice .* AssetReturn.^(-Expiration) .* (log(AssetReturn)-log(RisklessReturn)) .* ones(size(',Xstr,'));']);
      elseif Var3 == 6
         eval([Zstr,' = Expiration .* AssetPrice .* RisklessReturn.^(-1) .* AssetReturn.^(-Expiration) .* ones(size(',Xstr,'));']);
      elseif Var3 == 7
         eval([Zstr,' = NaN * ones(size(',Xstr,'));']);
         ErrStr = str2mat('Omega for a forward','contract is not defined.');
      else
         eval([Zstr,' = zeros(size(',Xstr,'));']);
      end

   elseif PortfolioMatrix(i,1)==4 | PortfolioMatrix(i,1)==5
      StrikePrice = PortfolioMatrix(i,3);
      if PortfolioMatrix(i,1)==4
         Zstr = 'Call';
         %AssetLabel = [' of Call'];
         if PortfolioMatrix(i,2) == 1
            AssetLabel = sprintf(' of %d Call', PortfolioMatrix(i,2));
         else
            AssetLabel = sprintf(' of %d Calls', PortfolioMatrix(i,2));
         end
         LineColor = [0 .75 0]; %'g';
         RGB = [0 .75 0];
      else
         Zstr = 'Put';
         %AssetLabel = [' of Put'];
         if PortfolioMatrix(i,2) == 1
            AssetLabel = sprintf(' of %d Put', PortfolioMatrix(i,2));
         else
            AssetLabel = sprintf(' of %d Puts', PortfolioMatrix(i,2));
         end
         LineColor = 'r';
         RGB = [1 0 0];
      end
      
      if Var3==3 | Var3==5
         eval(['Call=bls',       lower(FuncName),'(AssetPrice, StrikePrice, log(RisklessReturn), Expiration, Volatility, log(AssetReturn));']);
         Put = Call;
      else
         eval(['[Call, Put]=bls',lower(FuncName),'(AssetPrice, StrikePrice, log(RisklessReturn), Expiration, Volatility, log(AssetReturn));']);
      end
   else
      disp('Some wrong in hedging plot.  Returned from function.');
      return
   end
   
   
   % Scale greek by the weight (# of shares/contracts/amount of cash)
   eval([Zstr, ' = PortfolioMatrix(i,2) * ',Zstr,';']);
   
   % Portfolio greek is the weighted sum of the individual assets
   eval(['Ztotal = Ztotal + ',Zstr,';']);
   
   
   if PlotFlag==1 | PlotFlag==2
      % Plot all assets and the total (with weights, force color on 2-D and 3-D, Ztotal color=[.4 0 0]=brown, 'LineWidth'=3.0)
      if Var2 == 6
         % 2-Dim plot
         if PlotFlag==1 
            LineStyle = ['-'];
         else
            LineStyle = ['--'];
         end
         
         eval(['LineHandle(i,1) = plot(',Xstr,',',Zstr,', ''Linestyle'', LineStyle, ''Color'', LineColor,''LineWidth'',1.5);']);
         set(LineHandle(i,1),'ButtonDownFcn','payofffn(''ChangeAssetLine'');');
         hold on
         xlabel(Var1Label,'Color',[0 0 .5]);
         if PlotFlag==1 & size(PortfolioMatrix,1)==1
            ylabel([Var3Label AssetLabel],'Color',[0 0 .5]);
         else
            ylabel(Var3Label,'Color',[0 0 .5]);
         end
      else
         if i == AssetNumber
            if PlotFlag==2
               eval(['[m,n]=size(',Zstr,');']);
               C(:,:,1)=RGB(1)*ones(m,n);
               C(:,:,2)=RGB(2)*ones(m,n);
               C(:,:,3)=RGB(3)*ones(m,n);
               eval(['mesh(',Xstr,',',Ystr,',',Zstr,',C);']);
            else
               eval(['mesh(',Xstr,',',Ystr,',',Zstr,');']);  
            end
            view([25, 45]);
            xlabel(Var1Label,'Color',[0 0 .5]);
            ylabel(Var2Label,'Color',[0 0 .5]);
            if PlotFlag==2
               zlabel([Var3Label AssetLabel,' & the Portfolio'],'Color',[0 0 .5]);
            else
               zlabel([Var3Label AssetLabel],'Color',[0 0 .5]);
            end
            
            hold on
                        
            % Mesh automatically puts a grid on
            set(findobj(gcf,'Tag','MenuGridOn'),'Checked','on');
            set(findobj(gcf,'Tag','MenuGridOff'),'Checked','off');
            
            %set(gcf,'Color',[.8 .8 .8]-.045);  %???? bug
         end
      end
   end
end

% Plot total
if PlotFlag==2 | PlotFlag==3
   % Plot the total only (color=[.4 0 0]=brown)
   if Var2 == 6
      % 2-Dim plot
      eval(['plot(',Xstr,',Ztotal,''Color'',[.4 0 0],''LineWidth'',3.0);']);
      xlabel(Var1Label,'Color',[0 0 .5]);
      ylabel(Var3Label,'Color',[0 0 .5]);
   else
      if PlotFlag==2
         RGB = [.4 0 0];
         eval(['[m,n]=size(',Zstr,');']);
         C(:,:,1)=RGB(1)*ones(m,n);
         C(:,:,2)=RGB(2)*ones(m,n);
         C(:,:,3)=RGB(3)*ones(m,n);
         eval(['mesh(',Xstr,',',Ystr,',Ztotal,C);']);
      else
         eval(['mesh(',Xstr,',',Ystr,',Ztotal);']);
      end
      
      view([25, 45]);
      xlabel(Var1Label,'Color',[0 0 .5]);
      ylabel(Var2Label,'Color',[0 0 .5]);
      if PlotFlag==3
         zlabel([Var3Label ' of the Portfolio'],'Color',[0 0 .5]);
      end
      
      % Mesh automatically puts a grid on
      set(findobj(gcf,'Tag','MenuGridOn'),'Checked','on');
      set(findobj(gcf,'Tag','MenuGridOff'),'Checked','off');
      
      %set(gcf,'Color',[.8 .8 .8]-.045);  %???? bug
   end   
end


% Replot the last asset so that the change function will work if the portfolio line covers (2-D only)
%if size(PortfolioMatrix,1)==1 & PlotFlag==2 & Var2==6
if PlotFlag==2 & Var2==6
   LineStyle = ['--'];
   eval(['LineHandle(i,1) = plot(',Xstr,',',Zstr,', ''Linestyle'', LineStyle, ''Color'', LineColor,''LineWidth'',1.5);']);
   set(LineHandle(i,1),'ButtonDownFcn','payofffn(''ChangeAssetLine'');');
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


% Store the handles in the userdata for the figure, if 2-D
if Var2==6 & (PlotFlag==1 | PlotFlag==2)
   set(gca,'Userdata',LineHandle);
   set(gca,'tag','Axes1');  % tag gets errased by plot!
end


% Info1
if size(ErrStr,2) > 0
   set(findobj(gcf,'Tag','TextInfoWindow1'),'String',ErrStr,'ForegroundColor',[1 0 0]);
else
   if size(PortfolioMatrix,1) == 1
      set(findobj(gcf,'Tag','TextInfoWindow1'),'String',str2mat('Use the Edit menu to ','add a new investment.'),'ForegroundColor',[0 .5 0]);            
   else
      if Var2 == 6
         set(findobj(gcf,'Tag','TextInfoWindow1'),'String',str2mat('Click on a plotted line or the','portfolio list to select an investment.'),'ForegroundColor',[0 .5 0]);
      else
         set(findobj(gcf,'Tag','TextInfoWindow1'),'String',str2mat('Click on the portfolio list','  to select an investment.'),'ForegroundColor',[0 .5 0]);
      end
   end
end

% Update axis tool if it open
if strcmp(lower(get(findobj(gcf,'Tag','MenuAxisTool'),'Checked')),'on')==1 & isempty(Input1)
   AxesHandle = gca;
   axisfn('Initialize', gca, get(findobj(gcf,'Tag','MenuAxisTool'),'Userdata') );
   axes(AxesHandle);
end


% Get the portfolio cost
AssetPrice = getassetprice;
AssetReturn = getassetreturn;
RisklessReturn = getrisklessreturn;
Expiration = getyearstoexpiration;
Volatility = getvolatility;

TotalCost = 0;
for i = 1:size(PortfolioMatrix,1)         
   [AssetLine, Cost, LineColor] = profitlossline(PortfolioMatrix(i,1), PortfolioMatrix(i,2), PortfolioMatrix(i,3), [AssetPrice AssetPrice+10], AssetPrice, AssetReturn, RisklessReturn, Expiration);
   TotalCost = TotalCost + Cost;
end
TotalCost = round(100*TotalCost)/100;
set(findobj(gcf,'Tag','TextPortfolioPrice'),'String',['Current Portfolio ',sprintf('(Value = $%.2f)',TotalCost)],'ForegroundColor',[0 0 0]);

% End function



function plotprobability(Input1)
% Plot probability diagram         

% Input setup
CDFFlag = Input1;     % CDFFlag=0 plot the probability, else plot the CDF
if CDFFlag 
   N = 300;          % # of "stairs"
   Npoints = 1000;   % # of points in StockVector
   ConfBand = 99.9;  % Convidence band on StockVector in percent
else
   N = 40;          % # of "stairs"
   Npoints = 500;   % # of points in StockVector
   ConfBand = 99;   % Convidence band on StockVector in percent
end

cla
hold off
LineHandle = [];


% Get portfolio
PortfolioMatrix = get(findobj(gcf,'Tag','Listbox1'),'Userdata');
PlotFlag = get(findobj(gcf,'Tag','PlotMenu'),'Userdata');


% Get inputs
StockPrice = getassetprice;
RisklessReturn = getrisklessreturn;
AssetReturn = getassetreturn;
YearsToExpiration = getyearstoexpiration;
Volatility = getvolatility;


% If the axis tool calls plotpayoff, then use input1 for the axis size
%if ~isempty(Input1)
%   if length(Input1) == 4
%      Xmin = Input1(1);
%      Xmax = Input1(2);
%      StockVector = linspace(Xmin, Xmax, N);
%   end
%end


% Compute the stock vector for equal probability
ConfBand = ((100-ConfBand)/2)/100;
StockVector=logninv(linspace(ConfBand,1-ConfBand,Npoints), log(StockPrice)+((AssetReturn-1-(Volatility)^2)/2)*YearsToExpiration, Volatility*sqrt(YearsToExpiration));


% First find the extent of the payoff or axis limits and bin everything based on it
TotalAssetLine = zeros(size(StockVector));
PLmin=[];
PLmax=[];
for i = 1:size(PortfolioMatrix,1)
   AssetLine = profitlossline(PortfolioMatrix(i,1), PortfolioMatrix(i,2), PortfolioMatrix(i,3), StockVector, StockPrice, AssetReturn, RisklessReturn, YearsToExpiration);
   TotalAssetLine = TotalAssetLine + AssetLine;
   PLmax = max([AssetLine PLmax]);
   PLmin = min([AssetLine PLmin]);
end

% Extend the axis by 2.5%
PLmax = max([TotalAssetLine PLmax]);
PLmax = PLmax + .025*abs(PLmax);
PLmin = min([TotalAssetLine PLmin]);
PLmin = PLmin - .025*abs(PLmin);

% Find the profit/loss vector
[Nhist, PLVector] = hist([PLmin PLmax], N);
DelX = abs(PLVector(1)-PLmin);

% Loop on portfolio
TotalAssetLine = zeros(size(StockVector));
TotalCost = 0;
for i = 1:size(PortfolioMatrix,1)         
   [AssetLine, Cost, LineColor] = profitlossline(PortfolioMatrix(i,1), PortfolioMatrix(i,2), PortfolioMatrix(i,3), StockVector, StockPrice, AssetReturn, RisklessReturn, YearsToExpiration);
   TotalCost = TotalCost + Cost;
   TotalAssetLine = TotalAssetLine + AssetLine;
   
   if PlotFlag == 1 
      LineStyle = ['-'];
   else
      LineStyle = ['--'];
   end
   
   if PlotFlag==1 | PlotFlag == 2
      % Plot asset line    
      j=find(AssetLine>PLmax);
      AssetLine(j) = [];
      j=find(AssetLine<PLmin);
      AssetLine(j) = [];
      [Nhist, x] = hist(AssetLine, PLVector);
      
      if CDFFlag 
         [xx,yy] = stairs([x(1)-DelX x-DelX x(N)+DelX], cumsum([0 (1-2*ConfBand)*Nhist/Npoints 0]));
      else
         [xx,yy] = stairs([x(1)-DelX x-DelX x(N)+DelX], [0 Nhist/Npoints 0]);
      end
      
      LineHandle(i,1) = plot(xx, yy, 'Linestyle', LineStyle, 'Color', LineColor,'LineWidth',1.5); hold on;
      set(LineHandle(i,1),'ButtonDownFcn','payofffn(''ChangeAssetLine'');');
   end
end


if PlotFlag==2 | PlotFlag==3
   % Plot total profit loss
   j = find(TotalAssetLine>PLmax);
   TotalAssetLine(j) = [];
   j = find(TotalAssetLine<PLmin);
   TotalAssetLine(j) = [];
   [Nhist, x] = hist(TotalAssetLine, PLVector); 
   if CDFFlag 
      [xx,yy] = stairs([x(1)-DelX x-DelX x(N)+DelX], cumsum([0 (1-2*ConfBand)*Nhist/Npoints 0]));
   else
      [xx,yy] = stairs([x(1)-DelX x-DelX x(N)+DelX], [0 Nhist/Npoints 0]);
   end
   plot(xx, yy,'Color',[.4 0 0],'LineWidth',3.0); hold on
end


% If one asset, replot so that the change function will work
if size(PortfolioMatrix,1)==1 & (PlotFlag==1 | PlotFlag == 2)
   % Plot asset line    
   j=find(AssetLine>PLmax);
   AssetLine(j) = [];
   j=find(AssetLine<PLmin);
   AssetLine(j) = [];
   [Nhist, x] = hist(AssetLine, PLVector);
   if CDFFlag 
      [xx,yy] = stairs([x(1)-DelX x-DelX x(N)+DelX], cumsum([0 (1-2*ConfBand)*Nhist/Npoints 0]));
   else
      [xx,yy] = stairs([x(1)-DelX x-DelX x(N)+DelX], [0 Nhist/Npoints 0]);
   end
   LineHandle(1,1) = plot(xx, yy, 'Linestyle', LineStyle, 'Color', LineColor,'LineWidth',1.5); hold on;
   set(LineHandle(1,1),'ButtonDownFcn','payofffn(''ChangeAssetLine'');');
end

xlabel('Profit/Loss','Color',[0 0 .5]);
if CDFFlag 
   ylabel('CDF','Color',[0 0 .5]);
else
   ylabel('Probability','Color',[0 0 .5]);
end

% Set axis
a = axis;
axis([PLmin PLmax a(3) a(4)]);


% Update axis tool if it is open
if strcmp(lower(get(findobj(gcf,'Tag','MenuAxisTool'),'Checked')),'on')==1
   AxesHandle = gca;
   axisfn('Initialize', gca, get(findobj(gcf,'Tag','MenuAxisTool'),'Userdata') );
   axes(AxesHandle);
end


% Add grid?
if strcmp(lower(get(findobj(gcf,'Tag','MenuGridOn'),'Checked')),'on')==1
   grid on
end

hold off
drawnow

% Store the handles in the userdata for the figure
set(gca,'Userdata',LineHandle);
set(gca,'tag','Axes1');  % tag gets errased by plot!

% Info1
if size(PortfolioMatrix,1) == 1
   set(findobj(gcf,'Tag','TextInfoWindow1'),'String',str2mat('Use the Edit menu to ','add a new investment.'),'ForegroundColor',[0 .5 0]);            
else
   set(findobj(gcf,'Tag','TextInfoWindow1'),'String',str2mat('Click on a plotted line or the','portfolio list to select an investment.'),'ForegroundColor',[0 .5 0]);
end

% Compute the total price of the portfolio and print to TextPortfolioPrice
TotalCost = round(100*TotalCost)/100;
set(findobj(gcf,'Tag','TextPortfolioPrice'),'String',['Current Portfolio ',sprintf('(Value = $%.2f)',TotalCost)],'ForegroundColor',[0 0 0]);

% End function


function [AssetLine, Cost, LineColor] = profitlossline(AssetNumber, NumberOfShares, StrikePrice, StockVector, StockPrice, AssetReturn, RisklessReturn, YearsToExpiration)
% Compute asset profit/loss line
% PayoffPerUnit is the future payoff for the StockVector [vector]
% CostPerUnit is the present cost per unit asset [scalar]

if AssetNumber == 1
   % Stock
   LineColor = 'b';
   %PayoffPerUnit = StockVector + StockPrice*AssetReturn^YearsToExpiration - StockPrice;
   PayoffPerUnit = StockVector*AssetReturn^YearsToExpiration;
   CostPerUnit = StockPrice;
   
elseif AssetNumber == 2
   % Cash
   LineColor = 'm';   
   PayoffPerUnit = ones(size(StockVector))*RisklessReturn^YearsToExpiration;
   CostPerUnit = 1;
   
elseif AssetNumber == 3
   % Forward
   LineColor = 'c';
   DeliveryPrice = StockPrice * (RisklessReturn/AssetReturn)^YearsToExpiration;
   PayoffPerUnit = StockVector - DeliveryPrice;
   CostPerUnit = 0;
   
elseif AssetNumber == 4
   % Call
   LineColor = [0 .75 0]; %'g';
   CallPrice = getcallprice(StrikePrice);
   
   if StrikePrice <= StockVector(1)
      %               StockVector + StockPrice*AssetReturn^YearsToExpiration - StockPrice - StrikePrice
      PayoffPerUnit = StockVector - StrikePrice;
   elseif StrikePrice >= max(StockVector)
      PayoffPerUnit = zeros(size(StockVector));
   else
      j = max(find(StockVector < StrikePrice));
      PayoffPerUnit = [zeros(size(StockVector(1:j))) StockVector(j+1:length(StockVector))-StrikePrice];
   end      
   CostPerUnit = CallPrice;
   
elseif AssetNumber == 5
   % Put
   LineColor = 'r';
   PutPrice = getputprice(StrikePrice);
   
   if StrikePrice <= StockVector(1)
      PayoffPerUnit = zeros(size(StockVector));
   elseif StrikePrice >= max(StockVector)
      PayoffPerUnit = StrikePrice - StockVector;
   else
      j = max(find(StockVector < StrikePrice));
      PayoffPerUnit = [StrikePrice-StockVector(1:j) zeros(size(StockVector(j+1:length(StockVector))))];
   end      
   CostPerUnit = PutPrice;
   
else
   disp('PlotPortfolio:  No AssetNumber match????');
end


if strcmp(lower(get(findobj(gcf,'Tag','MixedMenu'),'Checked')),'on') == 1
   AssetLine = NumberOfShares * (PayoffPerUnit - CostPerUnit);
   Cost = NumberOfShares * CostPerUnit;
elseif strcmp(lower(get(findobj(gcf,'Tag','PresentMenu'),'Checked')),'on') == 1
   AssetLine = NumberOfShares * (PayoffPerUnit*RisklessReturn^(-YearsToExpiration) - CostPerUnit);
   Cost = NumberOfShares * CostPerUnit;
elseif strcmp(lower(get(findobj(gcf,'Tag','FutureMenu'),'Checked')),'on') == 1
   CostPerUnit = CostPerUnit*RisklessReturn^YearsToExpiration;
   AssetLine = NumberOfShares * (PayoffPerUnit - CostPerUnit);
   Cost = NumberOfShares * CostPerUnit;
end
% End function




