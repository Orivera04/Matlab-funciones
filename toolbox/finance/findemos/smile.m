function smile(Input1)
%SMILE Demonstration of the implied volatility smile.
%
% See also BLSDEMOS, ONEOPT, PAYOFF.

% Main GUI for the volatility smile
%
% Created by Greg Portmann (Sept 1997)

%       Copyright 1995-2002 The MathWorks, Inc.  
%       $Revision: 1.12 $   $Date: 2002/04/14 21:46:59 $ 

% Calls:  smilefn
% Called by:  

if nargin < 1
   Input1 = 0;
end

%Turn WARNINGS OFF.
swarn = warning('off');

%Setup figure and axes.
a = figure('Units','normalized', ...
   'Color',[.8 .8 .8], ...
   'Interruptible','off', ...
	'MenuBar','none', ...
	'Name','Volatility Smile', ...
	'NumberTitle','off', ...
	'Position',[0.3 0.3 0.4 0.62], ...
   'ResizeFcn','smilefn(''Resize'');', ...
   'Visible','off', ...
	'Tag','VolatilitySmile');

b = axes('Parent',a, ...
	'Units','points', ...
	'Position',[43.2 122.8 298.8 158], ...
   'Tag','Axes1', ...
   'Interruptible','off', ...
	'Visible','off');

% Modify, Add, Remove, Cancel buttons
b = uicontrol('Parent',a, ...
	'Units','points', ...
	'Callback','smilefn(''ModifyAssetLine'');', ...
   'Interruptible','off', ...
	'Position',[10 2.5 144.5+10 12], ...
	'FontSize', 9, ...
	'String','Modify', ...
	'Tag','PushButtonModify', ...
   'Visible','on');
b = uicontrol('Parent',a, ...
	'Units','points', ...
	'Callback','smilefn(''AddAsset'');', ...
	'CreateFcn','set(findobj(gcbf,''Tag'',''PushButtonAdd''),''Visible'',''Off'');', ...
   'Interruptible','off', ...
	'Position',[10 36 97 12], ...
	'FontSize', 9, ...
	'String','Add', ...
	'Tag','PushButtonAdd', ...
	'UserData',1, ...
   'Visible','off');
b = uicontrol('Parent',a, ...
	'Units','points', ...
	'Callback','smilefn(''RemoveAsset'');', ...
	'CreateFcn','set(findobj(gcbf,''Tag'',''PushButtonRemove''),''Visible'',''Off'');', ...
	'Enable','off', ...
   'Interruptible','off', ...
	'Position',[109.5 36 45+9 12], ...
	'FontSize', 9, ...
	'String','Remove', ...
	'Tag','PushButtonRemove', ...
	'Visible','off');
b = uicontrol('Parent',a, ...
	'Units','points', ...
	'Callback','smilefn(''AssetSetupZero'');', ...
	'CreateFcn','set(findobj(gcbf,''Tag'',''PushButtonCancel''),''Visible'',''Off'');', ...
	'Enable','off', ...
   'Interruptible','off', ...
	'Position',[109.5 36 45+10 12], ...
	'FontSize', 9, ...
	'String','Cancel', ...
	'Tag','PushButtonCancel', ...
	'Visible','off');


% Header text
b = uicontrol('Parent',a, ...
	'Units','points', ...
	'BackgroundColor',[.8 .8 .8], ...
	'CreateFcn','set(findobj(gcbf,''Tag'',''TextPortfolioPrice''),''String'',''Current Portfolio'');', ...
   'Interruptible','off', ...
	'Position',[10 85 144.5+10 9], ...
	'String','Current Portfolio', ...
	'Style','text', ...
   'Tag','TextPortfolioPrice');


