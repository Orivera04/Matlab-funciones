function aviplayer(varargin)
% AVIPLAYER(VARARGIN)
%
% This function may be called with 1 or no input arguments; either way, it launches a full-featured AVI player, 
% complete with "play," "pause," "forward," "reverse," "loop," "inter-frame pause," "skip-frame,"
% "forward 100 frames," "back 100 frames," "beginning-of-file," and "end-of-file capabilities."
% All functions were written in MATLAB, and were tested using R12.1 and R13.
%
% If called with 1 argument, the input argument must be a valid path/filename of a valid AVI file to read and display.
% E.g., 
% aviplayer('C:\Sample Data\ModelLERatFluorescein\LERat1.AVI')
%
% With no input arguments (e.g., aviplayer), the program will prompt the user for the location of the file.
%
% While aviplayer does not require the Image Processing Toolbox, it works
% faster with it. (With the IP Toolbox, it calls imshow; otherwise, it
% calls image(ind2rgb(cdata,map)).
%
% Note that there is a minor bug in TMW's aviinfo mfile (which is called by aviplayer). It
% should not affect the performance of this program. Nonetheless, for convenience,
% the first non-commented line of this program turns off the warning
% message that you would otherwise get running this program in R13.
% 
% Written by Brett Shoelson, Ph.D.
% Comments, suggestions: shoelson@helix.nih.gov
% Version 1 release: 8/12/03

warning off MATLAB:mir_warning_variable_used_as_function

%Is the IP Toolbox present?
try
	regionprops(ones(2));
	iptb = 1;
catch
	iptb = 0;
end	

if nargin == 0 | nargin == 1
    %Initialize
    delete(findobj('tag','aviplayer'));
    if nargin == 1
        [pathname, filename, tmp1] = fileparts(varargin{1});
    else
        [filename, pathname] = uigetfile('*.avi', 'Select an AVI file.');
        if ~filename
            disp('No appropriate file selected.');
            return
        end
        [tmp,tmp,tmp1] = fileparts(filename);
    end
    if ~strcmp(lower(tmp1),'.avi')
        disp('Inappropriate file selected/requested.');
        return
    end
    
    framedir = aviinfo(fullfile(pathname, filename));
    playvals.imnum = 1;
    playvals.playcontinue = 0;
    playvals.numims = framedir.NumFrames;
    playvals.increment = 1;
    playvals.paused = 0;
    playvals.quit = 0;
    
    figure('units', 'normalized', 'position', [0.25 0.2 0.5 0.55], 'name', ...
        ['Sequence: ' fullfile(pathname, filename)], 'NumberTitle', 'off', 'color', [0 0 0], 'doublebuffer', 'on', ...
        'backingstore', 'off', 'menubar', 'none', 'tag', 'aviplayer',...
		'defaultaxesxtick',[],'defaultaxesytick',[],...
        'closerequestfcn',...
        ['playvals = getappdata(gcf, ''playvals'');',...
            'tmp=get(gca,''title'');',...
            'tmps = get(tmp,''string'');',...
            'tmpc = get(tmp,''color'');',...
            'title(''Use the ''''STOP'''' button to close the figure and quit.'',''color'',''r'');',...
            'for ii = 1:5;',...
            'set(playvals.returnbutton,''foregroundcolor'',''r'');',...
            'pause(0.25);',...
            'set(playvals.returnbutton,''foregroundcolor'',''k'');',...
            'pause(0.25);',...
            'end;',...
            'title(tmps,''color'',tmpc);']);
    
    axes('position', [0.1 0.225 0.8 0.7], 'drawmode', 'fast');
    setappdata(gcf,'playbuttonfcnhandle',@playbutton);
    setappdata(gcf,'pausebuttonfcnhandle',@pausebutton);
    setappdata(gcf,'forwardbuttonfcnhandle',@forwardbutton);
    setappdata(gcf,'rewindbuttonfcnhandle',@rewindbutton);
    setappdata(gcf,'forward100buttonfcnhandle',@forward100button);
    setappdata(gcf,'rewind100buttonfcnhandle',@rewind100button);
    setappdata(gcf,'restartbuttonfcnhandle',@restartbutton);
    setappdata(gcf,'eofbuttonfcnhandle',@eofbutton);
    setappdata(gcf,'returnbuttonfcnhandle',@returnbutton);
    setappdata(gcf,'framesliderfcnhandle',@frameslider);
    
    setappdata(gcf,'framedir',framedir);
    setappdata(gcf,'iptb',iptb);
	
    uicontrol('style','frame','units','normalized','position',[0.05 0.01 0.9 0.1925],'foregroundcolor','b','backgroundcolor',[0 0.6 0.6]);
    playvals.playbutton = uicontrol('style', 'pushbutton', 'string', '4', 'units', 'normalized', 'position', [0.075 0.15 0.275 0.04], ...
        'callback','feval(getappdata(gcf,''playbuttonfcnhandle''));' , ...
        'fontname', 'webdings', 'fontunits', 'normalized', 'fontsize', 0.8, 'tag', 'playbutton', ...
        'tooltipstring', 'Starts playback and (re)sets increment to 1.');
    playvals.pausebutton = uicontrol('style', 'pushbutton', 'string', ';', 'units', 'normalized', 'position', [0.35 0.15 0.275 0.04], ...
        'callback', 'feval(getappdata(gcf,''pausebuttonfcnhandle''));', ...
        'fontname', 'Webdings', 'fontunits', 'normalized', 'fontsize', 0.8, ...
        'tooltipstring', 'Pauses/un-pauses playback.','tag','pausebutton');
    playvals.rewindbutton = uicontrol('style', 'pushbutton', 'string', '7', 'units', 'normalized', 'position', [0.15 0.11 0.2 0.04], ...
        'callback', 'feval(getappdata(gcf,''rewindbuttonfcnhandle''));', ...
        'fontname', 'webdings', 'fontunits', 'normalized', 'fontsize', 0.8, ...
        'tooltipstring', 'Decrease playback speed. (Slows down or reverses playback by decreasing frame increment.)');
    playvals.forwardbutton = uicontrol('style', 'pushbutton', 'string', '8', 'units', 'normalized', 'position', [0.35 0.11 0.2 0.04], ...
        'callback', 'feval(getappdata(gcf,''forwardbuttonfcnhandle''));', ...
        'fontname', 'webdings', 'fontunits', 'normalized', 'fontsize', 0.8, ...
        'tooltipstring', 'Increase playback speed. (Speeds playback by skipping frames.)','interruptible','off');
    playvals.forward100button = uicontrol('style', 'pushbutton', 'string', '+100', 'units', 'normalized', ...
        'position', [0.55 0.11 0.075 0.04], ...
        'callback', 'feval(getappdata(gcf,''forward100buttonfcnhandle''));', ...
        'fontunits', 'normalized', 'fontsize', 0.6, ...
        'tooltipstring', 'Jump forward 100 frames (or to end of file).');
    playvals.rewind100button = uicontrol('style', 'pushbutton', 'string', '-100', 'units', 'normalized', ...
        'position', [0.075 0.11 0.075 0.04], ...
        'callback', 'feval(getappdata(gcf,''rewind100buttonfcnhandle''));', ...
        'fontunits', 'normalized', 'fontsize', 0.6, ...
        'tooltipstring', 'Jump backward 100 frames (or to beginning of file).');
    playvals.restartbutton = uicontrol('style', 'pushbutton', 'string', '9', 'units', 'normalized', 'position', [0.075 0.07 0.075 0.04], ...
        'callback', 'feval(getappdata(gcf,''restartbuttonfcnhandle''));', ...
        'fontname', 'webdings', 'fontunits', 'normalized', 'fontsize', 0.8, ...
        'tooltipstring', 'Return to first frame.','tag','restartbutton');
    playvals.eofbutton = uicontrol('style', 'pushbutton', 'string', ':', 'units', 'normalized', 'position', [0.55 0.07 0.075 0.04], ...
        'callback', 'feval(getappdata(gcf,''eofbuttonfcnhandle''));', ...
        'fontname', 'webdings', 'fontunits', 'normalized', 'fontsize', 0.8, ...
        'tooltipstring', 'Go to last frame.','tag','eofbutton');
    playvals.returnbutton = uicontrol('style', 'pushbutton', 'string', '<', 'units', 'normalized', 'position', [0.15 0.07 0.4 0.04], ...
        'callback', 'feval(getappdata(gcf,''returnbuttonfcnhandle''));', ...
        'fontname', 'webdings', 'fontunits', 'normalized', 'fontsize', 0.8, ...
        'tooltipstring', 'End playback and close AVI Player.','tag','returnbutton');
    playvals.frameslider = uicontrol('style','slider','units','normalized','position',[0.075 0.02 0.55 0.04],...
        'min',1,'max',playvals.numims,'value',1,'fontsize',10,'userdata',framedir,...
        'callback','iptb = getappdata(gcf,''iptb'');feval(getappdata(gcf,''framesliderfcnhandle''),iptb);','sliderstep',[1/playvals.numims 10/playvals.numims]);
    playvals.loop = uicontrol('style','checkbox','units','normalized','position',[0.64 0.02 0.15 0.04],...
        'value',0,'fontsize',8,'string','Loop','backgroundcolor',[0 0.6 0.6],'tag','Loop');
    uicontrol('style','frame','units','normalized','position',[0.64 0.07 0.29 0.12]);
    playvals.pauseslider = uicontrol('style','slider','units','normalized','position',[0.66 0.11 0.25 0.0375],...
        'value',0,'min',0,'max',5,...
        'sliderstep',[0.1, 1/5],...
        'tooltipstring','Pauses display between frames by the number of seconds represented by the slider.',...
        'callback','tmp = get(gcbo,''value''); set(findobj(''tag'',''pausesecsbox''),''string'',sprintf(''%0.1f'',tmp));');
    tmp=uicontrol('style','text','string',sprintf('Inter-Frame Pause (seconds)'),'units','normalized',...
        'position',[0.66 0.145 0.25 0.04],...
        'fontname','helvetica','fontsize',7);
    uicontrol('style','text','string',0,'units','normalized','position',[0.66 0.077 0.02 0.03]);
    uicontrol('style','text','string',5,'units','normalized','position',[0.88 0.077 0.02 0.03]);
    playvals.pausesecsbox = uicontrol('style','text','units','normalized','position',[0.765 0.078 0.04 0.0275],...
        'string',0,'tag','pausesecsbox','fontsize',8,'fontweight','b');%,'backgroundcolor',[0 0.6 0.6]
    
    frame = aviread(framedir.Filename, 1);
	if iptb
		imshow(frame.cdata, frame.colormap);
	else
		image(ind2rgb(frame.cdata,frame.colormap));
	end
    if playvals.increment >= 1, signstr = '+'; else signstr = ''; end;
    title(sprintf('Frame %i of %i (Increment: %s %i)',playvals.imnum, playvals.numims,signstr,playvals.increment), 'color', 'g', ...
        'fontname', 'Helvetica', 'fontsize', 10);
else
    playvals = varargin{1};
    framedir = varargin{2};
    option = varargin{3};
    playvals.imnum = 1;
    playvals.playcontinue = 0;
    playvals.paused = 0;
    playvals.quit = 0;
    frame = aviread(framedir.Filename, playvals.imnum);
    switch option
		case 'Continue'
			if iptb
				imshow(frame.cdata, frame.colormap);
			else
				image(ind2rgb(frame.cdata,frame.colormap));
			end
			signstr = '+';
            title(sprintf('Frame %i of %i (Increment: %s %i)',playvals.imnum, playvals.numims,signstr,playvals.increment), 'color', 'g', ...
                'fontname', 'Helvetica', 'fontsize', 10);
            set(playvals.frameslider,'value',playvals.imnum);
        case 'Paused'
            title('Press PLAY to begin','color','r');
    end
end
setappdata(gcf, 'playvals', playvals);

waitforbuttonpress;
tmp = get(gco);
if strcmp(tmp.Tag, 'playbutton')
    playvals = getappdata(gcf, 'playvals');
    playvals.playcontinue = 1;
    set(playvals.playbutton,'foregroundcolor',[0 0.7 0]);
    setappdata(gcf, 'playvals', playvals);
elseif strcmp(tmp.Tag, 'returnbutton')
    returnbutton;
    delete(gcf);
    return
elseif strcmp(tmp.Tag,'Loop')
    set(gco,'value',~get(gco,'value'));
    drawnow;
    aviplayer(playvals,framedir,'Continue');
else
    aviplayer(playvals,framedir,'Paused');
end

while playvals.playcontinue
    playvals = getappdata(gcf, 'playvals');
    while playvals.paused
        playvals = getappdata(gcf, 'playvals');
        if playvals.quit
            playvals.playcontinue = 0;
            playvals.paused = 0;
            delete(gcf);
            return
        end
        drawnow;
    end
    
    frame = aviread(framedir.Filename, playvals.imnum);
	if iptb
		imshow(frame.cdata, frame.colormap);
	else
		image(ind2rgb(frame.cdata,frame.colormap));
	end
    if playvals.increment >= 1, signstr = '+'; else signstr = ''; end;
    title(sprintf('Frame %i of %i (Increment: %s %i)',playvals.imnum, playvals.numims,signstr,playvals.increment), 'color', 'g', ...
        'fontname', 'Helvetica', 'fontsize', 10);
    set(playvals.frameslider, 'value', playvals.imnum);
    
    if playvals.increment > 0
        if playvals.imnum == playvals.numims
            if get(playvals.loop,'value')==1;
                playvals.imnum=1;
                pauselength = get(playvals.pauseslider,'value');
                pause(pauselength);
				frame = aviread(framedir.Filename, playvals.imnum);
				if iptb
					imshow(frame.cdata, frame.colormap);
				else
					image(ind2rgb(frame.cdata,frame.colormap));
				end
				if playvals.increment >= 1, signstr = '+'; else signstr = ''; end;
                title(sprintf('Frame %i of %i (Increment: %s %i)',playvals.imnum, playvals.numims,signstr,playvals.increment), 'color', 'g', ...
                    'fontname', 'Helvetica', 'fontsize', 10);
                set(playvals.frameslider, 'value', playvals.imnum);
            else
                playvals.playcontinue = 0;
                aviplayer(playvals,framedir,'Paused');
            end
        end
        playvals.imnum = min(playvals.imnum + playvals.increment, playvals.numims);
    elseif playvals.increment < 0
        if playvals.imnum == 1
            if get(playvals.loop,'value')==1;
                playvals.imnum = playvals.numims;
                pauselength = get(playvals.pauseslider,'value');
                pause(pauselength);
                frame = aviread(framedir.Filename, playvals.imnum);
				if iptb
					imshow(frame.cdata, frame.colormap);
				else
					image(ind2rgb(frame.cdata,frame.colormap));
				end
                if playvals.increment >= 1, signstr = '+'; else signstr = ''; end;
                title(sprintf('Frame %i of %i (Increment: %s %i)',playvals.imnum, playvals.numims,signstr,playvals.increment), 'color', 'g', ...
                    'fontname', 'Helvetica', 'fontsize', 10);
                set(playvals.frameslider, 'value', playvals.imnum);
                
            else
                playvals.increment = 1;
                playvals.playcontinue = 0;
                aviplayer(playvals,framedir,'Paused');
            end
        end
        playvals.imnum = max(playvals.imnum + playvals.increment, 1);
    end
    if ~isempty(findobj('tag','aviplayer'))
        setappdata(gcf, 'playvals', playvals);
        pauselength = get(playvals.pauseslider,'value');
        %pause(pauselength);
        for ii = 0.1:0.1:pauselength %This loop allows faster keypress-caused escape than, say, pause(5) 
            pause(0.1);
        end
        drawnow; %This is necessary for the case of pauselength == 0
    else
        return
    end
    if playvals.quit
        playvals.playcontinue = 0;
        playvals.paused = 0;
        delete(gcf);
        return
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SUBFUNCTIONS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function playbutton
playvals = getappdata(gcf, 'playvals');
if ~playvals.paused, 
    playvals.playcontinue = 1;
    set(playvals.playbutton,'foregroundcolor',[0 0.7 0]);
    setappdata(gcf, 'playvals', playvals);
end
return

function pausebutton
playvals = getappdata(gcf, 'playvals');
playvals.paused = ~playvals.paused;
if playvals.paused
    set(playvals.pausebutton, 'foregroundcolor', 'r');
    title('Press PAUSE to resume...', 'color', 'r');
    set(playvals.playbutton, 'foregroundcolor','k');
else
    if playvals.increment >= 1, signstr = '+'; else signstr = ''; end;
    title(sprintf('Frame %i of %i (Increment: %s %i)',playvals.imnum, playvals.numims,signstr,playvals.increment), 'color', 'g', ...
        'fontname', 'Helvetica', 'fontsize', 10);
    set(playvals.pausebutton, 'foregroundcolor', 'k');
    set(playvals.playbutton,'foregroundcolor',[0 0.7 0]);
end
setappdata(gcf, 'playvals', playvals);
return

function forwardbutton
playvals = getappdata(gcf, 'playvals');
if ~playvals.paused
    playvals.increment = playvals.increment + 1;
    if playvals.increment == 0; playvals.increment = 1; end
    setappdata(gcf,'playvals',playvals);
end
return

function rewindbutton
playvals = getappdata(gcf, 'playvals');
if ~playvals.paused
    playvals.increment = playvals.increment - 1;
    if playvals.increment == 0; playvals.increment = -1; end
    setappdata(gcf, 'playvals', playvals);
end
return

function forward100button
playvals = getappdata(gcf, 'playvals');
if ~playvals.paused
    playvals.imnum = min(playvals.imnum+100, playvals.numims);
    setappdata(gcf, 'playvals', playvals);
end
return

function rewind100button
playvals = getappdata(gcf, 'playvals');
if ~playvals.paused
    playvals.imnum = max(playvals.imnum-100, 1);
    setappdata(gcf, 'playvals', playvals);
end
return

function restartbutton
playvals = getappdata(gcf, 'playvals');
if ~playvals.paused
    playvals.imnum = 1;
    setappdata(gcf, 'playvals', playvals);
end
return

function eofbutton
playvals = getappdata(gcf, 'playvals');
if ~playvals.paused
    playvals.imnum = playvals.numims;
    setappdata(gcf, 'playvals', playvals);
end
return

function returnbutton
playvals = getappdata(gcf, 'playvals');
playvals.playcontinue = 0;
playvals.quit = 1;
setappdata(gcf, 'playvals', playvals);
return

function frameslider(iptb)
playvals = getappdata(gcf, 'playvals');
framedir = get(gco,'userdata');
playvals.imnum = floor(get(playvals.frameslider,'value'));
frame = aviread(framedir.Filename, playvals.imnum);
if iptb
	imshow(frame.cdata, frame.colormap);
else
	image(ind2rgb(frame.cdata,frame.colormap));
end
if playvals.increment >= 1, signstr = '+'; else signstr = ''; end;
title(sprintf('Frame %i of %i (Increment: %s %i)',playvals.imnum, playvals.numims,signstr,playvals.increment), 'color', 'g', ...
    'fontname', 'Helvetica', 'fontsize', 10);
setappdata(gcf, 'playvals', playvals);
return
