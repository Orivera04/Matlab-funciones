function fig = bdtdemo()
%BDTDEMO Black-Derman-Toy Interest Rate Option Pricing Model GUI Demo.
%

% Author: C. Bassignani, 05-20-98 
% Copyright 1995-2002 The MathWorks, Inc. 
% $Revision: 1.9 $   $Date: 2002/04/14 21:47:05 $

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%    This is private file of the BDT Demo and is not meant to be called
%    directly by the user.
%

ScreenSize = get(0, 'ScreenSize');

load bdtdemo

h0 = figure('Color',[0.8 0.8 0.8], ...
	'Colormap',mat0, ...
	'CreateFcn', strcat(['global GDURATIONFLAG; '...
          'global GCONVEXITYFLAG; global GVEGAFLAG; '...
          'GDURATIONFLAG = 0; GCONVEXITYFLAG = 0; GVEGAFLAG = 0; '...
          'global GACCURACY;' ...
          'GACCURACY = 2;' ...
          'global GBONDSPECFLAG; '...
          'global GCALCPRICEFLAG; '...
          'GCALCPRICEFLAG = 0; '...
          'GBONDSPECFLAG = 0;']), ...
	'Position',[(ScreenSize(3)-725)/2 (ScreenSize(4)-700)/2 725 700], ...
	'Resize','off', ...
	'NumberTitle', 'off', ...
	'Name', 'Demo: BDT Interest Rate Option Pricing', ...
	'Tag','MainGUI', ...
	'UserData','VegaFlag');
h1 = uimenu('Parent',h0, ...
	'HandleVisibility','off', ...
	'Label','&Tools', ...
	'Tag','scrPlotToolsMenu');
h2 = uimenu('Parent',h1, ...
	'Callback','plotedit(gcbf,''toggletoolbar'')', ...
	'HandleVisibility','off', ...
	'Label','&Show Plot Tools', ...
	'Tag','scrShowToolbar');
h2 = uimenu('Parent',h1, ...
	'Callback','plotedit(gcbf,''showlegend'')', ...
	'Enable','off', ...
	'HandleVisibility','off', ...
	'Label','Show &Legend', ...
	'Tag','scrShowLegend');
h2 = uimenu('Parent',h1, ...
	'Callback','propedit', ...
	'HandleVisibility','off', ...
	'Label','Show Graphics Property E&ditor', ...
	'Separator','on', ...
	'Tag','scrShowPropEdit');
h2 = uimenu('Parent',h1, ...
	'Callback','guide', ...
	'HandleVisibility','off', ...
	'Label','Show &GUI Layout Tool', ...
	'Tag','scrShowGUIDE');
h1 = axes('Parent',h0, ...
	'Units','pixels', ...
	'CameraUpVector',[0 1 0], ...
	'CameraUpVectorMode','manual', ...
	'Color',[1 1 1], ...
	'ColorOrder',mat2, ...
	'Position',[393 349 304 147], ...
	'Tag','AxesTree', ...
	'XColor',[0 0 0], ...
	'XTickLabelMode','manual', ...
	'XTickMode','manual', ...
	'YColor',[0 0 0], ...
	'YTickLabelMode','manual', ...
	'YTickMode','manual', ...
	'ZColor',[0 0 0]);
h2 = text('Parent',h1, ...
	'ButtonDownFcn','ctlpanel SelectMoveResize', ...
	'Color',[0 0 0], ...
	'HandleVisibility','off', ...
	'HorizontalAlignment','center', ...
	'Interruptible','off', ...
	'Position',[0.4983498349834985 -0.05479452054794498 9.160254037844386], ...
	'Tag','Axes1Text4', ...
	'VerticalAlignment','cap');
set(get(h2,'Parent'),'XLabel',h2);
h2 = text('Parent',h1, ...
	'ButtonDownFcn','ctlpanel SelectMoveResize', ...
	'Color',[0 0 0], ...
	'HandleVisibility','off', ...
	'HorizontalAlignment','center', ...
	'Interruptible','off', ...
	'Position',[-0.02310231023102305 0.493150684931507 9.160254037844386], ...
	'Rotation',90, ...
	'Tag','Axes1Text3', ...
	'VerticalAlignment','baseline');
set(get(h2,'Parent'),'YLabel',h2);
h2 = text('Parent',h1, ...
	'ButtonDownFcn','ctlpanel SelectMoveResize', ...
	'Color',[0 0 0], ...
	'HandleVisibility','off', ...
	'HorizontalAlignment','right', ...
	'Interruptible','off', ...
	'Position',[-1.297029702970297 2.349315068493151 9.160254037844386], ...
	'Tag','Axes1Text2', ...
	'Visible','off');
