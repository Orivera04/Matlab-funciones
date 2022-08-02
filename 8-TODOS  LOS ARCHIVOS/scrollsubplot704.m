function [fh ah] = scrollsubplot704(dx,x,y,fhandle,aplot,varargin)
% function [fh ah] = scrollsubplot704(dx,x,y,fhandle,aplot,varargin)
% dx: size of window
% x: e.g. time
% y: e.g. signal or [y1 y2],[y1' y2']  with the signals of the 
%    same length in the row and the number of signals in the column
% fhandle: handle of a figure
% aplot (automatic plot): ['on' , 'off']
% Description: Scrollsubplot704 with dynamic range of time (x) axis, subplot
%              enabled
% If fhandle is not specified, then the gcf is used
% If aplot is set to 'on', then the specified signal (x,[y y2 ...]) is automatically
% plotted into the figure determined by fhandle, or to gcf
% varargin is reserved for future use
%
% Note: If you don´t use autoplot, it´s important to use
% the same signals for plot and scrollsubplot704, and to always plot first!
%
% Example 1:
% x=0:1e-2:2*pi;
% y=sin(4*x);
% f = figure;
% [fh ah] = scrollsubplot704(2,x,y,f,'on');
%
% Example 2:
% x=0:1e-2:2*pi;
% y=sin(4*x);
% figure
% plot(x,y)
% [fh ah] = scrollsubplot704(3,x,y,[],'off');
%
% Example 3:
% x=0:1e-2:2*pi;
% y=sin(4*x);
% [fh ah] = scrollsubplot704(3,x,[y' y' y'],[],'on');
%
% 
% Earlier Versions:
%
% scrollplot() by Wolfgang Stiegmaier
%
% Acknowledgements:
%
% function scrollsubplot(dx,x,varargin); by
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%% Benoit Cantin, 7 mars 2005. %%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%
% function scrollplotdemo by
% Created by Steven Lord, slord@mathworks.com
% Uploaded to MATLAB Central
% http://www.mathworks.com/matlabcentral
% 7 May 2002
%
%
% Permission is granted to adapt this code for your own use.
% However, if it is reposted this message must be intact:
%
% Created by Wolfgang Stiegmaier, w.stiegmaier@cortronik.co.at



% Initiation
a =[];
f =[];
[siglen Idx] = size(y); %determine number of signals

%treat input arguments

switch nargin
    
    case 3 %neither fhandle nor aplot are specified
        f=gcf; %set figure handle to gcf
        a=gca; %set figure handle to gca
    
    case 4 %fhandle is specified
        try
            f = fhandle; %set figure handle f to specified handle
            a = get(f,'Children'); %retrieve all axis handles
        catch
            warning('No valid figure/axis handle') %if there is no axis quit
            return %quit
        end

    case 5
    f = fhandle;
        switch lower(aplot)
            case 'on'
                if (~isempty(f)) %if fhandle is  specified and auto plot is wanted
                    if (Idx==1) %check if there is more than one signal
                    figure(f); %call figure with specified handle
                    plot(x,y');
                    a = get(f,'CurrentAxes'); %retrieve current axis handle
                    else %(Idx==1)
                       for i = 1:Idx %create subplots
                            subplot(Idx,1,i); %note: only one dimension is used yet
                            plot(x,y(:,i)');
                       end %i = 1:Idx
                       a = get(f,'Children'); %retrieve children axis handle
                    end %(Idx==1)
                else
                    f= figure; %create a figure
                    
                    if (Idx==1)%check if there is more than one signal
                    figure(f); %call figure with specified handle
                    plot(x,y');
                    a = get(f,'CurrentAxes'); %retrieve current axis handle
                    else %(Idx==1)
                       for i = 1:Idx %create subplots
                            subplot(Idx,1,i);%note: only one dimension is used yet
                            plot(x,y(:,i)');
                       end %i = 1:Idx 
                       a = get(f,'Children'); %retrieve children axis handle
                    end %(Idx==1)
                end
            case 'off'
               if (~isempty(f)) %if fhandle is  specified but auto plot is not wanted
                   figure(f);                  
                   a = get(f,'Children'); %retrieve current axis handle
               else
                   f = gcf; %set handle to current figure
                   a = get(f,'Children'); %retrieve current axis handle
               end
                
            otherwise
                warning('Type "help scrollplot704" for more information')
                fh = [];
                ah = [];
                return %quit
        end

    otherwise
        %warning('Type "help scrollplot704" for more information')
        %return
        warning('Variable input parameters are used to specify subplot properties, this feature is not implemented yet')
end



if isempty(a) %quit if no axis is open
    warning('No axis accessible')
    fh = [];
    ah = [];
    return
end

% This avoids flickering when updating the axis
set(f,'doublebuffer','on');
% Set appropriate axis limits and settings
set(a,'xlim',[0 dx]);
%set(a,'ylim',[min(y) max(y)]);

% Generate constants for use in uicontrol initialization
pos=get(a,'position');
xmax=max(x);
xmin=min(x);

% This will create the position of a slider which is just underneath the axis
% but still leaves room for the axis labels above the slider
if iscell(pos) %determine is pos is a cell for multiple signals
    Newpos=[pos{1}(1) pos{1}(2)-0.1 pos{1}(3) 0.05];
else
    Newpos=[pos(1) pos(2)-0.1 pos(3) 0.05];
end

% Setting up callback string to modify XLim of  all axis
% based on the position of the slider (gcbo)
for i = 1:Idx
    if i == 1;
        S=['cha = get(gcf,''Children'');, set(cha(' num2str(i+1) '),''xlim'',get(gcbo,''value'')+[0 ' num2str(dx) '])'];
    else
        S=[S ', set(cha(' num2str(i+1) '),''xlim'',get(gcbo,''value'')+[0 ' num2str(dx) '])'];
    end
end
% Creating Uicontrol with initial value of the minimum of x
h=uicontrol('style','slider',...
    'units','normalized','position',Newpos,...
    'callback',S,'min',xmin,'max',xmax-dx,'value',xmin);
%initialize postion of plot
set(a,'xlim',[xmin xmin+dx]);

% set output parameters
fh = f;
ah = a;
