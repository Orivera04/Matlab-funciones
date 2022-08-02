function fig = chap6()
% This is the machine-generated representation of a Handle Graphics object
% and its children.  Note that handle values may change when these objects
% are re-created. This may cause problems with any callbacks written to
% depend on the value of the handle at the time the object was saved.
%
% To reopen this object, just type the name of the M-file at the MATLAB
% prompt. The M-file and its associated MAT-file must be on your path.

load chap6

h0 = figure('Units','points', ...
	'Color',[0.8 0.8 0.8], ...
	'Colormap',mat0, ...
	'PointerShapeCData',mat1, ...
	'Position',[115.5 57 549 457.5], ...
	'Tag','Fig1');
h1 = uicontrol('Parent',h0, ...
	'Units','points', ...
	'Callback','chap6_func', ...
	'ListboxTop',0, ...
	'Position',[419.25 99.75 45 15], ...
	'String','Simulate', ...
	'Tag','Pushbutton1');
h1 = uicontrol('Parent',h0, ...
	'Units','points', ...
	'BackgroundColor',[0.831372549019608 0.815686274509804 0.784313725490196], ...
	'ListboxTop',0, ...
	'Position',[349.5 159 45 15], ...
	'String','Alpha', ...
	'Style','text', ...
	'Tag','StaticText1');
h1 = uicontrol('Parent',h0, ...
	'Units','points', ...
	'BackgroundColor',[1 1 1], ...
	'ListboxTop',0, ...
	'Position',[421.5 159.75 45 15], ...
	'String','5', ...
	'Style','edit', ...
	'Tag','alpha');
h1 = uicontrol('Parent',h0, ...
	'Units','points', ...
	'BackgroundColor',[0.831372549019608 0.815686274509804 0.784313725490196], ...
	'ListboxTop',0, ...
	'Position',[337.5 123.75 78 32.25], ...
	'String','Power Control Error Standard Deviation', ...
	'Style','text', ...
	'Tag','StaticText1');
h1 = uicontrol('Parent',h0, ...
	'Units','points', ...
	'BackgroundColor',[1 1 1], ...
	'ListboxTop',0, ...
	'Position',[420.75 132 45 15], ...
	'String','1', ...
	'Style','edit', ...
	'Tag','std');
h1 = uicontrol('Parent',h0, ...
	'Units','points', ...
	'BackgroundColor',[0.831372549019608 0.815686274509804 0.784313725490196], ...
	'ListboxTop',0, ...
	'Position',[477.75 159 45 15], ...
	'String','%', ...
	'Style','text', ...
	'Tag','StaticText1');
h1 = uicontrol('Parent',h0, ...
	'Units','points', ...
	'BackgroundColor',[0.831372549019608 0.815686274509804 0.784313725490196], ...
	'ListboxTop',0, ...
	'Position',[479.25 133.5 45 12.75], ...
	'String','dB', ...
	'Style','text', ...
	'Tag','StaticText1');
h1 = uicontrol('Parent',h0, ...
	'Units','points', ...
	'BackgroundColor',[0.831372549019608 0.815686274509804 0.784313725490196], ...
	'FontSize',10, ...
	'ListboxTop',0, ...
	'Position',[55 421.5 415 15], ...
	'String','P6-17: Cell Capacity of CDMA System', ...
	'Style','text', ...
	'Tag','StaticText1');
h1 = uicontrol('Parent',h0, ...
	'Units','points', ...
	'BackgroundColor',[0.831372549019608 0.815686274509804 0.784313725490196], ...
	'HorizontalAlignment','left', ...
	'ListboxTop',0, ...
	'Position',[55 338 415 34.25], ...
	'String',mat2, ...
	'Style','text', ...
	'Tag','StaticText1');
h1 = uicontrol('Parent',h0, ...
	'Units','points', ...
	'BackgroundColor',[1 1 1], ...
	'ListboxTop',0, ...
	'Position',[421.5 187.5 45 15], ...
	'String','256', ...
	'Style','edit', ...
	'Tag','Gp');
