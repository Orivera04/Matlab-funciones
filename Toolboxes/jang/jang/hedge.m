function hedge(action);

% HEDGE	Demonstrate effects of linguistic hedges on fuzzy sets

%	possible actions:
%	  'start'
%	  'revert'
%	  'erasemode'
%	  'hedge'
%	  'mf'

if nargin<1,
	action='start';
end;

if strcmp(action,'start'),
	FigTitle = 'Linguistic Hedges';

	FigH = findobj(0, 'Name', FigTitle);
	if isempty(FigH)
		FigH = figure( ...
		'unit', 'normal', ...
		'Name', FigTitle, ...
		'NumberTitle','off', ...
		'BackingStore','off', ...
		'position', [0.2 0.2 0.5 0.5]);
	else
		clf;
	end

	%====================================
	% The axes for display
	disp_area = 0.87;
	disp_spacing = 0.05;
	w = 1- 2*disp_spacing;
	h = disp_area - 2*disp_spacing;
	x = disp_spacing;
	y = 1 - disp_area + disp_spacing;
	axes( ...
		'Units','normalized', ...
		'Position',[x y w h], ...
		'Visible','off', ...
		'DrawMode','fast');
	%====================================
	% The CONSOLE frame for GUI
	gui_area = 1 - disp_area;
	spacing = 0.01;
	x = spacing;
	y = spacing;
	w = 1 - 2*spacing;
	h = gui_area - 2*spacing;
	h=uicontrol( ...
		'Style','frame', ...
		'Units','normalized', ...
		'Position',[x y w h], ...
		'BackgroundColor',[0.5 0.5 0.5]);
	%====================================
	% The CLOSE button
	h = 1 - disp_area - 4*spacing; 
	w = h;
	x = 2*spacing;
	y = 2*spacing;
	closeH = uicontrol( ...
		'Style','pushbutton', ...
		'Units','normalized', ...
		'Position',[x y w h], ...
		'String', 'Close', ...
		'Callback', 'close(gcf)');
	%====================================

	x = 0:0.1:10;
	y = tri_mf(x, [3 5 9]);
	lineH = plot(x, y);
	set(lineH, 'userdata', [x; y]); % original MF
	set(lineH, 'color', 'c');
	axis([min(x), max(x), 0, 1.2]);

	%====================================
	% the following two should be the same as those in anim0.m
%	disp_area = 0.8;
%	spacing = 0.01;
	console_h = 1 - disp_area - 2*spacing;
	%====================================
	% The CLEAR button
	close_h = console_h - 2*spacing; 
	close_w = close_h;
	close_x = 1-2*spacing-close_w;
	close_y = 2*spacing;
	position = [close_x close_y close_w close_h];

	label='Clear';
	callback= ['set(gcf, ''color'', get(gcf, ''color''));'];
	clearH=uicontrol( ...
		'Style','pushbutton', ...
		'Units','normalized', ...
		'Position',position, ...
		'String',label, ...
		'Callback',callback);
	%====================================
	% The HEDGE text area
	hedge_h = (console_h - 2*spacing)/2;
	hedge_w = 2.9*close_h;
	hedge_x = 4*spacing + close_w;
	hedge_y = 2*spacing + hedge_h;
	string = 'Linguistic Hedges';
	uicontrol( ...
		'Style','text', ...
		'string', string, ...
		'backgroundcolor', [0.5 0.5 0.5], ...
		'foregroundcolor', 'white', ...
		'Unit','norm', ...
		'Pos',[hedge_x hedge_y hedge_w hedge_h]);
	% The HEDGE button
	hedge_y = 2*spacing;
	string = ['Not A|Very A|More or less A|Contrast Intensifer|Contrast Diminisher'];
	hedgeH = uicontrol( ...
		'Style','popupmenu', ...
		'Unit','norm', ...
		'callback','hedge(''hedge'');', ...
		'backgroundcolor', [1 1 1], ...
		'string', string, ...
		'Pos',[hedge_x hedge_y hedge_w hedge_h]);
	%====================================
	% The mode text area
	mode_h = (console_h - 2*spacing)/2;
	mode_w = 2*close_h;
	mode_x = 6*spacing + close_w + hedge_w;
	mode_y = 2*spacing + mode_h;
	string = 'Erase Mode';
	uicontrol( ...
		'Style','text', ...
		'string', string, ...
		'backgroundcolor', [0.5 0.5 0.5], ...
		'foregroundcolor', 'white', ...
		'Unit','norm', ...
		'Pos',[mode_x mode_y mode_w mode_h]);
	% The display MODE button
	mode_y = 2*spacing;
	string = ['Normal|Background|XOR|None'];
	modeH = uicontrol( ...
		'Style','popupmenu', ...
		'Unit','norm', ...
		'value', 1, ...
		'callback', 'hedge(''erasemode'')', ...
		'backgroundcolor', [1 1 1], ...
		'string', string, ...
		'Pos',[mode_x mode_y mode_w mode_h]);
	%====================================
	% The MF text area
	mf_h = (console_h - 2*spacing)/2;
	mf_w = 2.9*close_h;
	mf_x = 8*spacing + close_w + hedge_w + mode_w;
	mf_y = 2*spacing + mode_h;
	string = 'Revert to Initial MF';
	uicontrol( ...
		'Style','text', ...
		'string', string, ...
		'backgroundcolor', [0.5 0.5 0.5], ...
		'foregroundcolor', 'white', ...
		'Unit','norm', ...
		'Pos',[mf_x mf_y mf_w mf_h]);
	% The MF button
	mf_y = 2*spacing;
	string = ['Triangle|Trapzoid|Gaussian|Sigmoid|Generalized Bell'];
	mfH = uicontrol( ...
		'Style','popupmenu', ...
		'Unit','norm', ...
		'value', 1, ...
		'callback', 'hedge(''mf'')', ...
		'backgroundcolor', [1 1 1], ...
		'string', string, ...
		'Pos',[mf_x mf_y mf_w mf_h]);
	%====================================
	set(gca, 'userdata', [lineH modeH hedgeH mfH])
	%====================================