set(get(h2,'Parent'),'ZLabel',h2);
h2 = text('Parent',h1, ...
	'ButtonDownFcn','ctlpanel SelectMoveResize', ...
	'Color',[0 0 0], ...
	'HandleVisibility','off', ...
	'HorizontalAlignment','center', ...
	'Interruptible','off', ...
	'Position',[0.4983498349834985 1.047945205479452 9.160254037844386], ...
	'Tag','Axes1Text1', ...
	'VerticalAlignment','bottom');
set(get(h2,'Parent'),'Title',h2);
h1 = uicontrol('Parent',h0, ...
	'Units','points', ...
	'BackgroundColor',get(0, 'DefaultFigureColor'), ...
	'FontWeight','bold', ...
	'HorizontalAlignment','left', ...
	'ListboxTop',0, ...
	'Position',[8.25 68.25 116.25 12], ...
	'String','Status', ...
	'Style','text', ...
	'Tag','StaticText1');
h1 = uicontrol('Parent',h0, ...
	'Units','points', ...
	'BackgroundColor',get(0, 'DefaultFigureColor'), ...
	'FontWeight','bold', ...
	'HorizontalAlignment','left', ...
	'ListboxTop',0, ...
	'Position',[7.5 280.25 116.25 12], ...
	'String','Volatility Curve', ...
	'Style','text', ...
	'Tag','StaticText1');
h1 = uicontrol('Parent',h0, ...
	'Units','points', ...
	'BackgroundColor',[0.752941176470588 0.752941176470588 0.752941176470588], ...
	'FontSize',14, ...
	'FontWeight','bold', ...
	'ForegroundColor',[0 0.501960784313725 1], ...
	'HorizontalAlignment','left', ...
	'ListboxTop',0, ...
	'Position',[8.25 495 522 20.25], ...
	'String','BDT Interest Rate Option Pricing', ...
	'Style','text', ...
	'Tag','StaticText2');
h1 = uicontrol('Parent',h0, ...
	'Units','points', ...
     'Callback',...
     strcat(['global GBONDSPECFLAG; if (GBONDSPECFLAG == 1), '...
          'bdtmainaction loadvolatilitycurve; end']), ...
	'ListboxTop',0, ...
	'Position',[204 251.25 79.5 17.25], ...
	'String','From File', ...
	'Tag','Pushbutton1');
h1 = uicontrol('Parent',h0, ...
	'Units','points', ...
     'Callback',...
     strcat(['global GBONDSPECFLAG; if (GBONDSPECFLAG == 1), '...
          'bdtmainaction specvolatilitycrv; end']), ...
	'ListboxTop',0, ...
	'Position',[204 228.75 79.5 17.25], ...
	'String','Specify/Edit', ...
	'Tag','Pushbutton1');
h1 = uicontrol('Parent',h0, ...
	'Units','points', ...
     'Callback',...
     strcat(['global GBONDSPECFLAG; if (GBONDSPECFLAG == 1), '...
          'bdtmainaction loadcreditcurve; end']), ...
	'ListboxTop',0, ...
	'Position',[204 153 79.5 17.25], ...
	'String','From File', ...
	'Tag','Pushbutton1');
h1 = uicontrol('Parent',h0, ...
	'Units','points', ...
     'Callback',...
     strcat(['global GBONDSPECFLAG; if (GBONDSPECFLAG == 1), '...
          'bdtmainaction speccreditcrv; end']), ...
	'ListboxTop',0, ...
	'Position',[204 130.5 79.5 17.25], ...
	'String','Specify/Edit', ...
	'Tag','Pushbutton1');


% Model Specification settings...
h1 = uicontrol('Parent',h0, ...
	'Units','points', ...
	'BackgroundColor',[0.752941176470588 0.752941176470588 0.752941176470588]*0.8, ...
	'FontWeight','bold', ...
	'ListboxTop',0, ...
	'Position',[310 465 100 25], ...
	'String',{'Model'; 'Specification'}, ...
	'Style','text', ...
	'Tag','StaticText1');
h1 = uicontrol('Parent',h0, ...
	'Units','points', ...
	'BackgroundColor',[0.752941176470588 0.752941176470588 0.752941176470588], ...
	'ListboxTop',0, ...
	'Position',[310 390 100 75], ...
	'String','', ...
	'Style','text', ...
	'Tag','fillers');
h1 = uicontrol('Parent',h0, ...
	'Units','points', ...
	'BackgroundColor',[0.752941176470588 0.752941176470588 0.752941176470588], ...
	'ListboxTop',0, ...
	'Position',[310 423 50 15], ...
	'String','Accuracy:', ...
	'Style','text', ...
	'Tag','StaticText3');