h1 = uicontrol('Parent',h0, ...
	'Units','points', ...
	'BackgroundColor',[0.831372549019608 0.815686274509804 0.784313725490196], ...
	'ListboxTop',0, ...
	'Position',[348.75 182.25 57.75 24], ...
	'String','Processing Gain Gp', ...
	'Style','text', ...
	'Tag','StaticText1');
h1 = uicontrol('Parent',h0, ...
	'Units','points', ...
	'BackgroundColor',[0.831372549019608 0.815686274509804 0.784313725490196], ...
	'HorizontalAlignment','left', ...
	'ListboxTop',0, ...
	'Position',[55 378 415 35.25], ...
	'String',mat3, ...
	'Style','text', ...
	'Tag','StaticText1');
h1 = uicontrol('Parent',h0, ...
	'Units','points', ...
	'BackgroundColor',[0.831372549019608 0.815686274509804 0.784313725490196], ...
	'HorizontalAlignment','left', ...
	'ListboxTop',0, ...
	'Position',[55 307 415 25.25], ...
	'String',mat8, ...
	'Style','text', ...
	'Tag','StaticText1');
h1 = uicontrol('Parent',h0, ...
	'Units','points', ...
	'BackgroundColor',[0.831372549019608 0.815686274509804 0.784313725490196], ...
	'HorizontalAlignment','left', ...
	'ListboxTop',0, ...
	'Position',[55 283 415 25.25], ...
	'String',mat9, ...
	'Style','text', ...
	'Tag','StaticText1');
h1 = axes('Parent',h0, ...
	'CameraUpVector',[0 1 0], ...
	'CameraUpVectorMode','manual', ...
	'Color',[1 1 1], ...
	'ColorOrder',mat10, ...
	'Position',[0.1325136612021858 0.09180327868852459 0.4221311475409836 0.4475409836065574], ...
	'Tag','Axes1', ...
	'XColor',[0 0 0], ...
	'YColor',[0 0 0], ...
	'ZColor',[0 0 0]);
h2 = text('Parent',h1, ...
	'Color',[0 0 0], ...
	'HandleVisibility','off', ...
	'HorizontalAlignment','center', ...
	'Position',[0.4967532467532467 -0.08823529411764719 9.160254037844386], ...
	'Tag','Axes1Text4', ...
	'VerticalAlignment','cap');
set(get(h2,'Parent'),'XLabel',h2);
h2 = text('Parent',h1, ...
	'Color',[0 0 0], ...
	'HandleVisibility','off', ...
	'HorizontalAlignment','center', ...
	'Position',[-0.09415584415584419 0.4963235294117645 9.160254037844386], ...
	'Rotation',90, ...
	'Tag','Axes1Text3', ...
	'VerticalAlignment','baseline');
set(get(h2,'Parent'),'YLabel',h2);
h2 = text('Parent',h1, ...
	'Color',[0 0 0], ...
	'HandleVisibility','off', ...
	'HorizontalAlignment','right', ...
	'Position',[-0.3181818181818182 2.029411764705882 9.160254037844386], ...
	'Tag','Axes1Text2', ...
	'Visible','off');
set(get(h2,'Parent'),'ZLabel',h2);
h2 = text('Parent',h1, ...
	'Color',[0 0 0], ...
	'HandleVisibility','off', ...
	'HorizontalAlignment','center', ...
	'Position',[0.4967532467532467 1.025735294117647 9.160254037844386], ...
	'Tag','Axes1Text1', ...
	'VerticalAlignment','bottom');
set(get(h2,'Parent'),'Title',h2);
h1 = uicontrol('Parent',h0, ...
	'Units','points', ...
	'BackgroundColor',[1 1 1], ...
	'ListboxTop',0, ...
	'Position',[420 215.25 45 15], ...
	'String','200', ...
	'Style','edit', ...
	'Tag','N');
h1 = uicontrol('Parent',h0, ...
	'Units','points', ...
	'BackgroundColor',[0.831372549019608 0.815686274509804 0.784313725490196], ...
	'ListboxTop',0, ...
	'Position',[348 213 51 24], ...
	'String','Number of Samples', ...
	'Style','text', ...
	'Tag','StaticText1');
if nargout > 0, fig = h0; end