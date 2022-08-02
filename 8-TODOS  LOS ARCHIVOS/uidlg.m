function out=uidlg(varargin);
% ---------------------------------------------------------------------
% function button=uidlg(varargin)               |     Version: 0.91
% ---------------------------------------------------------------------
% Usage:
%
%   button=uidlg(title,message,button1,button2,button3,...)
%          
% At least 3 input args must be specified. Any further button is 
% optional. 
%
% Example:
%       button=('Error','Check DDE Server Connection','OK','Cancel')
% ---------------------------------------------------------------------
% Stefan Billig
% Delphi Corporation
% TCL Luxembourg
% email: stefan.billig@delphi.com
% ---------------------------------------------------------------------
% Last Change: 2004-04-01             | (c) 2003, 2004 by Stefan Billig
% ---------------------------------------------------------------------

global out;
if nargin < 3
    disp('Not enough input values!')
    return
end

% determine width values
ftSize=11;
lButt=70;
scSize=get(0,'ScreenSize');
% String 1 < String 2
if length(varargin{1}) < length(varargin{2})
    msgWdth=length(varargin{2})*ftSize*0.7;
    winWdth=length(varargin{2})*ftSize*1.01
    msgX=(winWdth-msgWdth)/2
% String 1 >= String 2   
else
    msgWdth=length(varargin{2})*ftSize*0.7
    winWdth=length(varargin{1})*ftSize*1.05
    msgX=(winWdth-msgWdth)/3
end
% distance between buttons
distButt=(winWdth-(nargin-2)*lButt)/(nargin-2+1);
f1=figure('Position', [scSize(3)*0.5-winWdth/2 scSize(4)*0.5 winWdth 100],...
    'Resize','off');
set(f1,...
    'MenuBar','none','NumberTitle','off','Name',varargin{1},...
    'Units', 'points')
a1=axes;
set(a1, 'Position', [0 0 1 1],'Visible','off')
text('Units','points','Position',[msgX ftSize*5],'FontSize',ftSize,'FontWeight','bold',...
    'String',varargin{2},'Color',[1 0 0])
% place buttons
for i=1:(nargin-2)
    uicontrol('Style','pushbutton','String',varargin{i+2},...
        'Position',[distButt*i+lButt*(i-1) 20 lButt 25],...
        'Callback','global out,out=get(gco,''String'');close(gcf),clear out');
end
% wait for user reaction before returning
waitfor(f1)