h1 = uicontrol('Parent',h0, ...
	'Units','points', ...
	'ButtonDownFcn','     ', ...
	'Callback',mat3, ...
	'ListboxTop',0, ...
	'Min',0.1, ...
	'Position',[387 395 16 65], ...
	'SliderStep',[0.1 0.11], ...
	'Style','slider', ...
	'Tag','Slider1', ...
   'Value',0.2);
EditCallBack = strcat('SliderHandle = findobj(''Tag'', ''Slider1'');', ...
     'global GACCURACY;', ...
     'Accuracy = str2double(get(gcbo,''String''));', ...
     'if isnan(Accuracy), Accuracy = 2; end;', ...
     'GACCURACY = Accuracy;', ...
     'set(SliderHandle,''Value'',Accuracy/10);');
	% This generates a syntax error for some reason 8/31/98 JHA
h1 = uicontrol('Parent',h0, ...
	'Units','points', ...
	'BackgroundColor',[1 1 1], ...
	'ListboxTop',0, ...
	'Position',[365 423 20 15], ...
	'String','2', ...
	'Style','edit', ...
   'Tag','EditAccuracy', ...
   'Callback',EditCallBack);

% Sensitivity Specification Settings...
h1 = uicontrol('Parent',h0, ...
	'Units','points', ...
	'BackgroundColor',[0.752941176470588 0.752941176470588 0.752941176470588]*0.8, ...
	'FontWeight','bold', ...
	'ListboxTop',0, ...
	'Position',[415 465 100 25], ...
	'String',{'Sensitivity'; 'Specification'}, ...
	'Style','text', ...
	'Tag','StaticText1');
h1 = uicontrol('Parent',h0, ...
	'Units','points', ...
	'BackgroundColor',[0.752941176470588 0.752941176470588 0.752941176470588], ...
	'ListboxTop',0, ...
	'Position',[415 455 100 10], ...
	'String','', ...
	'Style','text', ...
	'Tag','fillers');
h1 = uicontrol('Parent',h0, ...
	'Units','points', ...
	'BackgroundColor',[0.752941176470588 0.752941176470588 0.752941176470588], ...
	'ListboxTop',0, ...
	'Position',[415 437.5 20 17.5], ...
	'String','', ...
	'Style','text', ...
	'Tag','fillers');
h1 = uicontrol('Parent',h0, ...
	'Units','points', ...
	'BackgroundColor',[0.752941176470588 0.752941176470588 0.752941176470588], ...
	'Callback',mat10, ...
	'ListboxTop',0, ...
	'Position',[435 437.5 80 17.5], ...
	'String','Duration', ...
	'Style','checkbox', ...
	'Tag','CheckBox1');
h1 = uicontrol('Parent',h0, ...
	'Units','points', ...
	'BackgroundColor',[0.752941176470588 0.752941176470588 0.752941176470588], ...
	'ListboxTop',0, ...
	'Position',[415 420 20 17.5], ...
	'String','', ...
	'Style','text', ...
	'Tag','fillers');
h1 = uicontrol('Parent',h0, ...
	'Units','points', ...
	'BackgroundColor',[0.752941176470588 0.752941176470588 0.752941176470588], ...
	'Callback',mat8, ...
	'ListboxTop',0, ...
	'Position',[435 420 80 17.5], ...
	'String','Convexity', ...
	'Style','checkbox', ...
	'Tag','CheckBox1');
h1 = uicontrol('Parent',h0, ...
	'Units','points', ...
	'BackgroundColor',[0.752941176470588 0.752941176470588 0.752941176470588], ...
	'ListboxTop',0, ...
	'Position',[415 403.5 20 17.5], ...
	'String','', ...
	'Style','text', ...
	'Tag','fillers');
h1 = uicontrol('Parent',h0, ...
	'Units','points', ...
	'BackgroundColor',[0.752941176470588 0.752941176470588 0.752941176470588], ...
	'Callback',mat9, ...
	'ListboxTop',0, ...
	'Position',[435 403.5 80 17.5], ...
	'String','Vega', ...
	'Style','checkbox', ...
	'Tag','CheckBox1');
h1 = uicontrol('Parent',h0, ...
	'Units','points', ...
	'BackgroundColor',[0.752941176470588 0.752941176470588 0.752941176470588], ...
	'Callback',mat8, ...
	'ListboxTop',0, ...
	'Position',[415 390 100 13.5], ...
	'String','', ...
	'Style','text', ...
	'Tag','fillers');


