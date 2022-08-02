function pw(fn)
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Decription: Creates a visual interface to fully or selectively play a portion of a wave file.
%             
%             This script will load a wave  file (mono or stereo)
%             and creates a figure with a plotting of the wave data. 
%             If the wave file has more than one channel then separate 
%             figures for each channel will be created. Each figure is      
%             created with additional toolbar buttons for playing the wave
%             data 'fully' or a 'selected region' in the respective channel.
%             
%             In addition it shows how to create toolbar buttons.
%
%
% Usage: 1. Type "pw" on the command line with no argument, or
%           Type pw('wavefile.wav') with wave filename as an argument
%           -  After loading a wave file a figure will be created with 
%              a plot of the wave file (for each channel).
%        2. To play the whole wave just click ">>" on the toolbar of the figure
%        3. To play a selected region just click "|>>|" on the toolbar
%           after selecting a region to play
%
%           - To select a region, do the following 
%                  First make sure the +/- zoom buttons are off (not depressed) on the toolbar]
%
%              (i)  left click   : to define the starting of the selection
%                                        (shown as solid  vertical red line)
%              (ii) right click  : to define the end of the selection region
%                                        (shown as dotted vertical red line)
%
% Author: Laine Berhane Kahsay
%         March 2005, Uni-Ulm
%
% To get this help: > help pw
%

% check number of arguments
if nargin < 1
    % prompt a dialog to load a wave file
    [filename, pathname] = uigetfile('*.wav','select a wave file to load');
    % check file is selected
    if pathname == 0
        disp('ERROR! No file selected!');
        help pw;
        return;
    end    
    wavefile = [pathname filename] ;
else
    % check if file exist
    if ~exist( fn, 'file')
        disp('ERROR! File not found...');
        help pw;
        return;
    end; 
    wavefile = which(fn);
end;

% reading a wave file :- type 'doc wavread' for more
%   help [x, fs, bps] = wavread( wavefile );
%        x - wave data
%       fs - sampling rate
%      bps - bits per sample not used
%     note - amplitude values are scaled down to [-1,+1] when read
%            automatically
[x, fs, bps] = wavread( wavefile );

% check if wavefile has stereo recording
nchannels = size(x, 2);
if nchannels > 1
    disp (['Stereo wavefile loaded (' num2str(nchannels) ' Ch) : ' wavefile ]);    
end

% number of samples
ns = length(x(:,1));

% save roots ShowHiddenHandles status
RootSHH = get(0, 'ShowHiddenHandles');
%
% create a figure for all the channels
for i=1:nchannels 
    
    load('icons.mat');
    fig=figure;
    % make all figure visible
    h.fig = fig;
    % set figure properties
    set(fig, 'WindowButtonDownFcn', 'mouseclickext( guidata(gcbo) )', ...
             'KeyPressFcn', 'return', ...
             'UserData', [0 0], ...
             'NumberTitle', 'off', ...
             'Name', ['Plot for Channel-' num2str(i) ' : ' wavefile ]);

    % get handle of toolbar
    set(0, 'showhiddenhandles', 'on');
    ut = findobj(fig,'type','uitoolbar');
    set(0, 'showhiddenhandles', RootSHH);
    % modify toolbar
    uipushtool('cdata',Ico.PlayAll, 'parent', ut,'clickedcallback','playsoundext(guidata(gcbo), 1)', 'tooltipstring','play all'); 
    uipushtool('cdata',Ico.PlaySel, 'parent', ut,'clickedcallback','playsoundext(guidata(gcbo), 2)', 'tooltipstring','play selection'); 
    
    % plot wave data
    % find absolute maximum :- used to define 'YLim'
    amax = max(abs(x(:,i)));
    
    % compute  time scale
    t = 1000*([1:ns]/fs);
    h.p2=plot(t, x(:,i), 'm');
    hold on;
    grid on;
    
    % initialize two (left and right) vertical lines for selective playing 
    h.v1 = plot(NaN, NaN, 'r');
    h.v2 = plot(NaN, NaN, 'r:');
    
    % some formating  for the plot
    set(h.p2, 'Color', 'b');
    title( ['loaded wave file: ' wavefile ' channel ' num2str(i)], 'Interpreter', 'none');
    ylabel('amp'); xlabel('Time (msecs)');
    axColor = [0.5 0.5 0.5];
    set(gca, 'Color', 'w', ...
             'Xlim', [ t(1) t(end)+10], 'Ylim', [-1.2*amax 1.2*amax], ..., 
             'XColor', axColor, 'YColor', axColor, ...
             'FontSize', 9);
    
    % save "wave data" in handle
    h.x = x(:,1);
    h.fs = fs;
    h.bps = bps;
    h.ns = ns;
    
    % save handle in figure
    guidata(fig, h);
    
end

