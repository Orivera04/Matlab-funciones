function fig = ltigui()
% This is the machine-generated representation of a Handle Graphics object
% and its children.  Note that handle values may change when these objects
% are re-created. This may cause problems with any callbacks written to
% depend on the value of the handle at the time the object was saved.
%
% To reopen this object, just type the name of the M-file at the MATLAB
% prompt. The M-file and its associated MAT-file must be on your path.

load gui

h0 = figure('Units','characters', ...
'Color',[0.8 0.8 0.8], ...
'Colormap',mat0, ...
'CloseRequestFcn','dltidemo CloseRequestFcn', ...
'CreateFcn','dltidemo SetFigureSize', ...
'DoubleBuffer','on', ...
'MenuBar','none', ...
'Name','Discrete LTI (Linear Time Invariant) System Demo', ...
'NumberTitle','off', ...
'PaperPosition',[18 180 575.9999999999999 431.9999999999999], ...
'PaperUnits','points', ...
'PointerShapeCData',mat1, ...
'Position',[27.2 11 150 37], ...
'ResizeFcn','dltidemo ResizeFcn', ...
'Tag','DLTIDEMO');
aL = axes('units','characters','color',[0.5 0.25 0.25],'xtick',[],'ytick',[], ...
          'Position',[4 1.461538461538462 40 13.07692307692308], ...
          'xticklabel','','yticklabel','','box','on','vis','on','tag','Frame1');
h1 = uimenu('Parent',h0, ...
'Callback','', ...
'Label','&Plot Options', ...
'Tag','PlotOptionsMenu');
h2 = uimenu('Parent',h1, ...
'Callback','dltidemo LineWidth', ...
'Label','&Set Line Width...', ...
'Tag','SetLineWidth1');
h1 = uimenu('Parent',h0, ...
'Callback','', ...
'Label','&Help', ...
'Tag','Help');
h2 = uimenu('Parent',h1, ...
'Callback','dltidemo Help', ...
'Label','&Contents...', ...
'Tag','Help');
% Frame (Right)
aR = axes('units','characters','color',[0.25 0.25 0.5],'xtick',[],'ytick',[], ...
          'Position',[99.8 1.461538461538462 46 13.07692307692308], ...
          'xticklabel','','yticklabel','','box','on','vis','on','tag','FilterFrame');
% Amplitude Text Label
aa = axes('units','characters','Position',mat3, ...
    'xticklabel','','yticklabel','','vis','off');
ta = text(0,0.4,'Amplitude = 1','color',[1 1 1],'VerticalAlig','bottom', ...
    'fontunits','norm','fontsize',0.6,'fontweight','bold','tag','TextAmplitude');

h1 = uicontrol('Parent',h0, ...
'Units','characters', ...
'BackgroundColor',[1 1 1], ...
'Callback','dltidemo ChangeAmpE', ...
'FontSize',4.2075, ...
'FontWeight','bold', ...
'ListboxTop',0, ...
'Position',[33.8 11.46153846153846 8 1.425], ...
'String','1', ...
'Style','edit', ...
'Tag','EdAmplitude');
h1 = uicontrol('Parent',h0, ...
'Units','characters', ...
'BackgroundColor',[0.752941176470588 0.752941176470588 0.752941176470588], ...
'Callback','dltidemo ChangeAmpS', ...
'ListboxTop',0, ...
'Max',4, ...
'Position',[5.800000000000001 11.46153846153846 27 1.307692307692308], ...
'SliderStep',[0.125 0.25], ...
'Style','slider', ...
'Tag','SAmplitude', ...
'Value',1);
% Frequency Text Label
af = axes('units','characters', ...
          'Position',[5.8 9.538461538461538 16 1.307692307692308], ...
          'xticklabel','','yticklabel','','vis','off');
tf = text(0,0.4,'Frequency = ','color',[1 1 1],'VerticalAlig','bottom', ...
    'fontunits','norm','fontsize',0.6,'fontweight','bold','tag','TextFreq');          

