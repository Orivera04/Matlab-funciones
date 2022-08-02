function pltsq(arg)
% This Matlab function shows how you can add additional GUI controls to
% the plt window. Typically this is something you will want to do when
% creating an application based on plt.
%
% Note how the 10 uicontrols are added to the figure
%    (4 popups, 2 buttons, and 6 text labels).
% Note that the uicontrol units are changed to normalized so that they
%    reposition properly when you resize the plt figure window.
% Note the use of the 'AxisPos' argument to make room for the uicontrols
%    added above the plot area.
% Note the use of the 'Options' argument to turn off grid lines (initially)
%    and to remove the y-axs Log selector from the menu box.
% Use the Erasemode popup to explore the effect of the erasemode property on drawing speed.

if nargin SQp = get(gcbo,'User'); % Already initialized. Get handles
else                              % Come here to initialize (no arguments)
  SQp(7:11) = plt(0,[0 0 0 0 0],'AxisPos',[1 1 1 .94],...
    'FigName','pltsq: Square wave speed test','LabelY','',...
    'Xlim',[0 4*pi],'Ylim',[-1.05,1.05],'LabelX','Cycles',...
    'Options','Ticks/-Ylog','TRACEid',['Fund';'+3rd';'+5th';'+7th';'+9th']);
  SQp(1:6) = [uicontrol; uicontrol; uicontrol;
              uicontrol; uicontrol; uicontrol];  % 4 popups and 2 buttons
  set(SQp(1:6),'User',SQp,'CallBack','pltsq(1);',...
      {'Position'},{[222 498 110 18]; [437 498 60 18];
                    [582 498 65 18];  [  4 200  57 20];
                    [  6 355  50 22]; [  6 385 50 22]},'Units','Norm',...
      {'String'},{'normal|background|xor|none'; '25|50|100|200|400|800|1600';
                  '1|2|4|8|16|32|64|128|256|512|1024';       '1|2|4|8|16|32';
                  'Stop';                                            'Start'});
  set(SQp(1:4),'Style','Popup','BackGround',[0 1 1],{'Value'},{1;3;5;1});
  set(SQp(5),'User',1,'CallBack','set(gcbo,''User'',0);');
  % define a text label for each popup
  set([uicontrol; uicontrol; uicontrol; uicontrol],'Style','Text',...
      {'String'},{'EraseMode';'Points/cycle';'Speed';'Cycles'},...
      {'Position'},{[130 495 90 18]; [350 495 85 18];
                    [520 495 60 18]; [6 220 55 20]},'Units','Norm');
end;
Ncyc  = 2^get(SQp(4),'Value')/2;    % Number of cycles
Pts   = 12.5*2^get(SQp(2),'Value'); % Points per cycle
Speed = 2^get(SQp(3),'Value');      % Amplitude step size
x = [0: 1/Pts : Ncyc];              % initialize x axis values
plt('cursor',get(gca,'UserData'),'set','xlim',[0 Ncyc]);
y = zeros(5,length(x));  v = y(1,:);
m=1;  for k=1:5 v=v+sin(2*pi*m*x)/m;  m=m+2; y(k,:)=v; end;
emode = {'normal'; 'background'; 'xor'; 'none'};
set(SQp(7:11),'x',x,'y',x,'EraseMode',emode{get(SQp(1),'Value')});
stop = SQp(5);  m = 0;  set(stop,'User',1);
while ishandle(stop) & get(stop,'User')
  m = m+1;  a = sin(Speed*m/6000);
  for k=1:5 set(SQp(k+6),'y',a*y(k,:)); end; drawnow;
end;
%end function pltsq
