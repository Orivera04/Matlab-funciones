function fig = getbondgui()
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%    This is private file of the BDT Demo and is not meant to be called
%    directly by the user.
%
%Author: C. Bassignani, 05-20-98 
%   Copyright 1995-2002 The MathWorks, Inc. 
%$Revision: 1.8 $   $Date: 0000/00/00 00:00:00

load getbondgui

h0 = figure('Color',[0.8 0.8 0.8], ...
	'Colormap',mat0, ...
	'Position',[590 450 310 250], ...
	'NumberTitle', 'off', ...
	'MenuBar', 'none', ...
	'Name', 'Get Bond From File', ...
	'Tag','Fig1', ...
	'UserData',mat1);
h1 = uicontrol('Parent',h0, ...
	'Units','points', ...
	'BackgroundColor',[0.752941176470588 0.752941176470588 0.752941176470588], ...
	'FontSize',10, ...
	'FontWeight','bold', ...
	'ForegroundColor',[0 0.501960784313725 1], ...
	'HorizontalAlignment','left', ...
	'ListboxTop',0, ...
	'Position',[4.5 160 220 20], ...
	'String','Load Bond', ...
	'Style','text', ...
	'Tag','StaticText1');
h1 = uicontrol('Parent',h0, ...
	'Units','points', ...
	'BackgroundColor',[1 1 1], ...
	'HorizontalAlignment','left', ...
	'ListboxTop',0, ...
	'Position',[120.75 70.5 102.75 19.5], ...
	'String','IBond', ...
	'Style','edit', ...
	'Tag','EditBondName');
h1 = uicontrol('Parent',h0, ...
	'Units','points', ...
	'BackgroundColor',[1 1 1], ...
	'HorizontalAlignment','left', ...
	'ListboxTop',0, ...
	'Position',[4.5 113.25 218.25 19.5], ...
        'String',[fullfile(matlabroot,'toolbox','finance','findemos') filesep], ...
	'Style','edit', ...
	'Tag','EditBondFileLocation');
h1 = uicontrol('Parent',h0, ...
	'Units','points', ...
	'BackgroundColor',[0.752941176470588 0.752941176470588 0.752941176470588], ...
	'HorizontalAlignment','left', ...
	'ListboxTop',0, ...
	'Position',[4.5 136.5 123.75 14.25], ...
	'String','File Location (Absolute)', ...
	'Style','text', ...
	'Tag','StaticText2');
h1 = uicontrol('Parent',h0, ...
	'Units','points', ...
	'Callback','getbondguicall', ...
	'FontSize',9, ...
	'FontWeight','bold', ...
	'ListboxTop',0, ...
	'Position',[94.5 6 58.5 27], ...
	'String','Get File', ...
	'Tag','GetFileButton');
h1 = uicontrol('Parent',h0, ...
	'Units','points', ...
	'FontSize',9, ...
	'ListboxTop',0, ...
	'Position',[168 6.75 58.5 27], ...
	'String','Help', ...
	'Tag','Pushbutton1');
h1 = uicontrol('Parent',h0, ...
	'Units','points', ...
	'BackgroundColor',[0.752941176470588 0.752941176470588 0.752941176470588], ...
	'HorizontalAlignment','left', ...
	'ListboxTop',0, ...
	'Position',[120.75 94.5 101.25 14.25], ...
	'String','Bond Name', ...
	'Style','text', ...
	'Tag','StaticText2');
h1 = uicontrol('Parent',h0, ...
	'Units','points', ...
	'BackgroundColor',[1 1 1], ...
	'HorizontalAlignment','left', ...
	'ListboxTop',0, ...
	'Position',[4.5 36 102.75 19.5], ...
	'Style','edit', ...
	'Tag','EditBondErrorMessage');
h1 = uicontrol('Parent',h0, ...
	'Units','points', ...
	'BackgroundColor',[0.752941176470588 0.752941176470588 0.752941176470588], ...
	'HorizontalAlignment','left', ...
	'ListboxTop',0, ...
	'Position',[5.25 56.25 101.25 14.25], ...
	'String','Status Message', ...
	'Style','text', ...
	'Tag','StaticText2');
h1 = uicontrol('Parent',h0, ...
	'Units','points', ...
	'BackgroundColor',[1 1 1], ...
	'HorizontalAlignment','left', ...
	'ListboxTop',0, ...
	'Position',[4.5 71.25 102.75 19.5], ...
	'String','sampleoptionbond', ...
	'Style','edit', ...
	'Tag','EditBondFileName');
h1 = uicontrol('Parent',h0, ...
	'Units','points', ...
	'BackgroundColor',[0.752941176470588 0.752941176470588 0.752941176470588], ...
	'HorizontalAlignment','left', ...
	'ListboxTop',0, ...
	'Position',[4.5 94.5 101.25 14.25], ...
	'String','File Name', ...
	'Style','text', ...
	'Tag','StaticText2');
if nargout > 0, fig = h0; end

% adjust the positions of the uicontrols
bdtmainaction('adjustres')