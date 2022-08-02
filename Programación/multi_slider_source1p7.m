function multi_slider_source1p7(varargin)
% MULTI_SLIDER_SOURCE  mutiple slider source block
%
%% ====  Based on  =============================================== %
%% function slideg(varargin)                                       %                        %
%% SLIDEG Slider Gain block helper function.                       %
%%   SLIDEG manages the dialog box for the Slider Gain block.      %
%%   All block and Handle Graphics callbacks are funneled through  %
%%   this SLIDEG.                                                  %
%%                                                                 %
%%   Copyright 1990-2004 The MathWorks, Inc.                       %
%%   $Revision: 1.45.4.3 $                                         %
%%                                                                 %
%% =============================================================== %
%
% MULTI_SLIDER_SOURCE  generate the manual slider source block.
%
%
%   Syntax:
%
%     multi_slider_source1p7(noSlider)
%     multi_slider_source1p7(low,high)
%     multi_slider_source1p7(low,high,gain)
%     multi_slider_source1p7(low,high,SliderLabel)
%     multi_slider_source1p7(low,high,gain,SliderLabel)
%
%
%   Description:
%
%     multi_slider_source1p7(noSlider)
%       requires only noSlider(number of the Sliders,scalar),
%       it generate a source block with outputs = noSlider.
%
%     multi_slider_source1p7(low,high)
%       requires low and high values in form of row vector,
%       it generate a source block with outputs = length(low), the size of low
%       and high should be the same, and high > low should be fulfilled.
%
%     multi_slider_source1p7(low,high,gain)
%       requires low, high and gain values in form of row vector, it generate
%       a source block with outputs = length(low), the size of low, high, and
%       gain should be the same, and high > gain > low should be fulfilled.
%
%     multi_slider_source1p7(low,high,SliderLabel)
%       requires low, high values in form of row vector and SliderLabel in form of
%       string cell array, the size of them should be the same, and high > low
%       should be fulfilled.
%
%     multi_slider_source1p7(low,high,gain,SliderLabel)
%       requires low, high, gain values in form of row vector and SliderLabel in
%       form of string cell array, the size of them should be the same, and
%       high > gain > low should be fulfilled.
%
%   Examples:
%
%        multi_slider_source1p7(3)
%
%     generate a multi slider source block with 3 sliders.
%
%
%        low  = zeros(1,5);
%        high = 10*ones(1,5);
%        multi_slider_source1p7(low,high);
%
%     generate a multi slider source block with 5 sliders, which lower and upper
%     limits are zeros(1,5) and 10*ones(1,5).
%
%        low = zeros(1,3);
%        high = 5*ones(1,3);
%        gain = 2.5*ones(1,3);
%        multi_slider_source1p7(low,high,gain)
%
%     generate a multi slider source block with 3 sliders, which lower and
%     upper limits are defined by low, high. The position of the slider buttons
%     will be at 2.5*ones(1,3);
%
%        low = zeros(1,2);
%        high = 10*ones(1,2);
%        SliderLabel = [{Speed} {Voltage}];
%        multi_slider_source1p7(low,high,SliderLabel)
%
%     generate a multi slider source block with 2 sliders, which lower and
%     upper limits are defined by low, high. The slider label will be shown in
%     the middel of each sliders.
%
%        low = zeros(1,4);
%        high = 10*ones(1,4);
%        gain = 5*ones(1,4);
%        SliderLabel = [{Speed1} {Speed2} {Voltage} {Time}];
%        multi_slider_source1p7(low,high,gain,SliderLabel)
%
%     generate a multi slider source block with 2 sliders, which lower and
%     upper limits are defined by low, high. The position of the slider buttons
%     determined by gain. The slider label will be shown in the middel of each
%     sliders.
%
%
%    New Features:
%
%             Default: when clicked, reset all the parameters with original
%                      values when you generate the Multi-Slider-Source block.
%
%     Save As Default: when clicked, save current min, max, Label, gain and
%                      positions of sliders as default values.
%
%                Sets: when clicked, prompt a dialog to load input sets.
%                      The sets can be column vector or matrix in the
%                      order of Sliders. When dimension excessed, it gives a
%                      warning massage and cut the vectors or matrix
%                      automatically to match the dimension of your Multi-
%                      Slider-Source block. When the dimension is less than
%                      number of silders, it will be applied from the first
%                      silder.
%
%             SetEdit: This edit box can only work when 'Sets:' button has
%                      been excuted. Give the number of column of the set you
%                      desired to use as input, if the number you entered is
%                      larger than the maximun column number of your Sets matrix,
%                      a warning massage will be given, and the maximun
%                      column number of your Sets matrix will be set inside
%                      the box.
%
%  version 1.5   Developed in MATLAB R14p1
%
%  The new version has make a modify in the GUI, add a scrollbar to solve
%  the limitation of numbers of sliders. Technically speaking, the program
%  can generate sliders as many as user requires. The floating buttons of
%  Default, Help and Close make user easly setting default, asking help, or
%  closing interface. But this can also be changed to be fixed when
%  uncomment lines 918-920, 1242-1244 and comment lines 928-930,
%  1252-1254.
%
%  The new version also add a function that to load data as inputs. Press
%  button 'Sets' to load data and give the number of set you want to used
%  in the edit field beside the button. The sequence of the data should as
%  same as the silder you defined.
%
%
%  version 1.6   Developed in MATLAB R14p1
%
%  The version 1.6 add a new button to save current values as default.
%
%  version 1.7   Developed in MATLAB R14p1
%
%  The version modify some bugs and add 2 new buttons to increase/decrease 
%  Loading sets 1 by 1.
%
%
%  LINCENCE:
%  The code is free and can be spread.
%  Please keep all the information of this help as complete as possible.
%
%  Po Hu
%  05.08.2005
%
global Sets