% Listbox
b = uicontrol('Parent',a, ...
	'Units','points', ...
	'BackgroundColor',[1 1 1], ...
	'Callback','smilefn(''ChangeAssetListbox'');', ...
	'CreateFcn','set(findobj(gcbf,''Tag'',''Listbox1''),''String'','''');set(findobj(gcbf,''Tag'',''Listbox1''),''Userdata'',[]);', ...
   'Interruptible','off', ...
	'Position',[10 17 144.5+10 67], ...
	'FontSize', 9, ...
	'Style','listbox', ...
	'Tag','Listbox1', ...
   'Value',1);


% Edit inputs
b = uicontrol('Parent',a, ...
	'Units','points', ...
	'BackgroundColor',[1 1 1], ...
	'Callback','if ~isnan(smilefn(''CheckInput'',''EditTextPremium''));smilefn(''SetAssetCost'');end;', ...
	'CreateFcn','set(findobj(gcbf,''Tag'',''EditTextPremium''),''Visible'',''Off'');', ...
   'Interruptible','off', ...
	'Position',[109.5 23.4 45+10 12.3], ...
	'FontSize', 5, ...
	'String','0', ...
	'Style','edit', ...
	'Tag','EditTextPremium', ...
	'UserData',0, ...
	'Visible','off');
b = uicontrol('Parent',a, ...
	'Units','points', ...
	'BackgroundColor',[.8 .8 .8], ...
	'CreateFcn','set(findobj(gcbf,''Tag'',''TextNumShares''),''Visible'',''Off'');', ...
	'ForegroundColor',[0 0 1], ...
	'HorizontalAlignment','right', ...
   'Interruptible','off', ...
	'Position',[10 24 97 11.5], ...
	'FontSize', 9, ...
	'String','Premium', ...
	'Style','text', ...
	'Tag','TextPremium', ...
	'Visible','off');

b = uicontrol('Parent',a, ...
	'Units','points', ...
	'BackgroundColor',[.8 .8 .8], ...
	'CreateFcn','set(findobj(gcbf,''Tag'',''TextStrikePrice''),''Visible'',''Off'');', ...
	'HorizontalAlignment','right', ...
   'Interruptible','off', ...
	'Position',[10 12 97 11.5], ...
	'FontSize', 9, ...
	'String','Strike Price', ...
	'Style','text', ...
	'Tag','TextStrikePrice', ...
   'Visible','off');
b = uicontrol('Parent',a, ...
	'Units','points', ...
	'BackgroundColor',[1 1 1], ...
	'Callback','if ~isnan(smilefn(''CheckInput'',''EditTextStrikePrice''));smilefn(''SetAssetCost'');end;', ...
	'CreateFcn','set(findobj(gcbf,''Tag'',''EditTextStrikePrice''),''Visible'',''Off'');', ...
   'Interruptible','off', ...
	'Position',[109.5 11.4 45+10 12.3], ...
	'FontSize', 5, ...
	'String','100', ...
	'Style','edit', ...
	'Tag','EditTextStrikePrice', ...
	'Visible','off');

b = uicontrol('Parent',a, ...
	'Units','points', ...
	'BackgroundColor',[.8 .8 .8], ...
	'HorizontalAlignment','right', ...
   'Interruptible','off', ...
	'Position',[10 0 97 11.5], ...
	'FontSize', 5, ...
	'String','Years-to-Expiration', ...
	'Style','text', ...
	'Tag','TextExpiration', ...
	'Visible','off');
b = uicontrol('Parent',a, ...
	'Units','points', ...
	'BackgroundColor',[1 1 1], ...
	'Callback','if ~isnan(smilefn(''CheckInput'',''EditTextExpiration''));smilefn(''SetAssetCost'');end;', ...
	'CreateFcn','set(findobj(gcbf,''Tag'',''EditTextExpiration''),''string'',''1.00'');set(findobj(gcbf,''Tag'',''EditTextExpiration''),''Visible'',''Off'');', ...
   'Interruptible','off', ...
	'Position',[109.5 0 45+10 12.3], ...
	'FontSize', 9, ...
	'String','1.00', ...
	'Style','edit', ...
   'Tag','EditTextExpiration', ...
	'Visible','off');


% Information window
b = uicontrol('Parent',a, ...
	'Units','points', ...
	'BackgroundColor',[.8 .8 .8], ...
	'CreateFcn','set(findobj(gcbf,''Tag'',''TextInfoWindow1''),''String'',''  '');', ...
   'Interruptible','off', ...
	'Position',[176.5 5 155 20], ...
	'String',['Select the Add menu to ';'add a new investment.  '], ...
	'Style','text', ...
   'Tag','TextInfoWindow1');


% Common input block
% Header
b = uicontrol('Parent',a, ...
	'Units','points', ...
	'BackgroundColor',[.8 .8 .8], ...
   'Interruptible','off', ...
	'Position',[176.5 84 155 9], ...
	'String','Common Inputs', ...
	'Style','text', ...
	'Tag','TextHeader1');

% Frame
b = uicontrol('Parent',a, ...
	'Units','points', ...
	'BackgroundColor',[.8 .8 .8], ...
   'Interruptible','off', ...
	'Position',[166.5 32 175 50], ...
	'Style','frame', ...
	'Tag','Frame1');

% Text strings
b = uicontrol('Parent',a, ...
	'Units','points', ...
	'BackgroundColor',[.8 .8 .8], ...
	'HorizontalAlignment','right', ...
   'Interruptible','off', ...
	'Position',[170 66 110 12.75], ...
	'FontSize', 9, ...
	'String','Current Asset Price', ...
	'Style','text', ...
	'Tag','TextAssetPrice');
b = uicontrol('Parent',a, ...
	'Units','points', ...
	'BackgroundColor',[.8 .8 .8], ...
	'HorizontalAlignment','right', ...
   'Interruptible','off', ...
	'Position',[170 50.25 110 12.75], ...
	'FontSize', 9, ...
	'String','Annualized Payout Return', ...
	'Style','text', ...
	'Tag','TextAssetReturn');
b = uicontrol('Parent',a, ...
	'Units','points', ...
	'BackgroundColor',[.8 .8 .8], ...
	'HorizontalAlignment','right', ...
   'Interruptible','off', ...
	'Position',[170 34.5 110 13.5], ...
	'FontSize', 9, ...
	'String','Annualized Riskless Return', ...
	'Style','text', ...
	'Tag','TextRisklessReturn');

% Edit texts
mat6='if ~isnan(smilefn(''CheckInput'',''EditTextAssetPrice''));smilefn(''SetAssetCost'');end;smilefn(''PlotPortfolio'');';
b = uicontrol('Parent',a, ...
	'Units','points', ...
	'BackgroundColor',[1 1 1], ...
	'Callback',mat6, ...
	'CreateFcn','set(findobj(gcbf,''Tag'',''EditTextAssetPrice''),''string'',''100'');', ...
   'Interruptible','off', ...
	'Position',[283 66.75 45 12.75], ...
	'FontSize', 9, ...
	'String','100', ...
	'Style','edit', ...
   'Tag','EditTextAssetPrice');

mat7='if ~isnan(smilefn(''CheckInput'',''EditTextAssetReturn''));smilefn(''SetAssetCost'');end;smilefn(''PlotPortfolio'');';
b = uicontrol('Parent',a, ...
	'Units','points', ...
	'BackgroundColor',[1 1 1], ...
	'Callback',mat7, ...
	'CreateFcn','set(findobj(gcbf,''Tag'',''EditTextAssetReturn''),''string'',''1.00'');', ...
   'Interruptible','off', ...
	'Position',[283 51 45 12.75], ...
	'FontSize', 9, ...
	'String','1.00', ...
	'Style','edit', ...
   'Tag','EditTextAssetReturn');

mat8='if ~isnan(smilefn(''CheckInput'',''EditTextRisklessReturn''));smilefn(''SetAssetCost'');end;smilefn(''PlotPortfolio'');';
b = uicontrol('Parent',a, ...
	'Units','points', ...
	'BackgroundColor',[1 1 1], ...
	'Callback',mat8, ...
	'CreateFcn','set(findobj(gcbf,''Tag'',''EditTextRisklessReturn''),''string'',''1.15'');', ...
   'Interruptible','off', ...
	'Position',[283 35.25 45 13.5], ...
	'FontSize', 9, ...
	'String','1.15', ...
	'Style','edit', ...
   'Tag','EditTextRisklessReturn');


% File menu
b = uimenu('Parent',a, ...
	'Label','&File', ...
   'Tag','FileMenu');
c = uimenu('Parent',b, ...
   'Callback','smilefn(''SavePortfolio'');', ...
   'Label','Save Portfolio', ...
	'Tag','FileMenu1');
c = uimenu('Parent',b, ...
	'Callback','smilefn(''LoadPortfolio'');', ...
	'Label','Load Portfolio', ...
	'Tag','FileMenu2');
c = uimenu('Parent',b, ...
	'Callback','print -dsetup', ...
	'Label','Print Setup', ...
	'Separator','on', ...
	'Tag','FileMenu3');
c = uimenu('Parent',b, ...
	'Callback','printfn(gcbf);', ...
	'Label','Print', ...
   'Tag','FileMenu4');
c = uimenu('Parent',b, ...
	'Callback',';', ...
	'Label','Open', ...
	'Separator','on', ...
   'Tag','FileOpen');
d = uimenu('Parent',c, ...
	'Callback','oneopt(1);', ...
	'Label','Black-Scholes Formula', ...
	'Separator','off', ...
   'Tag','FileLaunchBLS');
d = uimenu('Parent',c, ...
	'Callback','oneopt(0);', ...
	'Label','Binomial Trees', ...
	'Separator','off', ...
   'Tag','FileLaunchTree');
d = uimenu('Parent',c, ...
	'Callback','payoff;', ...
	'Label','Profit/Loss Diagram', ...
	'Separator','off', ...
   'Tag','FileLaunchPayoff');
d = uimenu('Parent',c, ...
	'Callback','payoff(''Prob'');', ...
	'Label','Probability Function', ...
	'Separator','off', ...
   'Tag','FileLaunchProb');
d = uimenu('Parent',c, ...
	'Callback','payoff(''CDF'');', ...
	'Label','Cumulative Distribution Function', ...
	'Separator','off', ...
   'Tag','FileLaunchCDF');
d = uimenu('Parent',c, ...
	'Callback','payoff(''Hedging'');', ...
	'Label','Hedging Diagram', ...
	'Separator','off', ...
   'Tag','FileLaunchHedging');
d = uimenu('Parent',c, ...
	'Callback','smile;', ...
	'Label','Implied Volatility Smiles', ...
	'Separator','off', ...
   'Tag','FileLaunchSmiles');
c = uimenu('Parent',b, ...
	'Callback','close(gcbf);', ...
	'Label','Close', ...
	'Separator','on', ...
   'Tag','ClosePayoff');

% Add menu
b = uimenu('Parent',a, ...
	'Label','&Edit', ...
	'Tag','AddMenu');
c = uimenu('Parent',b, ...
	'Callback','smilefn(''SelectAsset'',4);', ...
   'ForeGroundColor',[1 1 0], ...
	'Label','Call', ...
	'Tag','AddMenu4');
c = uimenu('Parent',b, ...
	'Callback','smilefn(''SelectAsset'',5);', ...
	'Label','Put', ...
   'Tag','AddMenu5');
c = uimenu('Parent',b, ...
	'Callback','set(findobj(gcbf,''Tag'',''Listbox1''),''Userdata'',[]);set(findobj(gcbf,''Tag'',''Listbox1''),''String'','''');smilefn(''PlotPortfolio'');', ...
	'Label','Delete All', ...
   'Tag','AddMenu5');

