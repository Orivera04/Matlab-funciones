function GTrace(select)
%GTRACE     Graph tracing utility
%
%To start: click or focus the plot you want to trace, then type GTrace in Matlab environment
%To stop: one click on the plot you're tracing
%
%If there're more than one plot in an axes, you can select which line to trace by
%selecting the listbox at the lower left corner
%
%Furi Andi Karnapi and Lee Kong Aik
%DSP Lab, School of EEE
%Nanyang Technological University
%Singapore
%March 2002

if nargin==0;
    currFcn = get(gcf, 'windowbuttonmotionfcn');
    currFcn2 = get(gcf, 'windowbuttondownfcn');
    currTitle = get(get(gca, 'Title'), 'String');

    handles = guidata(gca);
    if (isfield(handles,'ID') & handles.ID==1)
        disp('GTrace is already active.');
        return;
    else
        handles.ID = 1;
        disp('GTrace started.');
    end

    theDot = text(0, 0, '\leftarrow');
    set(theDot, 'FontWeight', 'bold', 'FontSize', 10);

    handles = createListBox(handles);
    handles.currFcn = currFcn;
    handles.currFcn2 = currFcn2;
    handles.currTitle = currTitle;
    handles.theDot = theDot;
    handles.theState = uisuspend(gcf);
    guidata(gca, handles);

    set(gcf, 'windowbuttonmotionfcn', 'GTrace(''OnMouseMove'')');        
    set(gcf, 'windowbuttondownfcn', 'GTrace(''OnMouseDown'')');          
else
   switch select
        
   case 'OnListBoxCallBack'
       GTrace_ListBoxCallback;
   case 'OnMouseMove'
       GTrace_OnMouseMove;
   case 'OnMouseDown'
       GTrace_OnMouseDown;
   end
end

%---------------------------------------------------------------------------------------
function [out] = createListBox(handles)
ListBoxPost = [2 2 60 20];
Hc_listbox = uicontrol(gcf,'style','listbox','position',ListBoxPost);
lineObj = findobj(gca, 'Type', 'line');
numOfLines = max(size(lineObj));
if numOfLines > 0
    dispString = '1';
else
    return;
end
for i=2:numOfLines
    dispString = [dispString sprintf('|%d',i)];
end 
set(Hc_listbox,'string',dispString);
set(Hc_listbox,'callback','GTrace(''OnListBoxCallBack'')');
handles.whichOne = 1;
handles.ListBox = Hc_listbox;
out = handles;

GTrace_ListBoxCallback(Hc_listbox);

%---------------------------------------------------------------------------------------
function GTrace_OnMouseMove

global xData yData;

pt = get(gca, 'CurrentPoint');
xInd = pt(1, 1);
lineObj = findobj(gca, 'Type', 'line');
xLim = get(gca, 'XLim');
yLim = get(gca, 'YLim');
numOfLines = max(size(lineObj));

handles = guidata(gca);
whichOne = handles.whichOne;

if ((xInd < xLim(1)) | (xInd > xLim(2)) | (xInd < min(xData)) | (xInd > max(xData)))
    title('Out of X limit');
    return;
end

yInd = interp1(xData, yData, xInd);
if ((yInd < yLim(1)) | (yInd > yLim(2)))
    title('Out of Y limit');
    return;
end

set(handles.theDot, 'Position', [xInd, yInd]);
title(['LINE ' num2str(whichOne) ' of ' num2str(numOfLines) '; X = ' num2str(xInd) ...
        ', Y = ' num2str(yInd)]);

%---------------------------------------------------------------------------------------
function GTrace_ListBoxCallback(aData)

global xData yData

handles = guidata(gca);
if (nargin ~= 1)
    handles.whichOne = get(gcbo,'value');
else
    handles.whichOne = get(aData,'value');
end    

whichOne = handles.whichOne;
guidata(gca,handles);

lineObj = findobj(gca, 'Type', 'line');
lineObj = lineObj(whichOne);
xData = get(lineObj, 'xData');
yData = get(lineObj, 'yData');
xLim = get(gca, 'XLim');
yLim = get(gca, 'YLim');
reqInd = find((xData >= xLim(1)) & (xData <= xLim(2)));
if (length(reqInd) < 2) %Suppose the user zoom the data until the reqInd = []
    i1 = find(xData < xLim(1)); %Let the reqInd(1) = the last indice before min x axis
    i2 = find(xData > xLim(2)); %Let the reqInd(2) = the first indice after max x axis
    reqInd = [i1(end):i2(1)];
end
xData = xData(reqInd);
yData = yData(reqInd);

%---------------------------------------------------------------------------------------
function GTrace_OnMouseDown

handles = guidata(gca);
set(gcf, 'windowbuttonmotionfcn', handles.currFcn);
set(gcf, 'windowbuttondownfcn', handles.currFcn2);
title(handles.currTitle);
delete(handles.theDot);
delete(handles.ListBox);
uirestore(handles.theState);
handles.ID=0;
guidata(gca,handles);
clear xData yData;
disp('GTrace ended.');