switch nargin

    case 0
        error('Not enough input arguments.')

    case 1
        if ischar(varargin{1})
            Action = varargin{1};
        else
            noSlider = varargin{1};
            low = [zeros(1,noSlider)];
            high = [2*ones(1,noSlider)];
            gain = [ones(1,noSlider)];
            SliderLabel = num2cell(1:noSlider);

            LocalMultiSliderGenerate(noSlider, low, high, gain, SliderLabel);
            Action = LocalMaskConfiguration(noSlider, low, high, gain, SliderLabel);
        end


    case 2
        % check if row vector
        for i = 1:2
            if size(varargin{i},1) ~= 1
                varargin{i} = varargin{i}';
            end
        end

        low  = varargin{1};
        high = varargin{2};
        % check size
        if length(high) ~= length(low)
            error(['Dimensions are not match.',sprintf('\n'),...
                'length(low) = ',num2str(length(low)),...
                ', length(high) = ',num2str(length(high))]);
        end
        % check if high > low
        if min(high > low) == 0
            error(['Values should be "high > low".'])
        end

        gain = (high+low)/2;
        noSlider = length(low);
        SliderLabel = num2cell(1:noSlider);

        LocalMultiSliderGenerate(noSlider, low, high, gain, SliderLabel);
        Action = LocalMaskConfiguration(noSlider, low, high, gain, SliderLabel);

    case 3
        % check if row vector
        for i = 1:3
            if size(varargin{i},1) ~= 1
                varargin{i} = varargin{i}';
            end
        end

        low  = varargin{1};
        high = varargin{2};
        noSlider = length(low);
        if iscell(varargin{3})
            SliderLabel = varargin{3};
            gain = (low+high)/2;
        else
            gain = varargin{3};
            SliderLabel = num2cell(1:noSlider);
        end


        % check size
        if length(varargin{1}) ~= length(varargin{2}) ||...
                length(varargin{1}) ~= length(varargin{3}) ||...
                length(varargin{2}) ~= length(varargin{3})
            error(['Dimensions are not match.',sprintf('\n'),...
                'length(low) = ',num2str(length(low)),...
                ', length(high) = ',num2str(length(high)),...
                ', length(gain||SliderLabel) = ', num2str(length(varargin{3}))]);

        end
        % check if high > low
        if min(high > low) == 0
            error(['Values should be "high > low".'])
        end

        LocalMultiSliderGenerate(noSlider, low, high, gain, SliderLabel);
        Action = LocalMaskConfiguration(noSlider, low, high, gain, SliderLabel);

    case 4
        % check if row vector
        for i = 1:4
            if size(varargin{i},1) ~= 1
                varargin{i} = varargin{i}';
            end
        end

        low    = varargin{1};
        high   = varargin{2};
        gain   = varargin{3};
        SliderLabel = varargin{4};

        noSlider = length(low);
        % check size
        if length(SliderLabel) ~= noSlider || length(high) ~= noSlider ||...
                length(gain) ~= noSlider || length(SliderLabel) ~= noSlider

            error(['Dimensions are not match.',sprintf('\n'),...
                'length(low) = ',num2str(length(low)),', length(gain) = ',...
                num2str(length(gain)),', length(high) = ',num2str(length(high)),...
                ', length(SliderLabel) = ',num2str(length(SliderLabel))]);
        end
        % check if high > gain > low
        if (min(high > low) && min(gain > low)) == 0
            error('Values should be "high > gain > low".')
        end

        LocalMultiSliderGenerate(noSlider, low, high, gain, SliderLabel);
        Action = LocalMaskConfiguration(noSlider, low, high, gain, SliderLabel);
    otherwise
        error('Too many input arguments.')
end


switch Action,
    %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Open - double click on the block %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %
    case 'Open',
        LocalOpenBlockFcn;

        %
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % Close - close_system call %
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %
    case 'Close',
        LocalCloseBlockFcn;

        %
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % DeleteBlock - block is being deleted %
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %
    case 'DeleteBlock',
        LocalDeleteBlockFcn;

        %
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % Copy - block is being copied %
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %
    case 'Copy',
        LocalCopyBlockFcn;

        %
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % Load - block is being loaded %
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %
    case 'Load',
        LocalLoadBlockFcn;

        %
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % NameChange - block name has been changed %
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %
    case 'NameChange',
        LocalNameChangeBlockFcn;

        %
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % ParentClose - block's parent has closed %
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %
    case 'ParentClose',
        LocalParentCloseBlockFcn

        %
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % DeleteFigure - figure is being deleted %
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %
    case 'DeleteFigure',
        LocalDeleteFigureFcn;

        %
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % CloseRequest - figure is being closed %
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %
    case 'CloseRequest',
        LocalCloseRequestFigureFcn;

        %
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % Help - help button has been pressed %
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %
    case 'Help',
        LocalHelpFcn;

        %
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % Default - Default button has been pressed %
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %
    case 'Default',
        LocalDefaultFcn;

        % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % Slider - slider is clicked on %
        % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %
    case 'Slider',
        LocalSliderFcn;

        %
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % LowEdit - low edit box edited %
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %
    case 'LowEdit',
        LocalLowEditFcn;

        %
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % GainEdit - gain edit box edited %
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %
    case 'GainEdit',
        LocalGainEditFcn;

        %
        % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % HighEdit - high edit box edited  %
        % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %
    case 'HighEdit',
        LocalHighEditFcn;

        %
        % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % LabelEdit - label edit box edited%
        % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %
    case 'LabelEdit'
        LocalLabelEditFcn;

        %
        % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % SetEdit - Set edit box edited%
        % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %
    case 'SetEdit'
        LocalSetEditFcn(Sets);

        %
        % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % RollPrevious - RollPrevious('<<') button pressed%
        % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %
    case 'RollPrevious'
        LocalRollPreviousFcn

        %
        % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % RollNext - RollNext('>>') button pressed%
        % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %
    case 'RollNext'
        LocalRollNextFcn
        %
        % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % LoadSets - Set is clicked%
        % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %
    case 'LoadSets'
        Sets = LocalLoadSetsFcn;
        %
        % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % Scrollbar - Scrollbar is drew    %
        % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %
    case 'Scrollbar'
        LocalScrollbarFcn
        %
        % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % SaveasDefault - Save Default button pushed %
        % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %
    case 'SaveasDefault'
        LocalSaveasDefaultFcn


    otherwise,
        error(['Unknown action ' Action]);

end % switch

%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% LocalMultiSliderBlockGenerate %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
function LocalMultiSliderGenerate(noSlider, low, high, gain, SliderLabel)

% Create and open a new system
sysName = get_param(new_system,'name');
open_system(sysName);

% Name of Muti-slider-gain block
msliderName = ['Muti(',num2str(noSlider),') - Slider - Source'];

% add subsystem
subsysName = [sysName '/Muti_Slider_Source'];
add_block('built-in/SubSystem',subsysName,...
    'Backgroundcolor','Yellow',...
    'position',[150,50,300,110+25*noSlider]);


% add constant input
constantName = ['Constant Input'];
constantNameL = [subsysName,'/',constantName];
add_block('built-in/Constant',constantNameL,...
    'value','1',...
    'position',[150, 30+25*noSlider,180,60+25*noSlider],...
    'maskdisplay','disp(''1'')',...
    'BackgroundColor','Orange')