h1 = uicontrol('Parent',h0, ...
	'Units','points', ...
	'BackgroundColor',get(0, 'DefaultFigureColor'), ...
	'FontWeight','bold', ...
	'HorizontalAlignment','left', ...
	'ListboxTop',0, ...
	'Position',[11.25 475.5 130.25 12], ...
	'String','Option Embedded Bond', ...
	'Style','text', ...
	'Tag','StaticText1');
h1 = uicontrol('Parent',h0, ...
	'Units','points', ...
	'Callback','bdtmainaction specifybondparams', ...
	'ListboxTop',0, ...
	'Position',[204 433.5 78 15.75], ...
	'String','Specify/Edit', ...
	'Tag','Pushbutton3');
h1 = uicontrol('Parent',h0, ...
	'Units','points', ...
	'Callback','bdtmainaction loadbond', ...
	'ListboxTop',0, ...
	'Position',[204 454.5 78 15.75], ...
	'String','From File', ...
	'Tag','Pushbutton3');

h1 = axes('Parent',h0, ...
	'Units','pixels', ...
	'CameraUpVector',[0 1 0], ...
	'CameraUpVectorMode','manual', ...
	'Color',[1 1 1], ...
	'ColorOrder',mat4, ...
	'Position',[15 530 252 103], ...
	'Tag','AxesBond', ...
	'XColor',[0 0 0], ...
	'XTickLabelMode','manual', ...
	'XTickMode','manual', ...
	'YColor',[0 0 0], ...
	'YTickLabelMode','manual', ...
	'YTickMode','manual', ...
	'ZColor',[0 0 0]);
h2 = text('Parent',h1, ...
	'ButtonDownFcn','ctlpanel SelectMoveResize', ...
	'Color',[0 0 0], ...
	'HandleVisibility','off', ...
	'HorizontalAlignment','center', ...
	'Interruptible','off', ...
	'Position',[0.49800796812749 -0.07843137254901955 9.160254037844386], ...
	'Tag','Axes1Text4', ...
	'VerticalAlignment','cap');
set(get(h2,'Parent'),'XLabel',h2);
h2 = text('Parent',h1, ...
	'ButtonDownFcn','ctlpanel SelectMoveResize', ...
	'Color',[0 0 0], ...
	'HandleVisibility','off', ...
	'HorizontalAlignment','center', ...
	'Interruptible','off', ...
	'Position',[-0.02788844621513944 0.4901960784313726 9.160254037844386], ...
	'Rotation',90, ...
	'Tag','Axes1Text3', ...
	'VerticalAlignment','baseline');
set(get(h2,'Parent'),'YLabel',h2);
h2 = text('Parent',h1, ...
	'ButtonDownFcn','ctlpanel SelectMoveResize', ...
	'Color',[0 0 0], ...
	'HandleVisibility','off', ...
	'HorizontalAlignment','right', ...
	'Interruptible','off', ...
	'Position',[-0.0597609561752988 1.588235294117647 9.160254037844386], ...
	'Tag','Axes1Text2', ...
	'Visible','off');
set(get(h2,'Parent'),'ZLabel',h2);
h2 = text('Parent',h1, ...
	'ButtonDownFcn','ctlpanel SelectMoveResize', ...
	'Color',[0 0 0], ...
	'HandleVisibility','off', ...
	'HorizontalAlignment','center', ...
	'Interruptible','off', ...
	'Position',mat5, ...
	'Tag','Axes1Text1', ...
	'VerticalAlignment','bottom');
set(get(h2,'Parent'),'Title',h2);
h1 = axes('Parent',h0, ...
	'Units','pixels', ...
	'CameraUpVector',[0 1 0], ...
	'CameraUpVectorMode','manual', ...
	'Color',[1 1 1], ...
	'ColorOrder',mat6, ...
	'Position',[11 269 252 103], ...
	'Tag','AxesVolatilityCurve', ...
	'XColor',[0 0 0], ...
	'XTickLabelMode','manual', ...
	'XTickMode','manual', ...
	'YColor',[0 0 0], ...
	'YTickLabelMode','manual', ...
	'YTickMode','manual', ...
	'ZColor',[0 0 0]);
h2 = text('Parent',h1, ...
	'ButtonDownFcn','ctlpanel SelectMoveResize', ...
	'Color',[0 0 0], ...
	'HandleVisibility','off', ...
	'HorizontalAlignment','center', ...
	'Interruptible','off', ...
	'Position',[0.49800796812749 -0.07843137254901933 9.160254037844386], ...
	'Tag','Axes1Text4', ...
	'VerticalAlignment','cap');