elseif strcmp(action,'revert'),
	tmp = get(gca, 'userdata');
	lineH = tmp(1);
	set(lineH, 'color', 'y');
	orig_mf = get(lineH, 'userdata');
	set(lineH, 'ydata', orig_mf(2,:));
	set(lineH, 'color', 'c');
elseif strcmp(action,'erasemode'),
	tmp = get(gca, 'userdata');
	lineH = tmp(1);
	modeH = tmp(2);
	mode = get(modeH, 'value');
	if mode == 1, % Normal
		set(lineH, 'erasemode', 'normal');
	elseif mode == 2, % Background
		set(lineH, 'erasemode', 'background');
	elseif mode == 3, % XOR 
		set(lineH, 'erasemode', 'xor');
	elseif mode == 4, % None 
		set(lineH, 'erasemode', 'none');
	else
		error('Unknown display option!');
	end
elseif strcmp(action,'hedge'),
	tmp = get(gca, 'userdata');
	lineH = tmp(1);
	modeH = tmp(2);
	hedgeH = tmp(3);
	set(lineH, 'color', 'y');
	mf = get(lineH, 'ydata');
	mode = get(hedgeH, 'value');
	if mode == 1, % Not
		new_mf = 1 - mf;
		set(lineH, 'ydata', new_mf, 'color', 'c');
	elseif mode == 2, % Very
		new_mf = mf.^2;
		set(lineH, 'ydata', new_mf, 'color', 'c');
	elseif mode == 3, % More or less
		new_mf = mf.^0.5;
		set(lineH, 'ydata', new_mf, 'color', 'c');
	elseif mode == 4, % Contrast Intensifier 
		index1 = find(mf < 0.5);
		index2 = find(mf >= 0.5);
		new_mf = zeros(size(mf));
		new_mf(index1) = 2*mf(index1).^2;
		new_mf(index2) = 1-2*(1-mf(index2)).^2;
		set(lineH, 'ydata', new_mf, 'color', 'c');
	elseif mode == 5, % Contrast Diminisher 
		index1 = find(mf < 0.5);
		index2 = find(mf >= 0.5);
		new_mf = zeros(size(mf));
		new_mf(index1) = (mf(index1)/2).^0.5;
		new_mf(index2) = 1 - ((1-mf(index2))/2).^0.5;
		set(lineH, 'ydata', new_mf, 'color', 'c');
	end
elseif strcmp(action,'mf'),
	tmp = get(gca, 'userdata');
	lineH = tmp(1);
	modeH = tmp(2);
	hedgeH = tmp(3);
	mfH = tmp(4);
	set(lineH, 'color', 'y');
	which_mf = get(mfH, 'value');
	orig_mf = get(lineH, 'userdata');
	x = orig_mf(1,:);
	if which_mf == 1, % Triangle
		new_mf = tri_mf(x, [3 5 9]);
		set(lineH, 'ydata', new_mf, 'color', 'c');
		set(lineH, 'userdata', [x; new_mf]);
	elseif which_mf == 2, % Trapezoid
		new_mf = trap_mf(x, [2 4 7 8]);
		set(lineH, 'ydata', new_mf, 'color', 'c');
		set(lineH, 'userdata', [x; new_mf]);
	elseif which_mf == 3, % Gaussian 
		new_mf = gauss_mf(x, [5 2]);
		set(lineH, 'ydata', new_mf, 'color', 'c');
		set(lineH, 'userdata', [x; new_mf]);
	elseif which_mf == 4, % Sigmoid 
		new_mf = sig_mf(x, [2 5]);
		set(lineH, 'ydata', new_mf, 'color', 'c');
		set(lineH, 'userdata', [x; new_mf]);
	elseif which_mf == 5, % Generalized bell
		new_mf = gbell_mf(x, [3 4 5]);
		set(lineH, 'ydata', new_mf, 'color', 'c');
		set(lineH, 'userdata', [x; new_mf]);
	end
end

