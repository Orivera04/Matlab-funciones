function fout = awaitbar(x,whichbar,varargin)
%AWAITBAR Display progress bar with abort button and upon clicking on the
%					abourt button or the close figure button will abort the process 
%					and close the waitbar
% 
% USAGE:
%  H = awaitbar(x,message):
%			 creates and displays a waitbar of fractional length X with the message 
%			 text in the waitbar figure. The handle to the waitbar figure is returned 
%			 in H. x should be between 0 and 1.  
%	 H = awaitbar(x,message,figTitle):
%			 displays text in the figure title
%	 H = awaitbar(x,message,figTitle,figPosition):
%      figure is positioned according to the value specified in figPosition
%	 awaitbar(x): update in the most recently created waitbar window 
%	 awaitbar(x,H): update in waitbar H
%	 awaitbar(x,H,message): will update the message text in  the waitbar figure,
%	 awaitbar(x,H,message,figTitle): will update the title text in  the waitbar figure,
%	 hh = awaitbar(x,H,....): if the output is assigned to the variable 'hh',
%					then when the waitbar figure is closed by clicking close button, then 
%					the loop process will be aborted.(See example below)
%
% FEATURES
% 1.  Abort button to abort the process and close the waitbar figure.
% 1.  It stays on top of other figures. % Thanks to Peder Axensten(11398). 
% 2.  Only one waitbar window, so no old ones left around. Thanks to Peder Axensten(11398).
% 5.  Elapsed time and Estimated Remaining time are shown in the figure.
% 6.  Update of the progress is also shown in the figure title.
% 7.  User defined figure position
%
% EXAMPLES:
%   abort = false;	% This initialisation is needed to use abort the process. 
%										% Please do not change variable name "abort" otherwise 
%										% "abort" button will not work
%   h = awaitbar(0,'Running Monte-Carlo, please wait...'); 
%   for i=1:100,
%			pause(0.2); % Do some computational stuff
%			hh=awaitbar(i/100,h,'Running the process','Progress'); 
%																			% asssign the ouput to the variable "hh"
%																			% in order to abort the process by closing
%																			% the waitbar figure
%			if abort; close(h);break; end   % Abort the process by clicking abort button
%			if isempty(hh); break; end      % Break the process when closing the figure
%		end
%
% See also WAITBAR, WAITBAR (11398)
%
% I appreciate the bug reports and suggestions.
%
% Copyright 2007 by Durga Lal Shrestha.
% eMail: durgals@hotmail.com
% $Date: 2007/06/07
% $Revision: 1.0.0 $ $Date: 2007/06/07 $
%
%% Argument check
figTitle = 'Progress'; % default title
if nargin>=2
    if ischar(whichbar)
        % Delete all pre-existing waitbar graphical objects (Thanks to Peder Axensten(11398)
        showhid=get(0, 'showhid');
        set(0, 'showhid', 'on');
        try delete(findobj('Tag', 'TMWAWaitbar')); catch end
        set(0, 'showhid', showhid);
				%
        type=2; %we are initializing
        name=whichbar;
        t0=clock;
        if nargin>=3
            figTitle = varargin{1};
        end
    elseif isnumeric(whichbar)
        type=1; %we are updating, given a handle
        f=whichbar;
				if x==1;delete(f);clear f; end;
        if nargin == 4
            figTitle = varargin{2};
        end
        f = findobj(allchild(0),'flat','Tag','TMWAWaitbar');
%         if isempty(f)
%             fout=1;
%          end
    else
        error('AWaitbar:InvalidInputs', ['Input arguments of type ' class(whichbar) ' not valid.'])
    end
elseif nargin==1
    f = findobj(allchild(0),'flat','Tag','TMWAWaitbar');
    if isempty(f)
        type=2;
        name='AWaitbar';
				t0=clock;
    else
        type=1;
        f=f(1);
    end
else
    error('AWaitbar:InvalidArguments', 'Input arguments not valid.');
end

%% 
x = max(0,min(100*x,100));
switch type
    case 1,  % awaitbar(x)    update
        try p = findobj(f,'Type','patch');
            l = findobj(f,'Type','line');
            lapseObj = findobj(f,'Tag','lapseTag');
            etaObj = findobj(f,'Tag','etaTag');
            percentObj = findobj(f,'Tag','percentTag');
            if isempty(f) | isempty(p) | isempty(l) | isempty(lapseObj)|isempty(etaObj)|isempty(percentObj),
                error('Couldn''t find Awaitbar handles.');
            end
            set(f,  'Name',   [num2str(floor(x)) '% ' figTitle]);
            t0= get(f,'UserData');
            xpatch = [0 x x 0];
            set(p,'XData',xpatch')
            xline = get(l,'XData');
            set(l,'XData',xline);
            time_lapse = etime(clock,t0);
            time_lapse = round(time_lapse);
            if(x~=0),time_eta=(time_lapse/x)*(100-x);else return; end;
            time_eta=round(time_eta);
            str_lapse= get_timestr(time_lapse);
            str_eta= get_timestr(time_eta);
            set(lapseObj,'String',str_lapse);
            set(etaObj,'String',str_eta);
            set(percentObj,'String',strcat(num2str(floor(x)),'%'));
            if nargin>2,
                % Update awaitbar title:
                hAxes = findobj(f,'type','axes');
                hTitle = get(hAxes,'title');
                set(hTitle,'string',varargin{1});
            end
        catch end;
        %%
    case 2,  % awaitbar(x,name)  initialize
        oldRootUnits = get(0,'Units');
        set(0, 'Units', 'points');
        screenSize = get(0,'ScreenSize');
        axFontSize=get(0,'FactoryAxesFontSize');
        pointsPerPixel = 72/get(0,'ScreenPixelsPerInch');
        width = 360 * pointsPerPixel;
        height = 120 * pointsPerPixel;

        if nargin==4
            fig_pos = varargin{4};
            pos = [fig_pos(1) fig_pos(2)-height fig_pos(3) height];
        else
            pos = [screenSize(3)/2-width/2 screenSize(4)/2-height/2 width height];
        end
        f = figure(...
            'Units', 'points', ...
            'Position', pos, ...
            'Resize','off', ...
            'CreateFcn','', ...
            'NumberTitle','off', ...
            'IntegerHandle','off', ...
            'MenuBar', 'none', ...
            'Tag','TMWAWaitbar',...
            'Visible','on',...
            'name',figTitle,...
            'UserData',t0);
        h = uicontrol('Style', 'pushbutton', 'String', 'Abort',...
            'BackgroundColor',[0 1 1],'FontWeight','bold',...
            'FontSize',11,'units','Points','Position', [0.8.*width  3 50 30],...
            'Callback', 'abort=true;');
        colormap([]);
        axNorm=[.05 .55 .82 .2];
        axPos=axNorm.*[pos(3:4),pos(3:4)];
        uicontrol('Parent',f,...
            'Units','points',...
            'Position',[pos(3).*0.08 pos(4).*0.25 pos(3).*0.45 pos(4).*0.17],...
            'String','Time Elapsed:',... 
            'BackgroundColor', [0.80 0.80 0.80],...            
            'Style','text');
        uicontrol('Parent',f,...
            'Units','points',...
            'Position',[pos(3).*0.00 pos(4).*0.05 pos(3).*0.45 pos(4).*0.17],...
            'String','Estimated Time Remaining:',...   
            'BackgroundColor', [0.80 0.80 0.80],...            
            'Style','text');
        uicontrol('Parent',f,...
            'Units','points',...
            'Position',[pos(3).*0.40 pos(4).*0.25 pos(3).*0.15 pos(4).*0.17],...           
            'BackgroundColor', [0.80 0.80 0.80],...            
            'Style','text',...
            'Tag','lapseTag');
        uicontrol('Parent',f,...
            'Units','points',...
            'Position',[pos(3).*0.40 pos(4).*0.05 pos(3).*0.15 pos(4).*0.17],...       
            'BackgroundColor', [0.80 0.80 0.80],...           
            'Style','text',...
            'Tag','etaTag');
        uicontrol('Parent',f,...
            'Units','points',...
            'Position',[pos(3).*0.88 pos(4).*0.55 pos(3).*.11 pos(4).*0.20],...
            'String','%',...
            'Style','text',...
            'BackgroundColor', [0.80 0.80 0.80],...
            'ForegroundColor',[1 0 0],...
            'FontSize',[10],...
            'FontWeight','bold',...
            'Tag','percentTag');
        h = axes('XLim',[0 100],...
            'YLim',[0 1],...
            'Box','on', ...
            'Units','Points',...
            'FontSize', axFontSize,...
            'Position',axPos,...
            'XTickMode','manual',...
            'YTickMode','manual',...
            'XTick',[],...
            'YTick',[],...
            'XTickLabelMode','manual',...
            'XTickLabel',[],...
            'YTickLabelMode','manual',...
            'YTickLabel',[]);
        %tHandle=title(name);
        tHandle=get(h,'title');
        %oldTitleUnits=get(tHandle,'Units');
        set(tHandle,...
            'Units',      'points',...
            'String',     name,'FontSize',[11]);

        xpatch = [0 x x 0];
        ypatch = [0 0 1 1];
        xline = [100 0 0 100 100];
        yline = [0 0 1 1 0];
        p = patch(xpatch,ypatch,'r','EdgeColor','r','EraseMode','none');
        l = line(xline,yline,'EraseMode','none');
        set(l,'Color',get(gca,'XColor'));
        set(f,'HandleVisibility','callback','visible','on');
        set(0, 'Units', oldRootUnits);
end  % case
drawnow;
%% Put the waitbar window on top of all others (Thanks to Peder Axensten(11398).
children=allchild(0);
if((numel(children) > 1) && (children(1) ~= f))
    uistack(f, 'top');
end
%%
if nargout==1,
    fout = f;
end
end
%% Internal Function
function timestr= get_timestr(s) %(Thanks to Peder Axensten(11398).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%	Return a time string, given seconds.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	
	h=			floor(s/3600);						% Hours.
	s=			s - h*3600;
	m=			floor(s/60);						% Minutes.
	s=			s - m*60;							% Seconds.
	timestr=	sprintf('%0d:%02d:%02d', h, m, floor(s));
end