set(get(h2,'Parent'),'XLabel',h2);
h2 = text('Parent',h1, ...
	'ButtonDownFcn','ctlpanel SelectMoveResize', ...
	'Color',[0 0 0], ...
	'HandleVisibility','off', ...
	'HorizontalAlignment','center', ...
	'Interruptible','off', ...
	'Position',[-0.02788844621513944 0.490196078431373 9.160254037844386], ...
	'Rotation',90, ...
	'Tag','Axes1Text3', ...
	'VerticalAlignment','baseline');
set(get(h2,'Parent'),'YLabel',h2);
h2 = text('Parent',h1, ...
	'ButtonDownFcn','ctlpanel SelectMoveResize', ...
	'Color',[0 0 0], ...
	'HandleVisibility','off', ...
	'HorizontalAlignment','right', ...
	'Interruptible','off', ...
	'Position',[-0.04382470119521912 4.147058823529412 9.160254037844386], ...
	'Tag','Axes1Text2', ...
	'Visible','off');
set(get(h2,'Parent'),'ZLabel',h2);
h2 = text('Parent',h1, ...
	'ButtonDownFcn','ctlpanel SelectMoveResize', ...
	'Color',[0 0 0], ...
	'HandleVisibility','off', ...
	'HorizontalAlignment','center', ...
	'Interruptible','off', ...
	'Position',mat7, ...
	'Tag','Axes1Text1', ...
	'VerticalAlignment','bottom');
set(get(h2,'Parent'),'Title',h2);
h1 = uicontrol('Parent',h0, ...
	'Units','points', ...
	'BackgroundColor',[1 1 1], ...
	'ListboxTop',0, ...
	'Position',[451.5 185.25 71.25 21.75], ...
	'Style','edit', ...
	'Tag','EditOptionEmbedPrice');
h1 = uicontrol('Parent',h0, ...
	'Units','points', ...
	'BackgroundColor',[1 1 1], ...
	'ListboxTop',0, ...
	'Position',[451.5 159.75 71.25 21.75], ...
	'Style','edit', ...
	'Tag','EditEffDuration');
h1 = uicontrol('Parent',h0, ...
	'Units','points', ...
	'BackgroundColor',[1 1 1], ...
	'ListboxTop',0, ...
	'Position',[372 159.75 71.25 21.75], ...
	'Style','edit', ...
	'Tag','EditDuration');
h1 = uicontrol('Parent',h0, ...
	'Units','points', ...
	'BackgroundColor',[1 1 1], ...
	'ListboxTop',0, ...
	'Position',[451.5 55.5 71.25 21.75], ...
	'Style','edit', ...
	'Tag','EditOASpread');
h1 = uicontrol('Parent',h0, ...
	'Units','points', ...
	'BackgroundColor',[1 1 1], ...
	'ListboxTop',0, ...
	'Position',[451.5 81.75 71.25 21.75], ...
	'Style','edit', ...
	'Tag','EditEffYield');
h1 = uicontrol('Parent',h0, ...
	'Units','points', ...
	'BackgroundColor',[1 1 1], ...
	'ListboxTop',0, ...
	'Position',[372 185.25 71.25 21.75], ...
	'Style','edit', ...
	'Tag','EditOptionFreePrice');
h1 = uicontrol('Parent',h0, ...
	'Units','points', ...
	'BackgroundColor',get(0, 'DefaultFigureColor'), ...
	'FontWeight','bold', ...
	'ListboxTop',0, ...
	'Position',[372.75 210 71.25 15], ...
	'String','No Options', ...
	'Style','text', ...
	'Tag','StaticText4');
h1 = uicontrol('Parent',h0, ...
	'Units','points', ...
	'BackgroundColor',get(0, 'DefaultFigureColor'), ...
	'FontWeight','bold', ...
	'ListboxTop',0, ...
	'Position',[452.25 210 71.25 15], ...
	'String','+ Options', ...
	'Style','text', ...
	'Tag','StaticText4');

h1 = uicontrol('Parent',h0, ...
	'Units','points', ...
	'BackgroundColor',get(0, 'DefaultFigureColor'), ...
	'FontSize',9, ...
	'FontWeight','bold', ...
	'ListboxTop',0, ...
	'Position',[296.25 185 71.25 18.75], ...
	'String','Price', ...
	'Style','text', ...
	'HorizontalAlignment','right', ...
	'Tag','StaticText4');
h1 = uicontrol('Parent',h0, ...
	'Units','points', ...
	'BackgroundColor',get(0, 'DefaultFigureColor'), ...
	'FontSize',9, ...
	'FontWeight','bold', ...
	'ListboxTop',0, ...
	'Position',[296.25 159 71.25 18.75], ...
	'String','Duration', ...
	'Style','text', ...
	'HorizontalAlignment','right', ...
	'Tag','StaticText4');