% Plot menu
b = uimenu('Parent',a, ...
	'CreateFcn','set(findobj(gcbf,''Tag'',''PlotMenu''),''Userdata'',1);', ...
	'Label','&Plot', ...
	'Tag','PlotMenu', ...
   'UserData',1);


% Plot asset group 
mat11='set(findobj(gcbf,''Tag'',''PlotMenu1''),''Checked'',''on'');set(findobj(gcbf,''Tag'',''PlotMenu2''),''Checked'',''off'');set(findobj(gcbf,''Tag'',''PlotMenu3''),''Checked'',''off'');smilefn(''PlotPortfolio'');';
c = uimenu('Parent',b, ...
	'Callback',mat11, ...
	'Checked','on', ...
	'CreateFcn','set(findobj(gcbf,''Tag'',''PlotMenu1''),''Checked'',''off'');', ...
	'Label','Calls Only', ...
   'Tag','PlotMenu1');

mat12='set(findobj(gcbf,''Tag'',''PlotMenu1''),''Checked'',''off'');set(findobj(gcbf,''Tag'',''PlotMenu2''),''Checked'',''on'');set(findobj(gcbf,''Tag'',''PlotMenu3''),''Checked'',''off'');smilefn(''PlotPortfolio'');';
c = uimenu('Parent',b, ...
	'Callback',mat12, ...
	'CreateFcn','set(findobj(gcbf,''Tag'',''PlotMenu2''),''Checked'',''off'');', ...
	'Label','Puts Only', ...
   'Tag','PlotMenu2');