h1 = uicontrol('Parent',h0, ...
'Units','characters', ...
'BackgroundColor',[1 1 1], ...
'Callback','dltidemo ChangeFreqE', ...
'FontSize',4.207500000000001, ...
'FontWeight','bold', ...
'ListboxTop',0, ...
'Position',[33.8 8.384615384615385 8 1.425], ...
'String','0.1', ...
'Style','edit', ...
'Tag','EdFreq');

h1 = uicontrol('Parent',h0, ...
'Units','characters', ...
'BackgroundColor',[0.752941176470588 0.752941176470588 0.752941176470588], ...
'Callback','dltidemo ChangeFreqS', ...
'ListboxTop',0, ...
'Max',1.5, ...
'Position',[5.800000000000001 8.384615384615385 27 1.307692307692308], ...
'SliderStep',[0.06666666666666667 0.1333333333333333], ...
'Style','slider', ...
'Tag','SFreq', ...
'Value',0.1);
% Phase Text Label
ap = axes('units','characters', ...
          'Position',[5.8 6.461538461538462 9 1.307692307692308], ...
          'xticklabel','','yticklabel','','vis','off');
tp = text(0,0.4,'Phase = ','color',[1 1 1],'VerticalAlig','bottom', ...
    'fontunits','norm','fontsize',0.6,'fontweight','bold','Tag','TextPhase');

h1 = uicontrol('Parent',h0, ...
'Units','characters', ...
'BackgroundColor',[1 1 1], ...
'Callback','dltidemo ChangePhaseE', ...
'FontSize',4.455, ...
'FontWeight','bold', ...
'ListboxTop',0, ...
'Position',[33.8 5.307692307692308 8 1.425], ...
'String','0', ...
'Style','edit', ...
'Tag','EdPhase');
h1 = uicontrol('Parent',h0, ...
'Units','characters', ...
'BackgroundColor',[0.752941176470588 0.752941176470588 0.752941176470588], ...
'Callback','dltidemo ChangePhaseS', ...
'ListboxTop',0, ...
'Max',2, ...
'Min',-1, ...
'Position',[5.800000000000001 5.307692307692308 27 1.307692307692308], ...
'SliderStep',[0.03333333333333333 0.06666666666666667], ...
'Style','slider', ...
'Tag','SPhase');
% DC Text Label
adc = axes('units','characters', ...
          'Position',[5.8 3.384615384615385 30 1.307692307692308], ...
          'xticklabel','','yticklabel','','vis','off');
tdc = text(0,0.4,'DC Level = 0','color',[1 1 1],'VerticalAlig','bottom', ...
    'fontunits','norm','fontsize',0.6,'fontweight','bold','Tag','TextDC');

h1 = uicontrol('Parent',h0, ...
'Units','characters', ...
'BackgroundColor',[1 1 1], ...
'Callback','dltidemo ChangeDCE', ...
'FontSize',3.96, ...
'FontWeight','bold', ...
'ListboxTop',0, ...
'Position',[33.8 2.230769230769231 8 1.425], ...
'String','0', ...
'Style','edit', ...
'Tag','EdDC');
h1 = uicontrol('Parent',h0, ...
'Units','characters', ...
'BackgroundColor',[0.752941176470588 0.752941176470588 0.752941176470588], ...
'Callback','dltidemo ChangeDCS', ...
'ListboxTop',0, ...
'Max',2, ...
'Min',-2, ...
'Position',[5.800000000000001 2.230769230769231 27 1.307692307692308], ...
'SliderStep',[0.05 0.125], ...
'Style','slider', ...
'Tag','SDC');
h1 = uicontrol('Parent',h0, ...
   'Units','characters', ...
   'BackgroundColor',[1 1 1], ...
   'Callback','dltidemo FilterChoice', ...
'FontSize',5.7375, ...
'FontWeight','bold', ...
'ListboxTop',0, ...
'Position',[101.8 2.615384615384615 42 1.307692307692308], ...
'String',mat4, ...
'Style','popupmenu', ...
'Tag','FilterPopUp', ...
'UserData',mat5, ...
'Value',1);
% Filter Choice Text Label
afc = axes('units','characters', ...
          'Position',[101.8 3.923076923076923 16 1.307692307692308], ...
          'xticklabel','','yticklabel','','vis','off');