for i = 1:noSlider

    %     add output ports
    outputName = ['output',num2str(i)];
    outputNameL = [subsysName,'/',outputName];
    add_block('built-in/Outport', outputNameL,...
        'portwidth','-1',...
        'sampletime','-1',...
        'position', [355,10+50*i,375,30+50*i],...
        'Orientation','right',...
        'BackgroundColor','Magenta')

    %     add gain blocks
    gainName = ['gain(',num2str(i),')'];
    gainNameL = [subsysName,'/',gainName];
    add_block('built-in/Gain',gainNameL,...
        'gain',gainName,...
        'position',[250 5+50*i 280 35+50*i],...
        'BackgroundColor','Lightblue');

    %     add lines
    add_line(subsysName,[constantName '/1'], [gainName '/1']);
    add_line(subsysName,[gainName '/1'], [outputName '/1']);

end

%
%%%%%%%%%%%%%%%%%%%%%%%%%%
% LocalMaskConfiguration %
%%%%%%%%%%%%%%%%%%%%%%%%%%
%
function Action = LocalMaskConfiguration(noSlider, low, high, gain, SliderLabel)

%
% Slider Label Strings
%
if ~ischar(SliderLabel{1})
    for i = 1:noSlider
        valueSliderLabel{i} = ['<<',num2str(SliderLabel{i}),'>>'];
        default_SliderLabel{i} = ['<<',num2str(SliderLabel{i}),'>>'];
    end
else
    valueSliderLabel = SliderLabel;
    default_SliderLabel = SliderLabel;
end

default_noSlider    = noSlider;
default_low         = low;
default_gain        = gain;
default_high        = high;

% Scrollbar Position
ScrollbarPos = 0;

% SetString in SetEditbox
SetString = 'Default';
%
% Mask Display String
%
valueDisplayString = ['disp(','''','Multi(',num2str(noSlider),') - Slider - Source','''',')'];

%
% Mask Prompt Strings and Mask Variables parameters
%
valueMPString = ['Low|Gain|High|SliderLabel|Default_Low|Default_Gain|Default_High|Default_SliderLabel|ScrollbarPos|SetString'];
valueMVariables = ['low=@1;gain=@2;high=@3;SliderLabel=&4;default_low=&5;default_gain=&6;default_high=&7;default_SliderLabel=&8;ScrollbarPos=&9;SetString=&10'];

%
% Mask Parameter Visibility Control
%

valueMaskVisibleString = [{'on'} {'on'} {'on'} {'off'} {'off'} {'off'} {'off'} {'off'} {'off'} {'off'}];
%
% Mask Description
%
valueMaskDescription = ['This block is a manual slider source. ',...
    'The sliders can be adjusted manually. ','The value of "low" ',...
    'and "high" give the lower and upper limits of the slider, ',...
    'the value in the middle editable box gives the actual value of slider. ',...
    'The strings in the color box, gives the Label of the slider.'];