mat13='set(findobj(gcbf,''Tag'',''PlotMenu1''),''Checked'',''off'');set(findobj(gcbf,''Tag'',''PlotMenu2''),''Checked'',''off'');set(findobj(gcbf,''Tag'',''PlotMenu3''),''Checked'',''on'');smilefn(''PlotPortfolio'');';
c = uimenu('Parent',b, ...
	'Callback',mat13, ...
	'CreateFcn','set(findobj(gcbf,''Tag'',''PlotMenu3''),''Checked'',''on'');', ...
	'Label','Both Calls and Puts', ...
   'Tag','PlotMenu3');

mat14='set(findobj(gcbf,''Tag'',''PlotMenu5''),''Checked'',''off'');set(findobj(gcbf,''Tag'',''PlotMenu4''),''Checked'',''on'');smilefn(''PlotPortfolio'');';
c = uimenu('Parent',b, ...
	'Callback',mat14, ...
	'CreateFcn','set(findobj(gcbf,''Tag'',''PlotMenu4''),''Checked'',''off'');', ...
   'Label','Same Years-To-Expiration', ...
	'Separator','on', ...
   'Tag','PlotMenu4');

mat15='set(findobj(gcbf,''Tag'',''PlotMenu4''),''Checked'',''off'');set(findobj(gcbf,''Tag'',''PlotMenu5''),''Checked'',''on'');smilefn(''PlotPortfolio'');';
c = uimenu('Parent',b, ...
	'Callback',mat15, ...
	'CreateFcn','set(findobj(gcbf,''Tag'',''PlotMenu5''),''Checked'',''on'');', ...
   'Label','All Years-To-Expiration', ...
   'Tag','PlotMenu5');