h1 = uicontrol('Parent',h0, ...
	'Units','points', ...
	'BackgroundColor',get(0, 'DefaultFigureColor'), ...
	'FontSize',9, ...
	'FontWeight','bold', ...
	'ListboxTop',0, ...
	'Position',[296.25 133 71.25 18.75], ...
	'String','Convexity', ...
	'Style','text', ...
	'HorizontalAlignment','right', ...
	'Tag','StaticText4');
h1 = uicontrol('Parent',h0, ...
	'Units','points', ...
	'BackgroundColor',get(0, 'DefaultFigureColor'), ...
	'FontSize',9, ...
	'FontWeight','bold', ...
	'ListboxTop',0, ...
	'Position',[296.25 107 71.25 18.75], ...
	'String','Vega', ...
	'Style','text', ...
	'HorizontalAlignment','right', ...
	'Tag','StaticText4');
h1 = uicontrol('Parent',h0, ...
	'Units','points', ...
	'BackgroundColor',get(0, 'DefaultFigureColor'), ...
	'FontSize',9, ...
	'FontWeight','bold', ...
	'ListboxTop',0, ...
	'Position',[295.5 81 71.25 18.75], ...
	'String','Yield', ...
	'Style','text', ...
	'HorizontalAlignment','right', ...
	'Tag','StaticText4');
h1 = uicontrol('Parent',h0, ...
	'Units','points', ...
	'BackgroundColor',get(0, 'DefaultFigureColor'), ...
	'FontSize',9, ...
	'FontWeight','bold', ...
	'ListboxTop',0, ...
	'Position',[296.25 55 71.25 18.75], ...
	'String','Spread', ...
	'Style','text', ...
	'HorizontalAlignment','right', ...
	'Tag','StaticText4');


h1 = uicontrol('Parent',h0, ...
	'Units','points', ...
	'BackgroundColor',[1 1 1], ...
	'ListboxTop',0, ...
	'Position',[372 81.75 71.25 21.75], ...
	'Style','edit', ...
	'Tag','EditYield');
h1 = uicontrol('Parent',h0, ...
	'Units','points', ...
	'ListboxTop',0, ...
	'Position',[372 55.5 71.25 21.75], ...
	'Style','frame', ...
	'Tag','Frame1');
h1 = uicontrol('Parent',h0, ...
	'Units','points', ...
     'Callback',...
     strcat(['global GBONDSPECFLAG; if (GBONDSPECFLAG == 1), '...
          'bdtmainaction viewvolatilitycrv; end']), ...
	'ListboxTop',0, ...
	'Position',[131.25 180.75 64.5 18], ...
	'String','View Curve', ...
	'Tag','Pushbutton4');
h1 = uicontrol('Parent',h0, ...
	'Units','points', ...
     'Callback',...
     strcat(['global GBONDSPECFLAG; if (GBONDSPECFLAG == 1), '...
          'bdtmainaction viewbdttree; end']), ...
	'ListboxTop',0, ...
	'Position',[456.75 240 64.5 18], ...
	'String','View Tree', ...
	'Tag','Pushbutton4');
h1 = uicontrol('Parent',h0, ...
	'Units','points', ...
     'Callback',...
     strcat(['global GBONDSPECFLAG; if (GBONDSPECFLAG == 1), '...
          'bdtmainaction viewbond; end']), ...
	'ListboxTop',0, ...
	'Position',[134.25 378 64.5 18], ...
	'String','View Bond', ...
	'Tag','Pushbutton4');
h1 = uicontrol('Parent',h0, ...
	'Units','points', ...
     'Callback',...
     strcat(['global GBONDSPECFLAG; if (GBONDSPECFLAG == 1), '...
          'bdtmainaction viewcreditcrv; end']), ...
	'ListboxTop',0, ...
	'Position',[132.75 80.25 64.5 18], ...
	'String','View Curve', ...
	'Tag','Pushbutton4');
h1 = uicontrol('Parent',h0, ...
	'Units','points', ...
	'BackgroundColor',get(0, 'DefaultFigureColor'), ...
	'FontWeight','bold', ...
	'HorizontalAlignment','left', ...
	'ListboxTop',0, ...
	'Position',[8.25 180 116.25 12], ...
	'String','Credit Curve', ...
	'Style','text', ...
	'Tag','StaticText1');