%
% Mask Configuration
%
set_param(gcb,'MaskPromptString',[valueMPString],...
    'MaskValueString', LocalParamsToMaskEntries(valueSliderLabel, low, high, gain, default_SliderLabel, default_low, default_high, default_gain, ScrollbarPos, SetString),...
    'MaskDisplay',     valueDisplayString,...
    'MaskVisibilities',valueMaskVisibleString,...
    'MaskDescription', valueMaskDescription,...
    'MaskVariables',   [valueMVariables],...
    'MaskType',        'Multiple-Slider Source',...
    'OpenFcn',         'multi_slider_source1p7 Open',...         % for double click
    'DeleteFcn',       'multi_slider_source1p7 DeleteBlock',...  % for delete
    'CopyFcn',         'multi_slider_source1p7 Copy',...         % for copy (update copy's user data)
    'LoadFcn',         'multi_slider_source1p7 Load',...         % restore open state of dialog
    'NameChangeFcn',   'multi_slider_source1p7 NameChange',...   % for name changes
    'ParentCloseFcn',  'multi_slider_source1p7 ParentClose');    % for parental closure



Action = 'Open';


%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% LocalParamsToMaskEntries
% Pass in the low, gain, and high values for the slider source, and the
% appropriate MaskEntries string will be created from it.
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%

function MaskEntries=LocalParamsToMaskEntries(valueSliderLabel, low, high, gain, default_SliderLabel, default_low, default_high, default_gain, ScrollbarPos, SetString)

noSlider = length(low);
SliderEntries = valueSliderLabel{1};
SliderEntries_default = default_SliderLabel{1};
for i = 2:noSlider
    SliderEntries = [SliderEntries,' ',valueSliderLabel{i}];
    SliderEntries_default = [SliderEntries_default,' ',default_SliderLabel{i}];
end
MaskEntries = ['[',num2str(low),']|[',num2str(gain),']|[',num2str(high),']|[',SliderEntries,...
    ' ]|[',num2str(default_low),']|[',num2str(default_gain),']|[',num2str(default_high),']|[',SliderEntries_default,' ]|[',num2str(ScrollbarPos),']|[',SetString,']'];

%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% LocalMaskEntriesToParams
% Convert the MaskEntries parameter of the current block to a vector with the
% low, gain, and high limits for the slider source
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%

function [valueSliderLabel, low, high, gain, default_SliderLabel, default_low, default_high, default_gain, ScrollbarPos, SetString]=LocalMaskEntriesToParams(block)

parms = get_param(block,'MaskValues');
low   = str2num(parms{1});
gain  = str2num(parms{2});
high  = str2num(parms{3});
ScrollbarPos = str2num(parms{9});
Label = parms{4};
Label_default = parms{8};

blankpos = findstr(Label,' ');
blankpos_default = findstr(Label_default,' ');
len = length(blankpos);
initpos = 2;
initpos_default = 2;
for i = 1:len
    valueSliderLabel{i} = Label(initpos:blankpos(i)-1);
    default_SliderLabel{i} = Label_default(initpos_default:blankpos_default(i)-1);
    initpos = blankpos(i)+1;
    initpos_default = blankpos_default(i)+1;
end
default_low   = str2num(parms{5});
default_gain  = str2num(parms{6});
default_high  = str2num(parms{7});

bracket_l = findstr(parms{10},'[');
bracket_r = findstr(parms{10},']');
SetString = [parms{10}((bracket_l+1):bracket_r-1)];

%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% LocalOpenBlockFcn
% Called when the slider source is clicked on
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
function LocalOpenBlockFcn
global Sets

[valueSliderLabel, low, high, gain, default_SliderLabel, default_low, default_high, default_gain, ScrollbarPos, SetString]=LocalMaskEntriesToParams(gcb);
noSlider = length(low);
BlockHandle = get_param(gcb,'handle');


%
% The slider source dialog handle is stored in the block's user data
% If the figure is still valid and it's a slider source figure, then
% bring it forward.  Otherwise, the dialog needs to be recreated.
%

FigHandle = get_param(gcb,'UserData');

if ishandle(FigHandle),
    set(FigHandle,'Visible','on');
    figure(FigHandle);
else
    if strcmp(get_param(bdroot(gcb),'Lock'), 'on') || ...
            strcmp(get_param(gcb,'LinkStatus'),'implicit')
        errordlg(['The Slider Gain is in a locked system.  You must place it ' ...
            'in a model in order to operate.'],...
            'Error', 'modal')

    end

    ScreenUnit = get(0,'Units');
    set(0,'Units','pixels');
    ScreenSize = get(0,'ScreenSize');
    layout;
    ButtonWH = [mStdButtonWidth mStdButtonHeight];
    HS = 9;

    if noSlider < 10
        FigH = 3*mStdButtonHeight + 5*HS + mLineHeight + 102*(noSlider-1)+25;
        FigW = 3*mStdButtonWidth + 4*mFrameToText;
    else
        FigH = 3*mStdButtonHeight + 5*HS + mLineHeight + 102*(9-1)+25;
        FigW = 3*mStdButtonWidth + 4*mFrameToText+25;
    end
    FigurePos = [(ScreenSize(3)-FigW)/2 (ScreenSize(4)-FigH)/2 FigW FigH];


    bdPos  = get_param(get_param(gcb,'Parent'), 'Location');
    blkPos = get_param(gcb, 'Position');
    bdPos  = [bdPos(1:2)+blkPos(1:2) bdPos(1:2)+blkPos(1:2)+blkPos(3:4)];

    FigHandle=figure('Pos',FigurePos,...
        'Name',            get_param(gcb,'Name'), ...
        'Color',           get(0,'DefaultUIControlBackgroundColor'),...
        'Resize',          'off',...
        'NumberTitle',     'off',...
        'MenuBar',         'none',...
        'HandleVisibility','callback',...
        'doublebuffer',    'on',...
        'IntegerHandle',   'off',...
        'CloseRequestFcn', 'multi_slider_source1p7 CloseRequest',...
        'DeleteFcn',       'multi_slider_source1p7 DeleteFigure');

    for i = 1:noSlider

        % Create static Text
        ud.LowText(i)=uicontrol('Parent',FigHandle,...
            'Style','Text',...
            'String','Low',...
            'HorizontalAlignment','left',...
            'Position',[2*mFrameToText 2*mStdButtonHeight+3*HS+100*(noSlider-i) mStdButtonWidth mLineHeight]);

        ud.HighText(i)=uicontrol('Parent',FigHandle,...
            'Style','Text',...
            'String','High',...
            'HorizontalAlignment','right', ...
            'Position',[2*mFrameToText+2*mStdButtonWidth 2*mStdButtonHeight+3*HS+100*(noSlider-i) mStdButtonWidth mLineHeight]);

        % Create slider
        % Remark: possibly check for value between zero and one

        [valueSliderLabel,low, high, gain, default_SliderLabel, default_low, default_high, default_gain, ScrollbarPos, SetString] = LocalMaskEntriesToParams(gcb);
        value = (gain(i)-low(i))/(high(i)-low(i));
        position=[2*mFrameToText 2*mStdButtonHeight+mLineHeight+4*HS+100*(noSlider-i) ...
            3*mStdButtonWidth mStdButtonHeight];
        ud.Slider(i) = uicontrol('Parent',FigHandle,...
            'Style','slider',...
            'Value',value,...
            'SliderStep',[0.01 0.1],...
            'Position',position,...
            'Callback','multi_slider_source1p7 Slider');

        % Create editable controls
        Bup = 2*HS+mStdButtonHeight+100*(noSlider-i);

        ud.LowEdit(i)=uicontrol('Parent',FigHandle,...
            'Style','edit',...
            'BackgroundColor','white', ...
            'Position',[mFrameToText Bup ButtonWH], ...
            'String',num2str(low(i)),...
            'UserData',low(i), ...
            'Callback','multi_slider_source1p7 LowEdit');

        ud.GainEdit(i)=uicontrol('Parent',FigHandle,...
            'Style','edit',...
            'BackgroundColor','white', ...
            'Position',[2*mFrameToText+mStdButtonWidth Bup ButtonWH], ...
            'String',num2str(gain(i)),...
            'UserData',gain(i), ...
            'Callback','multi_slider_source1p7 GainEdit');

        ud.HighEdit(i)=uicontrol('Parent',FigHandle,...
            'Style','edit',...
            'BackgroundColor','white', ...
            'Position',[3*mFrameToText+2*mStdButtonWidth Bup ButtonWH], ...
            'String',num2str(high(i)),...
            'UserData',high(i), ...
            'Callback','multi_slider_source1p7 HighEdit');

        ud.LabelEdit(i)=uicontrol('Parent',FigHandle,...
            'Style','edit',...
            'BackgroundColor','Yellow', ...
            'Position',[2*mFrameToText+mStdButtonWidth-10 2*mStdButtonHeight+3*HS+100*(noSlider-i) mStdButtonWidth+20 mLineHeight+5], ...
            'String',valueSliderLabel{i},...
            'UserData',valueSliderLabel{i}, ...
            'Callback','multi_slider_source1p7 LabelEdit');
    end


    % Create Close pushbutton
    ud.Close=uicontrol('Parent',FigHandle,...
        'Style','push',...
        'String','Close', ...
        'Position',[2*mStdButtonWidth+3*mFrameToText HS ButtonWH], ...
        'Callback','multi_slider_source1p7 CloseRequest');

    % Set Edit
    ud.SetEdit=uicontrol('Parent',FigHandle,...
        'Style','edit',...
        'BackgroundColor',[1 0.9 0.9], ...
        'Position',[3*mFrameToText+2*mStdButtonWidth+10 2*mStdButtonHeight+mLineHeight+4*HS+100*noSlider-70 ButtonWH-[25,0]], ...
        'String',SetString,...
        'UserData',1, ...
        'Callback','multi_slider_source1p7 SetEdit');

    % Create RollPrevious pushbutton
    ud.RollPrevious=uicontrol('Parent',FigHandle,...
        'Style','push',...
        'String','<', ...
        'FontSize',10,...
        'Position',[3*mFrameToText+2*mStdButtonWidth-5 2*mStdButtonHeight+mLineHeight+4*HS+100*noSlider-70 ButtonWH-[75,0]], ...
        'Callback','multi_slider_source1p7 RollPrevious');

    % Create RollNext pushbutton
    ud.RollNext=uicontrol('Parent',FigHandle,...
        'Style','push',...
        'String','>', ...
        'FontSize',10,...
        'Position',[3*mFrameToText+2*mStdButtonWidth+75 2*mStdButtonHeight+mLineHeight+4*HS+100*noSlider-70 ButtonWH-[75,0]], ...
        'Callback','multi_slider_source1p7 RollNext');

    % Create LoadSets button for extra edit box
    ud.LoadSets=uicontrol('Parent',FigHandle,...
        'Style','push',...
        'String','Load Sets:', ...
        'Position',[2*mFrameToText+mStdButtonWidth+15 2*mStdButtonHeight+mLineHeight+4*HS+100*noSlider-70 ButtonWH-[25,0]], ...
        'Callback','multi_slider_source1p7 LoadSets');
    if ~isempty(Sets)
        % indicate that user has loaded sets.
        set(ud.LoadSets,'String',num2str(size(Sets,2)));
    end
    
    % Create Help pushbutton
    ud.Help=uicontrol('Parent',FigHandle,...
        'Style','push',...
        'String','Help', ...
        'Position',[mFrameToText 2*mStdButtonHeight+mLineHeight+4*HS+100*noSlider-70 ButtonWH], ...
        'Callback','multi_slider_source1p7 Help');

    % Create Default pushbutton
    ud.Default=uicontrol('Parent',FigHandle,...
        'Style','push',...
        'String','Default', ...
        'Position',[mFrameToText HS ButtonWH], ...
        'Callback','multi_slider_source1p7 Default');

    % Create SaveasDefault pushbutton
    ud.SaveasDefault=uicontrol('Parent',FigHandle,...
        'Style','push',...
        'String','Save As Default', ...
        'Position',[mStdButtonWidth+2*mFrameToText HS ButtonWH], ...
        'Callback','multi_slider_source1p7 SaveasDefault');

        
    % Create the Scrollbar
    if noSlider > 9
        % make sure "Min_Scrollbar < ScrollbarPos < Max_Scrollbar"
        if ScrollbarPos > 1.01-9/noSlider
            ScrollbarPos = 1.01-9/noSlider;
        end

        ud.Scrollbar = uicontrol('Parent',FigHandle,...
            'style','slider', ...
            'position',[FigW-20 HS HS+11 FigH-HS], ...
            'min',0,'max',(1.01-9/noSlider),...
            'value',ScrollbarPos,...
            'SliderStep',[9/noSlider, 18/noSlider],...
            'BackgroundColor',[.9 .9 .9],...
            'callback','multi_slider_source1p7 Scrollbar');
    end

    set(0,'Units',ScreenUnit);

    % Set the vitals in the figure's user data
    ud.Block=get_param(gcb,'Handle');
    set(FigHandle,'UserData',ud);


    % Save this figure's handle in the block's user data

    set_param(gcb,'UserData',FigHandle)

    if ScrollbarPos~=0 % save reaction time
        %
        % After Scroll:  'Open' action takes more than once
        %
        for i = 1:noSlider
            labelpos(i,:)=get(ud.LabelEdit(i),'Position');
            lowpos(i,:)=get(ud.LowEdit(i),'Position');
            gainpos(i,:)=get(ud.GainEdit(i),'Position');
            highpos(i,:)=get(ud.HighEdit(i),'Position');
            sliderpos(i,:)=get(ud.Slider(i),'Position');
            lowtextpos(i,:)=get(ud.LowText(i),'Position');
            hightextpos(i,:)=get(ud.HighText(i),'Position');
        end
        setpos=get(ud.SetEdit,'Position');
        loadsetspos=get(ud.LoadSets,'Position');
        closepos=get(ud.Close,'Position');
        SaveasDefaultpos=get(ud.SaveasDefault,'Position');
        defaultpos=get(ud.Default,'Position');
        helppos=get(ud.Help,'Position');
        rollpreviouspos=get(ud.RollPrevious,'Position');
        rollnextpos=get(ud.RollNext,'Position');

        H = (setpos(2)-hightextpos(noSlider,2));
        deltaH = [0 -H*ScrollbarPos 0 0];
        for i = 1:noSlider
            set(ud.LabelEdit(i),'Position',labelpos(i,:)+deltaH);
            set(ud.LowEdit(i),'Position',lowpos(i,:)+deltaH);
            set(ud.GainEdit(i),'Position',gainpos(i,:)+deltaH);
            set(ud.HighEdit(i),'Position',highpos(i,:)+deltaH);
            set(ud.Slider(i),'Position',sliderpos(i,:)+deltaH);
            set(ud.LowText(i),'Position',lowtextpos(i,:)+deltaH);
            set(ud.HighText(i),'Position',hightextpos(i,:)+deltaH);
        end
        set(ud.SetEdit,'Position',setpos+deltaH);
        set(ud.LoadSets,'Position',loadsetspos+deltaH);
        set(ud.Help,'Position',helppos+deltaH);
        set(ud.RollPrevious,'Position',rollpreviouspos+deltaH);
        set(ud.RollNext,'Position',rollnextpos+deltaH);

        %
        % Option Fix,
        % fix buttons, if want to fix the button, uncomment following 5
        % lines
        %

        % set(ud.Close,'Position',closepos+deltaH);
        % set(ud.SaveasDefault,'Position',SaveasDefaultpos+deltaH);
        % set(ud.Default,'Position',defaultpos+deltaH);


        %
        % Option Float,
        % Float buttons, if want to fix the button, comment following
        % 5 lines.

        set(ud.Close,'Position',closepos);
        set(ud.SaveasDefault,'Position',SaveasDefaultpos);
        set(ud.Default,'Position',defaultpos);
    end
end

%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% LocalDeleteBlockFcn
% Called when the slider source block is deleted
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
function LocalDeleteBlockFcn

FigHandle=get_param(gcb,'UserData');
if ishandle(FigHandle),
    delete(FigHandle);
end
%
%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% LocalCloseBlockFcn
% Called when the slider source block is closed via close_system
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
function LocalCloseBlockFcn

FigHandle=get_param(gcb,'UserData');
if ishandle(FigHandle),
    delete(FigHandle);
end


%
%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% LocalDeleteFigureFcn
% Called when the slider source figure is deleted
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
function LocalDeleteFigureFcn

FigHandle=get(0,'CallbackObject');
ud=get(FigHandle,'UserData');

set_param(ud.Block,'UserData',[]);
%
%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% LocalCloseRequestFigureFcn
% Called when the slider source figure is closed by various means.
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
function LocalCloseRequestFigureFcn

cbo=get(0,'CallbackObject');
switch get(cbo,'type')
    case 'uicontrol',
        FigHandle = get(cbo,'Parent');
    case 'figure'
        FigHandle = cbo;
    otherwise,
        error(['Unexpected object in ' mfilename]);
end

delete(FigHandle);

%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% LocalHelpFcn
% Called when the slider source Help button is pressed.
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
function LocalHelpFcn

ud = get(gcf,'userdata');
% slhelp(ud.Block);
help multi_slider_source1p7

%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% LocalDefaultFcn
% Called when the slider source Default button is pressed.
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
function LocalDefaultFcn

FigHandle=gcf;
ud=get(FigHandle,'UserData');
[valueSliderLabel, low, high, gain, default_SliderLabel, default_low, default_high, default_gain, ScrollbarPos, SetString]  = LocalMaskEntriesToParams(ud.Block);

default_noSlider = length(default_low);

for i = 1:default_noSlider
    value(i) = (default_gain(i)-default_low(i))/(default_high(i)-default_low(i));
    set(ud.Slider(i),'Value',value(i));
end
valueSliderLabel = default_SliderLabel;
low = default_low;
high = default_high;
gain = default_gain;
try
    set_param(ud.Block,'MaskValueString',LocalParamsToMaskEntries(valueSliderLabel,...
        low, high, gain, default_SliderLabel, default_low, default_high, default_gain, ScrollbarPos, SetString));
    noSlider = length(low);
    for i = 1:noSlider
        set(ud.LabelEdit(i),'string',default_SliderLabel{i})
        set(ud.LowEdit(i) ,'string',num2str(default_low(i)))
        set(ud.GainEdit(i),'string',num2str(default_gain(i)))
        set(ud.HighEdit(i),'string',num2str(default_high(i)))
    end
    set(ud.SetEdit,'string','Default');
catch
    LocalBeep
    errmsg = sprintf(['Error setting slider source value.  ' ...
        'MATLAB error message:\n ''%s'''], lasterr);
    errordlg(errmsg, gcb, 'modal');
end

%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% LocalDefaultFcn
% Called when the slider source Default button is pressed.
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
function LocalSaveasDefaultFcn

FigHandle=gcf;
ud=get(FigHandle,'UserData');

[valueSliderLabel, low, high, gain,...
    default_SliderLabel, default_low, default_high, default_gain, ScrollbarPos, SetString] = LocalMaskEntriesToParams(ud.Block);
noSlider = length(low);

default_noSlider    = noSlider;
default_low         = low;
default_gain        = gain;
default_high        = high;
default_SliderLabel = valueSliderLabel;

%
% Mask Display String
%
valueDisplayString = ['disp(','''','Multi(',num2str(noSlider),') - Slider - Source','''',')'];

%
% Mask Prompt Strings and Mask Variables parameters
%
valueMPString = ['Low|Gain|High|SliderLabel|Default_Low|Default_Gain|Default_High|Default_SliderLabel|ScrollbarPos|SetString'];
valueMVariables = ['low=@1;gain=@2;high=@3;SliderLabel=&4;default_low=&5;default_gain=&6;default_high=&7;default_SliderLabel=&8;ScrollbarPos=&9;SetString=&10'];

%
% Mask Parameter Visibility Control
%

valueMaskVisibleString = [{'on'} {'on'} {'on'} {'off'} {'off'} {'off'} {'off'} {'off'} {'off'} {'off'}];
%
% Mask Description
%
valueMaskDescription = ['This block is a manual slider source. ',...
    'The sliders can be adjusted manually. ','The value of "low" ',...
    'and "high" give the lower and upper limits of the slider, ',...
    'the value in the middle editable box gives the actual value of slider. ',...
    'The strings in the color box, gives the Label of the slider.'];

%
% Mask Configuration
%
set_param(ud.Block,'MaskPromptString',[valueMPString],...
    'MaskValueString', LocalParamsToMaskEntries(valueSliderLabel, low, high, gain, default_SliderLabel, default_low, default_high, default_gain, ScrollbarPos, SetString),...
    'MaskDisplay',     valueDisplayString,...
    'MaskVisibilities',valueMaskVisibleString,...
    'MaskDescription', valueMaskDescription,...
    'MaskVariables',   [valueMVariables],...
    'MaskType',        'Multiple-Slider Source',...
    'OpenFcn',         'multi_slider_source1p7 Open',...         % for double click
    'DeleteFcn',       'multi_slider_source1p7 DeleteBlock',...  % for delete
    'CopyFcn',         'multi_slider_source1p7 Copy',...         % for copy (update copy's user data)
    'LoadFcn',         'multi_slider_source1p7 Load',...         % restore open state of dialog
    'NameChangeFcn',   'multi_slider_source1p7 NameChange',...   % for name changes
    'ParentCloseFcn',  'multi_slider_source1p7 ParentClose');    % for parental closure


% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% LocalCopyBlockFcn
% Called when the slider source block is copied
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
function LocalCopyBlockFcn

% If the UserData is empty, the block might still be in a locked library,
% so don't bother trying to reset it unnecessarily.
if (~isempty(get_param(gcb,'UserData')))
    set_param(gcb,'UserData',[]);
end
%
%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% LocalLoadBlockFcn
% Called when the slider source block is loaded
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
function LocalLoadBlockFcn

if strcmp(get_param(bdroot,'BlockDiagramType'),'Model')
    set_param(gcb,'UserData',[]);
end
%
%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% LocalNameChangeBlockFcn
% Called when the slider source block name is changed
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
function LocalNameChangeBlockFcn

FigHandle=get_param(gcb,'UserData');
if ishandle(FigHandle),
    set(FigHandle,'Name',get_param(gcb,'Name'));
end
%
%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% LocalParentCloseBlockFcn
% Called when the slider source block's parent is closed
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
function LocalParentCloseBlockFcn

FigHandle=get_param(gcb,'UserData');
if ishandle(FigHandle),
    delete(FigHandle);
end
%
%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% LocalSliderFcn
% Called when the slider source block slider is clicked on
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
function LocalSliderFcn

FigHandle=gcf;
ud=get(FigHandle,'UserData');

[valueSliderLabel, low, high, gain, default_SliderLabel, default_low, default_high, default_gain, ScrollbarPos, SetString] = LocalMaskEntriesToParams(ud.Block);

noSlider = length(low);
for i = 1:noSlider
    gain(i)=low(i) + get(ud.Slider(i),'Value')*(high(i)-low(i));
end

LocalSetLabelLowGainHigh(ud, valueSliderLabel, low, high, gain, default_SliderLabel,  default_low, default_high, default_gain, ScrollbarPos, SetString);

for i = 1:noSlider
    set(ud.GainEdit(i),'String',num2str(gain(i)));
end


%
%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% LocalScrollbarFcn
% Called when the slider source block slider is clicked on
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
function LocalScrollbarFcn

FigHandle=gcf;
ud=get(FigHandle,'UserData');
barpos = get(ud.Scrollbar,'Value');
[valueSliderLabel, low, high, gain, default_SliderLabel, default_low, default_high, default_gain, ScrollbarPos, SetString] = LocalMaskEntriesToParams(ud.Block);

noSlider = length(low);
for i = 1:noSlider
    labelpos(i,:)=get(ud.LabelEdit(i),'Position');
    lowpos(i,:)=get(ud.LowEdit(i),'Position');
    gainpos(i,:)=get(ud.GainEdit(i),'Position');
    highpos(i,:)=get(ud.HighEdit(i),'Position');
    sliderpos(i,:)=get(ud.Slider(i),'Position');
    lowtextpos(i,:)=get(ud.LowText(i),'Position');
    hightextpos(i,:)=get(ud.HighText(i),'Position');
end
setpos=get(ud.SetEdit,'Position');
loadsetspos=get(ud.LoadSets,'Position');
closepos=get(ud.Close,'Position');
SaveasDefaultpos=get(ud.SaveasDefault,'Position');
defaultpos=get(ud.Default,'Position');
helppos=get(ud.Help,'Position');
rollpreviouspos=get(ud.RollPrevious,'Position');
rollnextpos=get(ud.RollNext,'Position');

H = (setpos(2)-hightextpos(noSlider,2));
deltaH = [0 H*(ScrollbarPos-barpos) 0 0];
for i = 1:noSlider
    set(ud.LabelEdit(i),'Position',labelpos(i,:)+deltaH);
    set(ud.LowEdit(i),'Position',lowpos(i,:)+deltaH);
    set(ud.GainEdit(i),'Position',gainpos(i,:)+deltaH);
    set(ud.HighEdit(i),'Position',highpos(i,:)+deltaH);
    set(ud.Slider(i),'Position',sliderpos(i,:)+deltaH);
    set(ud.LowText(i),'Position',lowtextpos(i,:)+deltaH);
    set(ud.HighText(i),'Position',hightextpos(i,:)+deltaH);
end

set(ud.SetEdit,'Position',setpos+deltaH);
set(ud.LoadSets,'Position',loadsetspos+deltaH);
set(ud.Help,'Position',helppos+deltaH);
set(ud.RollPrevious,'Position',rollpreviouspos+deltaH);
set(ud.RollNext,'Position',rollnextpos+deltaH);
%
% Option Fix,
% fix buttons, if want to fix the button, uncomment following 3
% lines
%
% set(ud.Close,'Position',closepos+deltaH);
% set(ud.SaveasDefault,'Position',SaveasDefaultpos+deltaH);
% set(ud.Default,'Position',defaultpos+deltaH);


%
% Option Float,
% Float buttons, if want to fix the button, comment following
% 3 lines.
%
set(ud.Close,'Position',closepos);
set(ud.SaveasDefault,'Position',SaveasDefaultpos);
set(ud.Default,'Position',defaultpos);

ScrollbarPos = barpos;
set_param(ud.Block,'MaskValueString',LocalParamsToMaskEntries(valueSliderLabel,...
    low, high, gain, default_SliderLabel, default_low, default_high, default_gain, ScrollbarPos, SetString));



%
%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% LocalLowEditFcn
% Called when the slider source block low edit field is edited
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
function LocalLowEditFcn

FigHandle=gcf;
ud=get(FigHandle,'UserData');

[valueSliderLabel, low, high, gain,...
    default_SliderLabel, default_low, default_high, default_gain, ScrollbarPos, SetString] = LocalMaskEntriesToParams(ud.Block);
noSlider = length(low);
for i = 1:noSlider
    [lowMask{i}, count{i}, errstr{i}] = sscanf(get(ud.LowEdit(i),'String'),'%f');

    if ~isempty(lowMask{i})
        low(i) = lowMask{i};
    end

    if count{i}==0,
        if isempty(errstr{i}),
            errstr{i}='Invalid input string';
        end
    elseif low(i) > gain(i),
        errstr{i}='Low > Gain. Change the Gain first. Setting Low = Gain.';
        low(i) = gain(i);
    end

    if ~isempty(errstr{i}),
        LocalBeep;
        errordlg(errstr{i},'Error','modal');
    end

    value(i) = (gain(i)-low(i))/(high(i)-low(i));
    set(ud.Slider(i),'Value',value(i));
end

LocalSetLabelLowGainHigh(ud, valueSliderLabel, low, high, gain, default_SliderLabel, default_low, default_high, default_gain, ScrollbarPos, SetString)

%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% LocalGainEditFcn
% Called when the slider source block gain edit field is edited
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
function LocalGainEditFcn

FigHandle=gcf;
ud=get(FigHandle,'UserData');

[valueSliderLabel, low, high, gain,...
    default_SliderLabel, default_low, default_high, default_gain, ScrollbarPos, SetString] = LocalMaskEntriesToParams(ud.Block);
noSlider = length(low);
for i = 1:noSlider
    [gainMask{i},count{i},errstr{i}] =sscanf(get(ud.GainEdit(i),'String'),'%f');

    if ~isempty(gainMask{i})
        gain(i) = gainMask{i};
    end

    if count{i}==0,
        if isempty(errstr{i}),
            errstr{i}='Invalid input string';
        end
    elseif (low(i) > gain(i))
        low(i) = gain(i);
    elseif (gain(i) > high(i)),
        high(i) = gain(i);
    end

    value(i) = (gain(i)-low(i))/(high(i)-low(i));
    set(ud.Slider(i),'Value',value(i));
end
% 
LocalSetLabelLowGainHigh(ud, valueSliderLabel, low, high, gain, default_SliderLabel, default_low, default_high, default_gain, ScrollbarPos, SetString)

%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% LocalHighEditFcn
% Called when the slider source block gain edit field is edited
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
function LocalHighEditFcn

FigHandle=gcf;
ud=get(FigHandle,'UserData');

[valueSliderLabel, low, high, gain,...
    default_SliderLabel, default_low, default_high,  default_gain, ScrollbarPos, SetString]  = LocalMaskEntriesToParams(ud.Block);
noSlider = length(low);
for i = 1:noSlider
    [highMask{i},count{i},errstr{i}] = sscanf(get(ud.HighEdit(i),'String'),'%f');

    if ~isempty(highMask{i})
        high(i) = highMask{i};
    end

    if count{i}==0,
        if isempty(errstr{i}),
            errstr{i}='Invalid input string';
        end
    elseif (gain(i) > high(i)),
        errstr{i}='High < Gain. Change the Gain first. Setting High = Gain';
        high(i) = gain(i);
    end

    if ~isempty(errstr{i}),
        LocalBeep;
        errordlg(errstr{i},'Error','modal');
    end

    value(i) = (gain(i)-low(i))/(high(i)-low(i));
    set(ud.Slider(i),'Value',value(i));
end
% 
LocalSetLabelLowGainHigh(ud, valueSliderLabel, low, high, gain, default_SliderLabel, default_low, default_high, default_gain, ScrollbarPos, SetString)


%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% LocalLabelEditFcn
% Called when the slider source block Label edit field is edited
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
function LocalLabelEditFcn

FigHandle=gcf;
ud=get(FigHandle,'UserData');

[valueSliderLabel, low, high, gain,...
    default_SliderLabel, default_low, default_high,  default_gain, ScrollbarPos, SetString]  = LocalMaskEntriesToParams(ud.Block);
noSlider = length(low);
for i = 1:noSlider
    [LabelMask{i},count{i},errstr{i}] = sscanf(get(ud.LabelEdit(i),'String'),'%c');

    if ~isempty(LabelMask{i})
        valueSliderLabel{i} = LabelMask{i};
    end

    if count{i}==0,
        if isempty(errstr{i}),
            errstr{i}='Invalid input string';
        end
    end

    if ~isempty(errstr{i}),
        LocalBeep;
        errordlg(errstr{i},'Error','modal');
    end
end
% 
LocalSetLabelLowGainHigh(ud, valueSliderLabel, low, high, gain, default_SliderLabel, default_low, default_high, default_gain, ScrollbarPos, SetString)

%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% LocalSetEditFcn
% Called when the slider source block set edit field is edited
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
function Sets = LocalLoadSetsFcn
global Sets

[filename, pathname] = ...
    uigetfile({'*.mat','Data File(.mat)'},'Please select an Data file');
if isequal(filename,0)
    %     disp('User selected Cancel')  % user canceled
    Sets = Sets;
else
    SelectedFile = fullfile(pathname, filename); % 'SelectedFile' gives
    data = load(SelectedFile);
    Sets = eval(['data.', char(fieldnames(data))]);
end
FigHandle=gcf;
ud=get(FigHandle,'UserData');
% indicate that user has loaded sets.
set(ud.LoadSets,'String',num2str(size(Sets,2)));

%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% LocalRollPreviousFcn
% Called when the slider source block set edit field is edited
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
function LocalRollPreviousFcn(Sets)
global Sets

% Sets can not be empty
if isempty(Sets)
    errordlg('Please Load Data First.');
else
    FigHandle=gcf;
    ud=get(FigHandle,'UserData');
    [valueSliderLabel, low, high, gain,...
        default_SliderLabel, default_low, default_high,  default_gain, ScrollbarPos, SetString]  = LocalMaskEntriesToParams(ud.Block);

    [SetMask] = sscanf(get(ud.SetEdit,'String'),'%f');
    if ~isempty(SetMask)
        no = SetMask;
    elseif ~isempty(str2num(SetString))
        no = str2num(SetString);
    elseif isempty(str2num(SetString))
        no = size(Sets,2)+1;
    end
    if no > 1
        no = no - 1;
    else
        no = 1;
    end
    LocalSetEditFcn(Sets,no)
end

%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% LocalRollNextFcn
% Called when the slider source block set edit field is edited
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
function LocalRollNextFcn(Sets)
global Sets

% Sets can not be empty
if isempty(Sets)
    errordlg('Please Load Data First.');
else
    FigHandle=gcf;
    ud=get(FigHandle,'UserData');
    [valueSliderLabel, low, high, gain,...
        default_SliderLabel, default_low, default_high,  default_gain, ScrollbarPos, SetString]  = LocalMaskEntriesToParams(ud.Block);

    [SetMask] = sscanf(get(ud.SetEdit,'String'),'%f');
    if ~isempty(SetMask)
        no = SetMask;
    elseif ~isempty(str2num(SetString))
        no = str2num(SetString);
    elseif isempty(str2num(SetString))
        no = 0;
    end
    if no < size(Sets,2)
        no = no + 1;
    else
    no = size(Sets,2);
    end
    LocalSetEditFcn(Sets,no)
end
    %
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% LocalSetEditFcn
% Called when the slider source block set edit field is edited
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
function LocalSetEditFcn(varargin)
if nargin == 1
    Sets = varargin{1};
else
    Sets = varargin{1};
    no = varargin{2};
end
FigHandle=gcf;
ud=get(FigHandle,'UserData');
[valueSliderLabel, low, high, gain,...
    default_SliderLabel, default_low, default_high,  default_gain, ScrollbarPos, SetString]  = LocalMaskEntriesToParams(ud.Block);
noSlider = length(low);

if exist('no') == 0
    [SetMask,count,errstr] = sscanf(get(ud.SetEdit,'String'),'%f');

    if ~isempty(SetMask)
        no = SetMask;
    end

    if count==0,
        if isempty(errstr),
            errstr='Invalid input string';
        end
    elseif (no > size(Sets,2)),
        if isempty(Sets)
            errstr = 'Please Load Data First !';
            no = size(Sets,2);
        else
            errstr='Number of Sets excessed !';
            no = size(Sets,2);
        end
    end
else
    errstr = '';
end
if isempty(Sets)
    dataset = gain;
else
    if  size(Sets,1) > noSlider
        warndlg('Row of loaded data does not match the number of sliders!')
        gain(1:noSlider) = Sets(1:noSlider,no);
    elseif size(Sets,1) < noSlider
        warndlg('Row of loaded data does not match the number of sliders!')
        gain(1:size(Sets,1)) = Sets(1:size(Sets,1),no);
    else
        gain(1:size(Sets,1)) = Sets(1:size(Sets,1),no);
    end
    dataset = gain;
end

% check lower and upper limit
for i = 1:noSlider
    if dataset(i)<low(i)
        low(i) = dataset(i);
    end
    if dataset(i)>high(i)
        high(i) = dataset(i);
    end
end

SetString = num2str(no);
LocalSetLabelLowGainHigh(ud, valueSliderLabel, low, high, dataset, default_SliderLabel, default_low, default_high, default_gain, ScrollbarPos, SetString);

for i = 1:noSlider
    value(i) = (dataset(i)-low(i))/(high(i)-low(i));
    set(ud.Slider(i),'Value',value(i));
end

if ~isempty(errstr),
    LocalBeep;
    errordlg(errstr,'Error','modal');
    return
end


%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% LocalBeep
% Beeps
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
function LocalBeep

disp(char(7));
%
%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% LocalSetLabelLowGainHigh
% Beeps
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
function LocalSetLabelLowGainHigh(ud, valueSliderLabel, low, high, gain, default_SliderLabel, default_low, default_high, default_gain, ScrollbarPos, SetString)

try
    set_param(ud.Block,'MaskValueString',LocalParamsToMaskEntries(valueSliderLabel,...
        low, high, gain, default_SliderLabel, default_low, default_high, default_gain, ScrollbarPos, SetString));
    noSlider = length(low);
    for i = 1:noSlider
        set(ud.LabelEdit(i),'string',valueSliderLabel{i})
        set(ud.LowEdit(i) ,'string',num2str(low(i)))
        set(ud.GainEdit(i),'string',num2str(gain(i)))
        set(ud.HighEdit(i),'string',num2str(high(i)))
    end
    set(ud.SetEdit,'string',SetString);
catch
    LocalBeep
    errmsg = sprintf(['Error setting slider source value.  ' ...
        'MATLAB error message:\n ''%s'''], lasterr);
    errordlg(errmsg, gcb, 'modal');
end