tfc = text(0,0.4,'Filter Choice:','color',[1 1 1],'VerticalAlig','bottom', ...
    'fontunits','norm','fontsize',0.6,'fontweight','bold','Tag','FTextChoice');

h1 = uicontrol('Parent',h0, ...
'Units','characters', ...
'Callback','dltidemo Answer', ...
'FontSize',5.7, ...
'FontWeight','bold', ...
'ListboxTop',0, ...
'Position',[61.6 0.692307692307692 26.8 1.70769230769231], ...
'String','Theoretical Answer', ...
'Tag','Pushbutton1');

% Center Freq Text Label
ac = axes('units','characters','Position',[101.8 10.30769230769231 33 1.307692307692308], ...
    'xticklabel','','yticklabel','','vis','off');
tc = text(0,0.4,'Length = ','color',[1 1 1],'VerticalAlig','bottom', ...
    'fontunits','norm','fontsize',0.6,'fontweight','bold','tag','FilterTextFreq1');

h1 = uicontrol('Parent',h0, ...
'Units','characters', ...
'BackgroundColor',[1 1 1], ...
'Callback','dltidemo AveragerLengthE', ...
'FontSize',4.207500000000001, ...
'FontWeight','bold', ...
'ListboxTop',0, ...
'Position',[135.8 9.153846153846155 8 1.425], ...
'String','3', ...
'Style','edit', ...
'Tag','FilterEdFreq1');
h1 = uicontrol('Parent',h0, ...
'Units','characters', ...
'BackgroundColor',[0.752941176470588 0.752941176470588 0.752941176470588], ...
'Callback','dltidemo FilterFreq1S', ...
'ListboxTop',0, ...
'Max',0.4, ...
'Min',0.01, ...
'Position',[101.8 9.153846153846155 33 1.307692307692308], ...
'SliderStep',[0.1282051282051282 0.2564102564102564], ...
'Style','slider', ...
'Tag','FilterSFreq1', ...
'Value',0.2);
h1 = uicontrol('Parent',h0, ...
'Units','characters', ...
'BackgroundColor',[1 1 1], ...
'Callback','dltidemo Userhn', ...
'FontSize',6.600000000000001, ...
'FontWeight','bold', ...
'ListboxTop',0, ...
'Position',[101.8 9.153846153846155 42 1.425], ...
'String','[1,1,1,1]/4', ...
'Style','edit', ...
'Tag','FilterEdUserhn', ...
'Visible','off');

% Center Freq Text Label
ac = axes('units','characters','Position',[101.8 7.230769230769231 33 1.307692307692308], ...
    'xticklabel','','yticklabel','','vis','off');
tc = text(0,0.4,'Phase Slope = ','color',[1 1 1],'VerticalAlig','bottom', ...
    'fontunits','norm','fontsize',0.6,'fontweight','bold','tag','FilterTextPhase','vis','off');

