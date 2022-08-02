function neurdemo()
%NEURDEMO Financial EXPO Neural Network demonstration.
%   NEURDEMO Financial Expo Neural Network demonstration.  This demonstration
%   performs linear, Levenberg-Marquardt, and fast backpropagation techniques
%   for stock price and price change forecasting.
%   The functions NNETLIN.M, NNETBP.M, and NNETLM.M are called from this 
%   routine.

%       Author(s): C.F. Garvin, 6-21-95
%       Copyright 1995-2002 The MathWorks, Inc. 
%       $Revision: 1.14 $   $Date: 2002/04/14 21:45:43 $

nntwarn off %Turns off all neural network toolbox warnings (R12)...

SCR = get(0,'screensize');
SysIDWin = figure('numbertitle','off','name',...
       'Neural Network - Price Behavior','position',...
       [SCR(3)*.15 SCR(4)*.01 SCR(3)*.7 SCR(4)*.9]);
set(gcf,'pointer','watch')
FigPos = get(gcf,'position');

Top = FigPos(4);
Right = FigPos(3);
if SCR(3) < 1024
  Bwidth = 85;
  Bspace = 2;
  Bheight = 16;
else
  Bwidth = 85;
  Bspace = 5;
  Bheight = 20;
end
Bvgap = Bspace+Bheight;
Bhgap = Bspace+Bwidth;
Slidoff = 30;

FigCol = get(gcf,'color');
load ibm.dat

PushStr = str2mat('LIN','BP','LM');

HeadUI(1) = uicontrol('style','text','string','Network','position',...
                        [Right-Bhgap Top-Bvgap Bwidth Bheight],...
                        'backgroundcolor',FigCol,'foregroundcolor','black'); 
for i = 1:3
   MethodUI(i) = uicontrol('style','radio','value',0,'max',12,...
     'position',...
     [Right-Bhgap Top-(i+1)*Bvgap Bwidth Bheight],...
     'userdata','network','string',PushStr(i,:),...
     'callback',[...
     'nuis = sort(findobj(gcf,''userdata'',''network''));'...
     'cuis = sort(findobj(gcf,''userdata'',''coeff''));'...
     'set(nuis,''value'',0),'...
     'set(gco,''value'',12),'...
     'if gco == nuis(1),'...
       'set(cuis(5:6),''enable'',''off''),'...
     'else,'...
       'set(cuis([1:2,5:6]),''enable'',''on''),'...
     'end,'...
     ]);
end

OutputUI(1) = uicontrol('style','text','string','Output','position',...
                        [Right-Bhgap Top-5*Bvgap Bwidth Bheight],...
                        'backgroundcolor',FigCol,'foregroundcolor','black'); 
OutputUI(2) = uicontrol('style','check','string','Close','value',1,...
                        'callback','set(gco,''value'',1)',...
                        'position',[Right-Bhgap Top-6*Bvgap Bwidth Bheight]);
datastr = str2mat('Date','High','Low','Close','Volume','Cls*Vol');
InputUI(1) = uicontrol('style','text','string','Input','position',...
                        [Right-Bhgap Top-7*Bvgap Bwidth Bheight],...
                        'backgroundcolor',FigCol,'foregroundcolor','black'); 
for i = 2:7
   InputUI(i) = uicontrol('style','check','value',0,...
                         'tag','off',...
                         'position',...
                         [Right-Bhgap Top-(i+6)*Bvgap Bwidth Bheight],...
                         'userdata',i,'string',datastr(i-1,:),'callback',[...
                         'stat = get(gco,''tag'');'...
                         'if stat(1:2) == ''on'','...
                          'set(gco,''tag'',''off''),'...
                          'set(gco,''value'',0),'...
                         'elseif stat(1:2) == ''of'','...
                          'set(gco,''tag'',''on''),'...
                          'set(gco,''value'',1),'...
                         'end,'...
                         'inon = findobj(gcf,''tag'',''on'');'...
                         'del(1) = findobj(gcf,''tag'',''det'');'...
                         'del(2) = findobj(gcf,''tag'',''deb'');'...
                         'if length(inon) == 1,'...
                            'set(del,''enable'',''on''),'...
                         'else,'...
                            'set(del,''enable'',''off''),'...
                         'end,'...
                         ]);
end
set(InputUI(5),'value',1,'tag','on')
set(MethodUI(1),'value',12)
indata = diff(ibm(:,4));
nnetlin([indata indata],100,5);
a = findobj(gcf,'type','axes');
set(a(2),'position',[.1 .6 .65 .35])
set(a(1),'position',[.1 .1 .65 .35])

coeffstr = str2mat('Points','100','Delay','5','Neurons','15');
coefftag = str2mat('ptt','ptb','det','deb','net','neb');
CoeffUI = zeros(1,6);
for k = 1:3
  CoeffUI(k*2-1) = uicontrol('style','text','string',coeffstr(k*2-1,:),...
                       'userdata','coeff',...
                       'tag',coefftag(k*2-1,:),...
                       'position',...
                       [Right-Bhgap Top-(12+k*2)*Bvgap Bwidth Bheight],...
                       'backgroundcolor',FigCol,'foregroundcolor','black');
  CoeffUI(k*2) = uicontrol('style','edit','string',coeffstr(k*2,:),...
                           'userdata','coeff',...
                           'tag',coefftag(k*2,:),...
                           'position',...
                           [Right-Bhgap Top-(13+k*2)*Bvgap Bwidth Bheight]);