h1 = axes('Parent',h0, ...
	'Units','pixels', ...
	'CameraUpVector',[0 1 0], ...
	'CameraUpVectorMode','manual', ...
	'Color',[1 1 1], ...
	'ColorOrder',mat11, ...
	'Position',[12 136 252 103], ...
	'Tag','AxesCreditCurve', ...
	'XColor',[0 0 0], ...
	'XTickLabelMode','manual', ...
	'XTickMode','manual', ...
	'YColor',[0 0 0], ...
	'YTickLabelMode','manual', ...
	'YTickMode','manual', ...
	'ZColor',[0 0 0]);
h2 = text('Parent',h1, ...
	'ButtonDownFcn','ctlpanel SelectMoveResize', ...
	'Color',[0 0 0], ...
	'HandleVisibility','off', ...
	'HorizontalAlignment','center', ...
	'Interruptible','off', ...
	'Position',[0.49800796812749 -0.07843137254901933 9.160254037844386], ...
	'Tag','Axes1Text4', ...
	'VerticalAlignment','cap');
set(get(h2,'Parent'),'XLabel',h2);
h2 = text('Parent',h1, ...
	'ButtonDownFcn','ctlpanel SelectMoveResize', ...
	'Color',[0 0 0], ...
	'HandleVisibility','off', ...
	'HorizontalAlignment','center', ...
	'Interruptible','off', ...
	'Position',[-0.02788844621513945 0.4901960784313726 9.160254037844386], ...
	'Rotation',90, ...
	'Tag','Axes1Text3', ...
	'VerticalAlignment','baseline');
set(get(h2,'Parent'),'YLabel',h2);
h2 = text('Parent',h1, ...
	'ButtonDownFcn','ctlpanel SelectMoveResize', ...
	'Color',[0 0 0], ...
	'HandleVisibility','off', ...
	'HorizontalAlignment','right', ...
	'Interruptible','off', ...
	'Position',[-0.04780876494023904 5.450980392156863 9.160254037844386], ...
	'Tag','Axes1Text2', ...
	'Visible','off');
set(get(h2,'Parent'),'ZLabel',h2);
h2 = text('Parent',h1, ...
	'ButtonDownFcn','ctlpanel SelectMoveResize', ...
	'Color',[0 0 0], ...
	'HandleVisibility','off', ...
	'HorizontalAlignment','center', ...
	'Interruptible','off', ...
	'Position',[0.49800796812749 1.068627450980392 9.160254037844386], ...
	'Tag','Axes1Text1', ...
	'VerticalAlignment','bottom');
set(get(h2,'Parent'),'Title',h2);
h1 = uicontrol('Parent',h0, ...
	'Units','points', ...
	'BackgroundColor',[1 1 1], ...
	'HorizontalAlignment','left', ...
	'ListboxTop',0, ...
	'Position',[8.25 43.5 188.25 21.75], ...
	'Style','edit', ...
	'Tag','EditErrorMessage');
h1 = uicontrol('Parent',h0, ...
	'Units','points', ...
	'BackgroundColor',get(0, 'DefaultFigureColor'), ...
	'FontWeight','bold', ...
	'HorizontalAlignment','left', ...
	'ListboxTop',0, ...
	'Position',[297.75 373 116.25 12], ...
	'String','Binomial Tree', ...
	'Style','text', ...
	'Tag','StaticText1');
h1 = uicontrol('Parent',h0, ...
	'Units','points', ...
	'Callback','bdtmainaction calcprice;', ...
	'FontWeight','bold', ...
	'ListboxTop',0, ...
	'Position',[250 10 125 30], ...
	'String','CALCULATE PRICE', ...
	'Tag','Pushbutton2');
h1 = uicontrol('Parent',h0, ...
	'Units','points', ...
	'Callback','bdtmainaction calcyield;', ...
	'FontWeight','bold', ...
	'ListboxTop',0, ...
	'Position',[380 10 125 30], ...
	'String','CALCULATE YIELD', ...
	'Tag','Pushbutton2');
h1 = uicontrol('Parent',h0, ...
	'Units','points', ...
	'BackgroundColor',[1 1 1], ...
	'ListboxTop',0, ...
	'Position',[372 132.75 71.25 21.75], ...
	'Style','edit', ...
	'Tag','EditConvexity');
h1 = uicontrol('Parent',h0, ...
	'Units','points', ...
	'BackgroundColor',[1 1 1], ...
	'ListboxTop',0, ...
	'Position',[451.5 132.75 71.25 21.75], ...
	'Style','edit', ...
	'Tag','EditEffConvexity');
h1 = uicontrol('Parent',h0, ...
	'Units','points', ...
	'ListboxTop',0, ...
	'Position',[372 107.25 71.25 21.75], ...
	'Style','frame', ...
	'Tag','Frame1');
