function GUIfft(action)
%GUIfft is a simple graphical user interface-driven function for 
%computing and displaying the FFT of a signal loaded from a text file
%
%   Format:    GUIfft
%
%   (Only the last column of data in the text file is used).
%
%  Features illustrated
%  - using the main function as the callback for graphic events
%  - making customized figure menu with "uimenu"
%  - making a pushbutton with "uicontrol"
%  - storing information in the "userdata" property
%  - using the built-in file dialog box
%  - responding to mouse clicks with the "ButtonDownFcn" property
%  - locating mouse position with "currentpoint" property
%  - selecting objects with "tag" property and "findobj" function
%
%Created April 10, 2001 by Bill Miller

%The "main" function (GUIfft) serves as both the initially called
%function, and the callback function for all of the graphic events.
%It is thus repeatedly called. The only actual code here handles
%the input argument, whose value indicates which action to take.

if nargin<1
   action='create';        %happens during the initial call to GUIfft
end

switch action
	case 'create'
      CreateGUI            %sub-function: create interface
      
   case 'loadfile'
      LoadFile;            %sub-function: load/plot raw data
      
   case 'dofft'
      doFFT;               %sub-function: compute/plot FFT
      
   case 'threshold'
      Threshold;           %sub-function: create new threshold
end

%----------------------------------------------------------
function CreateGUI
%This function creates the user interface (figure window,
%and custom menu, axis, and pushbutton

%1. Create figure (custom title, no default menubar)
%--> Note: for all objects, you should always specify 
%    the "units" before the "position"!
hfig=figure(...
   'units','pixels','position',[200 50 500 400],...
   'tag','GUIfft', 'name','GUIfft',...
   'menubar','none','numbertitle','off');

%2. Create custom File menu for figure, with callbacks:
%   Open...    (calls back to GUIfft, arg="loadfile")
%   --------
%   Exit       (closes figure window (thus, ending program)
hmenu=uimenu('Label','File');
uimenu(hmenu,'label','Open...','callback','GUIfft loadfile')
uimenu(hmenu,'label','Exit','callback','closereq','separator','on');

%3. Create axis 
%(mouse click generates callback to GUIfft: arg="threshold")
haxis=axes('units','pixels','position',[65 130 390 180],...
   'nextplot','replacechildren',...
   'ButtonDownFcn','GUIfft threshold');
title('Signal: none','fontweight','bold')

%5. Create a button for doing fft
%(Click calls back to GUIfft, arg="dofft")
hbutton=uicontrol('style','pushbutton',...
   'units','pixels','pos',[230 40 70 30],...
   'string','Do FFT',...
   'callback','GUIfft dofft');

%6. Store axis handle in figure's "userdata" property so
%   we can retrieve it later.  Alternatively, we could:
%   - set the "tag" property, and later search on it
%   - just later search for the only axis on the figure
%   - use a global variable to store the axis handle
set(hfig,'userdata',haxis)

%----------------------------------------------------------
function LoadFile
%This function opens a file dialog, loads a text file, 
%(containing the signal) and plots the data

%get the axis handle
haxis=get(gcf,'userdata');

%call built-in file dialog to select filename
[filename,pathname]=uigetfile('*.txt','Select signal data file');
if ~ischar(filename),return,end

%load file (and keep only last column)
longfilename=strcat(pathname,filename);
s=load(longfilename);
if size(s,2)>1
   s=s(:,end);
end

%plot signal (with tag='data') and set axis title
axes(haxis)
cla  %clear anything on the axis (but keep axis settings)
plot(s,'b','tag','signal')
title(['Signal: ' filename],'fontweight','bold')

%----------------------------------------------------------
function doFFT
%This function computes and plots the fourier transform
%of the signal currently plotted on the axis

Fs=1000; %assume 1 KHz sampling rate

%get axis handle
haxis=get(gcf,'userdata');

%get handle of data plot on axis (if none, return)
hplot=findobj(haxis,'tag','signal');
if isempty(hplot),return, end

%get y data associated with plot, remove mean
s=get(hplot,'ydata');
s=detrend(s,0);

%Compute FFT, throw out second half, and keep real part
%Note: this is NOT to scale!
FT=fft(s);
PtsToKeep = ceil(length(FT)/2);
FT=abs(FT(1:PtsToKeep));

%make vector of frequencies for plotting
f=(0:PtsToKeep-1)*Fs/length(s);

%plot results (delete current data first)
axes(haxis)
delete(hplot)
plot(f,FT,'b','tag','fft');

title('Amplitude spectrum (not to scale!)',...
   'fontweight','bold')
xlabel('Frequency, Hz')
ylabel('Arbitrary units')

%----------------------------------------------------------
function Threshold
%This function puts a threshold line at the location of
%a mouse click on the axis.

%get axis handle
haxis=get(gcf,'userdata');

%find and delete any existing threshold line
hthresh=findobj(haxis,'tag','threshold');
delete(hthresh)  %(works even if hthresh==[])

%get the y-position of the clicked location
pt=get(gca,'currentpoint');
ypos=pt(1,2);

%make the new threshold line
ydata=[ypos ypos];
xdata=get(gca,'xlim');
hthresh=line(xdata,ydata,...
   'color','r','linewidth', 1.5,...
   'erasemode','xor','tag','threshold');

%force graphics updating now
drawnow 