end
set(CoeffUI(5:6),'enable','off')

otherstr = str2mat('Zoom','Run','Help');
for i = 1:3
  OtherUI(i) = uicontrol('string',otherstr(i,:),...
                         'position',...
                         [Right-Bhgap Top-(i+20)*Bvgap Bwidth Bheight]);
end

set(OtherUI(1),'style','checkbox','callback',[...
          'if get(gco,''value'') == 0,'...
            'zoom off,'...
            'set(gcf,''pointer'',''arrow''),'...
          'else,'...
            'zoom on,'... 
            'set(gcf,''pointer'',''circle''),'...
          'end,'...
          ]);
set(OtherUI(2),'callback',[...
       'load ibm.dat,'...
       'iuis = findobj(gcf,''tag'',''on'');'...
       'if isempty(iuis),'...
          'errordlg(''Please specify at least one Input.'');',...
          'return,'...
       'end,'...
       'lin = length(iuis);'...
       'index = [];,'...
       'for i = 1:lin,'...
         'index(i) = get(iuis(i),''userdata'')-1;'...
       'end,'...
       '[row,col] = size(ibm);'...
       'indat = [diff(ibm(:,4)) diff(ibm(:,index))];'...  
       'netbutt = findobj(gcf,''value'',12);'...
       'netfun = [''nnet'',lower(get(netbutt,''string''))];'...
       'pnts = get(findobj(gcf,''tag'',''ptb''),''string'');'...
       'if str2double(pnts) < 3,'...
        'pnts = ''3'';'...
       'end,'...
       'delay = get(findobj(gcf,''tag'',''deb''),''string'');'...
       'if str2double(delay) >= str2double(pnts)-1 | str2double(delay) < 1,'...
         'delay = num2str(str2double(pnts)-2);'...
       'end,'...
       'if str2double(delay) > 200,'...
         'delay = ''200'';'...
       'end,'...
       'set(findobj(gcf,''tag'',''ptb''),''string'',pnts),'...
       'set(findobj(gcf,''tag'',''deb''),''string'',delay),'...
       'neuron = get(findobj(gcf,''tag'',''neb''),''string'');'...
       'netcom = [netfun,''(indat,'',pnts,'','',delay,'','',neuron,'');''];'...
       'eval(netcom);'...
       'a = findobj(gcf,''type'',''axes'');'...
       'a = sort(a);'...
       'set(a(1),''position'',[.1 .6 .65 .35]),'...
       'set(a(2),''position'',[.1 .1 .65 .35]),'...
       ]);

out1 = str2mat(...
' This demonstration uses three training methods in the Neural Network  ',...
' Toolbox to estimate the daily price change difference in closing stock  ',...
' prices.  As default input, it uses 100 closing prices from a data set  ',...
' that contains IBM stock price and volume data for about 450 trading  ',...
' days.  In actual practice, neural networks may use thousands of data points. ',...
'.',...
' The top graph shows actual and estimated results.  The bottom graph  ',...
' shows the estimation error, or the difference between actual and  ',...
' estimated results. ',...
'.');
out2 = str2mat(...
' You can use three different training methods: ',...
'.',...
'    LIN - Builds a network by minimizing error of a linear network (default). ',...
'.',...
'    BP - Trains a feed-forward network with fast backpropagation. ',...
'.',...
'    LM - Trains a feed-forward network using the Levenberg-Marquardt method. ',...
'.',...
'    To use a different method, click on the Network selection then click  ',...
'    the Run button. ');
out3 = str2mat(...
'.',...
' You can change parameters to refine the behavior model: ',...
'.',...
'    Select (click on) one or more Inputs to use in modeling the output.   ',...
'    Inputs consist of trading dates; high, low, and closing prices;  ',...
'    trading volume; and closing price times volume from the IBM stock  ',...
'    data set. ',...
'.',...
'    Edit the number of Points used in the data set.  Specifying points as ',...
'    100 uses the first 100 values to train and test the network. ');
out4 = str2mat(...
'.',...
'    Edit the Delay, or the number of points used to estimate the next  ',...
'    point.  A Delay of 5 uses points 1 through 5 to estimate the 6th  ',...
'    price, points 2 through 6 to estimate the 7th price, and so on.  If  ',...
'    you select more than one Input, the Delay is automatically set to 1. ',...
'.',...
'    Edit the number of Neurons in the hidden layer of the network. ',...
'.',...
'    Click the Run button to see the new results after you change  ',...
'    parameters. ');
out5 = str2mat(...
'.',...
' You can magnify any portion of a chart.  Click Zoom and move the cursor  ',...
' to the desired area.  The cursor changes to a circle.  To zoom in  ',...
' (magnify), click the primary mouse button.  To zoom back out, click the  ',...
' secondary mouse button.  Click Zoom again to turn off the zoom function. ');
helpstr = str2mat(out1,out2,out3,out4,out5); 
set(OtherUI(3),'userdata',helpstr,'callback',[...
               'helpwin(get(gco,''userdata''),''Neural Network Help'');'...
               ])

set([HeadUI(:);MethodUI(:);OutputUI(:);InputUI(:);OtherUI(:);CoeffUI(:)],...
    'units','normal')
set(gcf,'pointer','arrow')