h1 = uicontrol('Parent',h0, ...
	'Units','points', ...
	'BackgroundColor',[1 1 1], ...
	'ListboxTop',0, ...
	'Position',[451.5 107.25 71.25 21.75], ...
	'Style','edit', ...
	'Tag','EditVega');
h1 = uicontrol('Parent',h0, ...
	'Units','points', ...
     'Callback',...
     strcat(['global GBONDSPECFLAG; if (GBONDSPECFLAG == 1), '...
          'bdtmainaction viewzerocrv; end']), ...
	'ListboxTop',0, ...
	'Position',[132.75 279.75 64.5 18], ...
	'String','View Curve', ...
	'Tag','Pushbutton4');
h1 = axes('Parent',h0, ...
	'Units','pixels', ...
	'CameraUpVector',[0 1 0], ...
	'CameraUpVectorMode','manual', ...
	'Color',[1 1 1], ...
	'ColorOrder',mat12, ...
	'Position',[13 399 252 103], ...
	'Tag','AxesZeroCurve', ...
	'XColor',[0 0 0], ...
	'XTickLabelMode','manual', ...
	'XTickMode','manual', ...
	'YColor',[0 0 0], ...
	'YTickLabelMode','manual', ...
	'YTickMode','manual', ...
	'ZColor',[0 0 0]);
h2 = text('Parent',h1, ...
	'ButtonDownFcn','ctlpanel SelectMoveResize', ...
	'Color',[0 0 0], ...
	'HandleVisibility','off', ...
	'HorizontalAlignment','center', ...
	'Interruptible','off', ...
	'Position',[0.49800796812749 -0.07843137254901977 9.160254037844386], ...
	'Tag','Axes1Text4', ...
	'VerticalAlignment','cap');
set(get(h2,'Parent'),'XLabel',h2);
h2 = text('Parent',h1, ...
	'ButtonDownFcn','ctlpanel SelectMoveResize', ...
	'Color',[0 0 0], ...
	'HandleVisibility','off', ...
	'HorizontalAlignment','center', ...
	'Interruptible','off', ...
	'Position',[-0.02788844621513944 0.4901960784313726 9.160254037844386], ...
	'Rotation',90, ...
	'Tag','Axes1Text3', ...
	'VerticalAlignment','baseline');
set(get(h2,'Parent'),'YLabel',h2);
h2 = text('Parent',h1, ...
	'ButtonDownFcn','ctlpanel SelectMoveResize', ...
	'Color',[0 0 0], ...
	'HandleVisibility','off', ...
	'HorizontalAlignment','right', ...
	'Interruptible','off', ...
	'Position',[-0.05179282868525896 2.872549019607843 9.160254037844386], ...
	'Tag','Axes1Text2', ...
	'Visible','off');
set(get(h2,'Parent'),'ZLabel',h2);
h2 = text('Parent',h1, ...
	'ButtonDownFcn','ctlpanel SelectMoveResize', ...
	'Color',[0 0 0], ...
	'HandleVisibility','off', ...
	'HorizontalAlignment','center', ...
	'Interruptible','off', ...
	'Position',[0.49800796812749 1.068627450980392 9.160254037844386], ...
	'Tag','Axes1Text1', ...
	'VerticalAlignment','bottom');
set(get(h2,'Parent'),'Title',h2);
h1 = uicontrol('Parent',h0, ...
	'Units','points', ...
	'BackgroundColor',get(0, 'DefaultFigureColor'), ...
	'FontWeight','bold', ...
	'HorizontalAlignment','left', ...
	'ListboxTop',0, ...
	'Position',[9.75 377.25 116.25 12], ...
	'String','Theoretical Spot Curve', ...
	'Style','text', ...
	'Tag','StaticText1');
h1 = uicontrol('Parent',h0, ...
	'Units','points', ...
     'Callback',...
     strcat(['global GBONDSPECFLAG; if (GBONDSPECFLAG == 1), '...
          'bdtmainaction loadzerocurve; end']), ...
	'ListboxTop',0, ...
	'Position',[204 348.75 79.5 17.25], ...
	'String','From File', ...
	'Tag','Pushbutton1');
h1 = uicontrol('Parent',h0, ...
	'Units','points', ...
     'Callback',...
     strcat(['global GBONDSPECFLAG; if (GBONDSPECFLAG == 1), '...
          'bdtmainaction speczerocrv; end']), ...
	'ListboxTop',0, ...
	'Position',[204 327 79.5 17.25], ...
	'String','Specify/Edit', ...
	'Tag','Pushbutton1');
if nargout > 0, fig = h0; end

% adjust the positions of the uicontrols
bdtmainaction('adjustres')