% Axis menu
b = uimenu('Parent',a, ...
	'Label','&Axis', ...
   'Tag','MenuAxis');

CallbackAxisTool = [... 
'if strcmp(lower(get(findobj(gcbf,''Tag'',''MenuAxisTool''),''Checked'')),''on'')==1;', ...
'  set(findobj(gcbf,''Tag'',''MenuAxisTool''),''Checked'',''off'');', ...
'  close(get(findobj(gcbf,''Tag'',''MenuAxisTool''),''Userdata''));', ...
'else;', ...
'  set(findobj(gcbf,''Tag'',''MenuAxisTool''),''Checked'',''on'');', ...
'  set(findobj(gcbf,''Tag'',''MenuAxisTool''),''Userdata'',axisgui(gca));', ...
'end;', ...
];

% Userdata contains the handle for the resize figure
c = uimenu('Parent',b, ...
	'Callback', CallbackAxisTool, ...
	'CreateFcn','set(findobj(gcbf,''Tag'',''MenuAxisTool''),''Checked'',''off'');', ...
   'DeleteFcn','if strcmp(lower(get(findobj(gcbf,''Tag'',''MenuAxisTool''),''Checked'')),''on'')==1;FigHandle=get(findobj(gcbf,''Tag'',''MenuAxisTool''),''Userdata'');close(FigHandle);end;', ...
   'Label','Axis Tool', ...
   'Userdata', [], ...
   'Tag','MenuAxisTool');

c = uimenu('Parent',b, ...
	'Callback','grid on;set(findobj(gcbf,''Tag'',''MenuGridOn''),''Checked'',''on'');set(findobj(gcbf,''Tag'',''MenuGridOff''),''Checked'',''off'');', ...
	'CreateFcn','set(findobj(gcbf,''Tag'',''MenuGridOn''),''Checked'',''off'');', ...
	'Label','Grid On', ...
	'Separator','on', ...
	'Tag','MenuGridOn');
c = uimenu('Parent',b, ...
	'Callback','grid off;set(findobj(gcbf,''Tag'',''MenuGridOn''),''Checked'',''off'');set(findobj(gcbf,''Tag'',''MenuGridOff''),''Checked'',''on'');', ...
	'CreateFcn','grid off;set(findobj(gcbf,''Tag'',''MenuGridOff''),''Checked'',''on'');', ...
	'Label','Grid Off', ...
   'Tag','MenuGridOff');

b = uimenu('Parent',a, ...
   'Label','&Examples', ...
   'Tag','ExamplesMenu');
c = uimenu('Parent',b, ...
   'Callback','smilefn(''Example1'');', ...
   'Label','Example 1', ...
   'Tag','ExampleMenu1');


b = uimenu('Parent',a, ...
	'Label','&About', ...
	'Tag','AboutMenu', ...
   'Visible', 'off');
c = uimenu('Parent',b, ...
	'Callback','gpabout;', ...
	'Label','About', ...
	'Tag','AboutMenu1');


b = uimenu('Parent',a, ...
	'Label','&Help', ...
	'Tag','HelpMenu');
c = uimenu('Parent',b, ...
   'CreateFcn',['set(findobj(gcbf,''Tag'',''HelpMenu1''),''Checked'',''off'');', ...
      'smilefn(''Initialize'');'], ...
	'Callback','if strcmp(lower(get(findobj(gcbf,''Tag'',''HelpMenu1''),''Checked'')),''off'')==1;set(findobj(gcbf,''Tag'',''HelpMenu1''),''Checked'',''on'');set(findobj(gcbf,''Tag'',''HelpMenu''),''Userdata'',smileh);else;set(findobj(gcbf,''Tag'',''HelpMenu1''),''Checked'',''off'');close(get(findobj(gcbf,''Tag'',''HelpMenu''),''Userdata''));end', ...
	'Label','Help', ...
	'Tag','HelpMenu1');

if Input1 > 0
   smilefn('Example1');
end