h1 = uicontrol('Parent',h0, ...
'Units','characters', ...
'BackgroundColor',[1 1 1], ...
'Callback','dltidemo FilterPhaseE', ...
'FontSize',4.207500000000001, ...
'FontWeight','bold', ...
'ListboxTop',0, ...
'Position',[135.8 6.076923076923078 8 1.425], ...
'String','0', ...
'Style','edit', ...
'Tag','FilterEdPhase', ...
'Visible','off');
h1 = uicontrol('Parent',h0, ...
'Units','characters', ...
'BackgroundColor',[0.752941176470588 0.752941176470588 0.752941176470588], ...
'Callback','dltidemo FilterPhaseS', ...
'FontSize',3.15, ...
'ListboxTop',0, ...
'Max',5, ...
'Min',-5, ...
'Position',[101.8 6.076923076923078 33 1.307692307692308], ...
'SliderStep',[0.1 0.2], ...
'Style','slider', ...
'Tag','FilterSPhase', ...
'Visible','off');
h1 = uicontrol('Parent',h0, ...
'Units','characters', ...
'BackgroundColor',[0.752941176470588 0.752941176470588 0.752941176470588], ...
'Callback','dltidemo AveragerLengthS', ...
'ListboxTop',0, ...
'Max',15, ...
'Min',1, ...
'Position',[101.8 9.153846153846155 33 1.307692307692308], ...
'SliderStep',[0.1 0.2], ...
'Style','slider', ...
'Tag','AveragerSLength', ...
'Value',3);
h1 = uicontrol('Parent',h0, ...
'Units','characters', ...
'BackgroundColor',[0.25 0.25 0.5], ...
'FontSize',5.764705882352942, ...
'FontWeight','bold', ...
'ForegroundColor',[1 1 1], ...
'ListboxTop',0, ...
'Position',[108.7 13 28.2 1.30769230769231], ...
'String','Filter Specifications:', ...
'Style','text', ...
'Tag','TextforFilter');
h1 = uicontrol('Parent',h0, ...
'Units','characters', ...
'BackgroundColor',[0.7 0.7 0.7], ...
'FontSize',6.375, ...
'FontWeight','bold', ...
'ListboxTop',0, ...
'Position',[9.800000000000001 34.76923076923077 34 1.307692307692308], ...
'String','INPUT SIGNAL', ...
'Style','text', ...
'Tag','InputTitle');
h1 = uicontrol('Parent',h0, ...
'Units','characters', ...
'BackgroundColor',[0.7 0.7 0.7], ...
'FontSize',6.375, ...
'FontWeight','bold', ...
'ListboxTop',0, ...
'Position',[105.8 34.76923076923077 34 1.307692307692308], ...
'String','OUTPUT SIGNAL', ...
'Style','text', ...
'Tag','OutputTitle');
h1 = axes('Parent',h0, ...
'Units','characters', ...
'Box','on', ...
'CameraUpVector',[0 1 0], ...
'CameraUpVectorMode','manual', ...
'Color',[1 1 1], ...
'ColorOrder',mat6, ...
'FontSize',12, ...
'FontWeight','bold', ...
'NextPlot','replacechildren', ...
'Position',[9.800000000000001 18.38461538461539 34 14.23076923076923], ...
'Tag','InputAxis', ...
'XColor',[0 0 0], ...
'XLim',[-5 30], ...
'XLimMode','manual', ...
'YColor',[0 0 0], ...
'YLim',[-5 5], ...
'YLimMode','manual', ...
'ZColor',[0 0 0]);
h2 = text('Parent',h1, ...
'Color',[0 0 0], ...
'FontWeight','bold', ...
'HandleVisibility','off', ...
'HorizontalAlignment','center', ...
'Position',[12.39644970414201 5.434782608695651 17.32050807568877], ...
'String',mat7, ...
'Tag','InputAxisTitle', ...
'VerticalAlignment','bottom');
set(get(h2,'Parent'),'Title',h2);
h2 = text('Parent',h1, ...
'Color',[0 0 0], ...
'FontWeight','bold', ...
'HandleVisibility','off', ...
'HorizontalAlignment','center', ...
'Position',[12.39644970414201 -6.413043478260869 17.32050807568877], ...
'String','n', ...
'Tag','InputAxisXLabel', ...
'VerticalAlignment','cap');
set(get(h2,'Parent'),'XLabel',h2);
h2 = text('Parent',h1, ...
'Color',[0 0 0], ...
'FontWeight','bold', ...
'HandleVisibility','off', ...
'HorizontalAlignment','center', ...
'Position',[-10.17751479289941 -0.05434782608695699 17.32050807568877], ...
'Rotation',90, ...
'String','Amplitude', ...
'Tag','InputAxisYLabel', ...
'VerticalAlignment','baseline');
set(get(h2,'Parent'),'YLabel',h2);
h2 = text('Parent',h1, ...
'Color',[0 0 0], ...
'HandleVisibility','off', ...
'HorizontalAlignment','right', ...
'Position',[-15.35502958579882 7.989130434782606 17.32050807568877], ...
'Tag','InputAxisZLabel', ...
'Visible','off');
set(get(h2,'Parent'),'ZLabel',h2);
h2 = line('Parent',h1, ...
'Color',[1 0 0], ...
'LineStyle','none', ...
'LineWidth',2, ...
'Marker','o', ...
'MarkerFaceColor',[0 0 1], ...
'Tag','Axes4Line3', ...
'XData',mat8, ...
'YData',mat9);
h2 = line('Parent',h1, ...
'Color',[1 0 0], ...
'LineWidth',2, ...
'MarkerFaceColor',[0 0 1], ...
'Tag','Axes4Line2', ...
'XData',mat10, ...
'YData',mat11);
h2 = line('Parent',h1, ...
'Color',[1 0 0], ...
'LineStyle',':', ...
'LineWidth',2, ...
'MarkerFaceColor',[0 0 1], ...
'Tag','Axes4Line1', ...
'XData',[0 0], ...
'YData',[-5 5]);
h1 = axes('Parent',h0, ...
'Units','characters', ...
'Box','on', ...
'CameraUpVector',[0 1 0], ...
'CameraUpVectorMode','manual', ...
'Color',[1 1 1], ...
'ColorOrder',mat12, ...
'FontSize',14, ...
'FontWeight','bold', ...
'LineWidth',1, ...
'NextPlot','replacechildren', ...
'Position',[55.8 23 38 11.53846153846154], ...
'Tag','MagAxis', ...
'XColor',[0 0 0], ...
'XGrid','on', ...
'XLim',[-0.5 0.5], ...
'XLimMode','manual', ...
'XTick',mat13, ...
'XTickLabel',mat14, ...
'XTickLabelMode','manual', ...
'XTickMode','manual', ...
'YColor',[0 0 0], ...
'YGrid','on', ...
'YLim',[0 1.1], ...
'YLimMode','manual', ...
'ZColor',[0 0 0], ...
'ZGrid','on');
h2 = text('Parent',h1, ...
'Color',[0 0 0], ...
'FontWeight','bold', ...
'HandleVisibility','off', ...
'HorizontalAlignment','center', ...
'Position',mat15, ...
'String','Magnitude of the Filter', ...
'Tag','MagAxisTitle', ...
'VerticalAlignment','bottom');
set(get(h2,'Parent'),'Title',h2);
h2 = text('Parent',h1, ...
'Color',[0 0 0], ...
'FontSize',8, ...
'FontWeight','bold', ...
'HandleVisibility','off', ...
'HorizontalAlignment','center', ...
'Position',[-0.002645502645502784 -0.2067114093959732 17.32050807568877], ...
'String','Frequency (\omega)', ...
'Tag','MagAxisXLabel', ...
'VerticalAlignment','cap');
set(get(h2,'Parent'),'XLabel',h2);
h2 = text('Parent',h1, ...
'Color',[0 0 0], ...
'FontSize',8, ...
'FontWeight','bold', ...
'HandleVisibility','off', ...
'HorizontalAlignment','center', ...
'Position',[-0.6904761904761905 0.5389261744966444 17.32050807568877], ...
'Rotation',90, ...
'String','Magnitude', ...
'Tag','MagAxisYLabel', ...
'VerticalAlignment','baseline');
set(get(h2,'Parent'),'YLabel',h2);
h2 = text('Parent',h1, ...
'Color',[0 0 0], ...
'HandleVisibility','off', ...
'HorizontalAlignment','right', ...
'Position',mat16, ...
'Tag','MagAxisZLabel', ...
'Visible','off');
set(get(h2,'Parent'),'ZLabel',h2);
h2 = line('Parent',h1, ...
'Color',[0 0 1], ...
'LineWidth',2, ...
'MarkerFaceColor',[0 0 1], ...
'Tag','Axes3Line4', ...
'XData',mat17, ...
'YData',mat18);
h2 = line('Parent',h1, ...
'Color',[1 0 0], ...
'Marker','o', ...
'MarkerFaceColor',[1 0 0], ...
'MarkerSize',9, ...
'Tag','Axes3Line3', ...
'Visible','off', ...
'XData',0, ...
'YData',1);
h2 = line('Parent',h1, ...
'Color',[1 0 0], ...
'Marker','o', ...
'MarkerFaceColor',[1 0 0], ...
'MarkerSize',9, ...
'Tag','Axes3Line2', ...
'XData',0.1, ...
'YData',0.8736381321683958);
h2 = line('Parent',h1, ...
'Color',[1 0 0], ...
'Marker','o', ...
'MarkerFaceColor',[1 0 0], ...
'MarkerSize',9, ...
'Tag','Axes3Line1', ...
'XData',-0.1, ...
'YData',0.8736381321683958);
h1 = axes('Parent',h0, ...
'Units','characters', ...
'Box','on', ...
'CameraUpVector',[0 1 0], ...
'CameraUpVectorMode','manual', ...
'Color',[1 1 1], ...
'ColorOrder',mat19, ...
'FontSize',14, ...
'FontWeight','bold', ...
'LineWidth',1, ...
'NextPlot','replacechildren', ...
'Position',[55.8 6.076923076923078 38 11.53846153846154], ...
'Tag','PhaseAxis', ...
'XColor',[0 0 0], ...
'XGrid','on', ...
'XLim',[-0.5 0.5], ...
'XLimMode','manual', ...
'XTick',mat20, ...
'XTickLabel',mat21, ...
'XTickLabelMode','manual', ...
'XTickMode','manual', ...
'YColor',[0 0 0], ...
'YGrid','on', ...
'YLim',[-3.5 3.5], ...
'YLimMode','manual', ...
'ZColor',[0 0 0], ...
'ZGrid','on');
h2 = text('Parent',h1, ...
'Color',[0 0 0], ...
'FontWeight','bold', ...
'HandleVisibility','off', ...
'HorizontalAlignment','center', ...
'Position',[-0.002645502645502784 3.920000000000002 17.32050807568877], ...
'String','Phase of the Filter', ...
'Tag','PhaseAxisTitle', ...
'VerticalAlignment','bottom');
set(get(h2,'Parent'),'Title',h2);
h2 = text('Parent',h1, ...
'Color',[0 0 0], ...
'FontSize',8, ...
'FontWeight','bold', ...
'HandleVisibility','off', ...
'HorizontalAlignment','center', ...
'Position',[-0.002645502645502784 -4.806666666666665 17.32050807568877], ...
'String','Frequency (\omega)', ...
'Tag','PhaseAxisXLabel', ...
'VerticalAlignment','cap');
set(get(h2,'Parent'),'XLabel',h2);
h2 = text('Parent',h1, ...
'Color',[0 0 0], ...
'FontSize',8, ...
'FontWeight','bold', ...
'HandleVisibility','off', ...
'HorizontalAlignment','center', ...
'Position',[-0.642857142857143 -0.04666666666666508 17.32050807568877], ...
'Rotation',90, ...
'String','Phase (radians)', ...
'Tag','PhaseAxisYLabel', ...
'VerticalAlignment','baseline');
set(get(h2,'Parent'),'YLabel',h2);
h2 = text('Parent',h1, ...
'Color',[0 0 0], ...
'HandleVisibility','off', ...
'HorizontalAlignment','right', ...
'Position',mat22, ...
'Tag','PhaseAxisZLabel', ...
'Visible','off');
set(get(h2,'Parent'),'ZLabel',h2);
h2 = line('Parent',h1, ...
'Color',[0 0 1], ...
'LineWidth',2, ...
'MarkerFaceColor',[0 0 1], ...
'Tag','Axes2Line3', ...
'XData',mat23, ...
'YData',mat24);
h2 = line('Parent',h1, ...
'Color',[1 0 0], ...
'Marker','o', ...
'MarkerFaceColor',[1 0 0], ...
'MarkerSize',9, ...
'Tag','Axes2Line2', ...
'Visible','off', ...
'XData',0, ...
'YData',0);
h2 = line('Parent',h1, ...
'Color',[1 0 0], ...
'Marker','o', ...
'MarkerFaceColor',[1 0 0], ...
'MarkerSize',9, ...
'Tag','Axes2Line1', ...
'XData',0.1, ...
'YData',-0.6258641614573418);
h1 = axes('Parent',h0, ...
'Units','characters', ...
'Box','on', ...
'CameraUpVector',[0 1 0], ...
'CameraUpVectorMode','manual', ...
'Color',[1 1 1], ...
'ColorOrder',mat25, ...
'FontSize',14, ...
'FontWeight','bold', ...
'NextPlot','replacechildren', ...
'Position',[105.8 18.38461538461539 34 14.23076923076923], ...
'Tag','OutputAxis', ...
'XColor',[0 0 0], ...
'XLim',[-5 30], ...
'XLimMode','manual', ...
'YColor',[0 0 0], ...
'YLim',[-5 5], ...
'YLimMode','manual', ...
'ZColor',[0 0 0]);
h2 = text('Parent',h1, ...
'Color',[0 0 0], ...
'FontWeight','bold', ...
'HandleVisibility','off', ...
'HorizontalAlignment','center', ...
'Position',[12.396449704142 5.489130434782606 17.32050807568877], ...
'Tag','OutputAxisTitle', ...
'VerticalAlignment','bottom');
set(get(h2,'Parent'),'Title',h2);
h2 = text('Parent',h1, ...
'Color',[0 0 0], ...
'FontSize',8, ...
'FontWeight','bold', ...
'HandleVisibility','off', ...
'HorizontalAlignment','center', ...
'Position',[12.396449704142 -6.521739130434783 17.32050807568877], ...
'String','n', ...
'Tag','OutputAxisXLabel', ...
'VerticalAlignment','cap');
set(get(h2,'Parent'),'XLabel',h2);
h2 = text('Parent',h1, ...
'Color',[0 0 0], ...
'FontSize',8, ...
'FontWeight','bold', ...
'HandleVisibility','off', ...
'HorizontalAlignment','center', ...
'Position',[-10.59171597633137 -0.05434782608695699 17.32050807568877], ...
'Rotation',90, ...
'String','Amplitude', ...
'Tag','OutputAxisYLabel', ...
'VerticalAlignment','baseline');
set(get(h2,'Parent'),'YLabel',h2);
h2 = text('Parent',h1, ...
'Color',[0 0 0], ...
'HandleVisibility','off', ...
'HorizontalAlignment','right', ...
'Position',mat26, ...
'Tag','OutputAxisZLabel', ...
'Visible','off');
set(get(h2,'Parent'),'ZLabel',h2);
h2 = line('Parent',h1, ...
'Color',[1 0 1], ...
'LineStyle','none', ...
'LineWidth',2, ...
'Marker','o', ...
'MarkerFaceColor',[0 0 1], ...
'Tag','Axes1Line3', ...
'XData',mat27, ...
'YData',mat28);
h2 = line('Parent',h1, ...
'Color',[1 0 1], ...
'LineWidth',2, ...
'MarkerFaceColor',[0 0 1], ...
'Tag','Axes1Line2', ...
'XData',mat29, ...
'YData',mat30);
h2 = line('Parent',h1, ...
'Color',[1 0 1], ...
'LineStyle',':', ...
'LineWidth',2, ...
'MarkerFaceColor',[0 0 1], ...
'Tag','Axes1Line1', ...
'XData',[0 0], ...
'YData',[-5 5]);
if nargout > 0, fig = h0; end
