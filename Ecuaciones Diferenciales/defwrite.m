function defwrite(action, solnum)

%defwrite   This is an interactive program designed to simplify
%the process of writing odefiles for use by the various solvers.
%To use,merely call defwrite and fill in the blanks. The minimum
%for a successful file is to fill in the file name, and the x'=
%box. Other options are available: up to three equations, optional
%parameters and their specifications (a value need not be entered
%for a given parameter), a default time span, and default initial
%conditions. For further information, consult the documentation,
%or type help odefile. Once the proceed button has been pressed,
%a menu titled "draw" appears. If default initial conditions and a
%default time span have been specified, one of the solvers may be
%selected from this menu, and a plot is produced.
%
%For example, consider the equation
%
%                               x''+2x'+ax=sin(t).
%
%To use this with a solver, first isolate the highest derivative.
%
%                               x''=-2x-ax+sin(t)
%
%Then introduce a new variable, y to reduce the system to first order.
%
%                               x'=y
%                               y'=-2y-ax+sin(t)
%
%It is now ready to become an odefile. Simply type defwrite. Click on
%the box marked "Output file name:" Type the name "oscilate" Then tab 
%over to the equation boxes. Fill in x'=y, y'=-2*y-a*x+sin(t) Then, 
%since a is a parameter, fill in one of the parameter boxes. To specify
%a default value tab over to the next box and fill in 1.3. To specify
%a time span, tab over to the time span boxes and fill in t0=0, tf=4*pi.
%To specify initial conditions, tab over to the initial condition boxes
%and fill in x0=-2, y0=1. Once all of this is done, click on the proceed
%button. Now go to the MATLAB prompt and enter "type oscilate" The
%output should look like:
%
%   function [out1, out2, out3]=myfile(t,Y,flag,a)
%
%   %This ODE file was created by defwrite.m
%
%   if nargin < 4 | isempty(a)
%
%      a = 1.300000e+000;
%
%   end
%
%   if nargin < 3 | isempty(flag)
%
%      out1=[Y(2);-2.*Y(2)-a.*Y(1)+sin(t)];
%
%   elseif strcmp(flag, 'init')
%
%      out1=[  0.00000000 ; 12.56637061 ];
%      out2=[  1.00000000 -2.00000000]';
%      out3=[];
%
%   end
%
%This may then be run by selecting a solver from the pulldown menu.
%
%Alternately, you can use a solver from MATLAB's odesuite.
%For example, enter [t,Y]=ode45('oscilate') at the MATLAB prompt.
%The ouput t will have the time vector, Y(:,1) will be the x values,
%and Y(:,2) will be the y values. To view the output, try the following
%commands:
%
%                         plot(t,Y(:,1))
%                         plot(t,Y(:,2))
%                         plot(Y(:,1),Y(:,2))
%
%Or, even better, try
%
%                         figure, comet3(t,Y(:,1),Y(:,2))
%
%defwrite written by Jonathan duSaint, 1997
global Hf Hmen Fname Htfn Hteq1 Hteq2 Hteq3 Hbqt Hopt1 Hopt2 
global Hopt3 Hopt4 Ht0 Htf Hicx Hicy Hicz Hopt1e Hopt2e Hopt3e Hopt4e

if nargin==0
   Hf=figure('NumberTitle','off',...
      'MenuBar','None',...
      'Name','DEQ File Writer',...
      'Color',[.8 .8 .8],...
      'Position',[130 200 495 270],...
      'Resize','off',...
      'DefaultUIControlFontUnits','Normalized');
   sc=get(0,'ScreenSize');
   tadj=600/sc(4);
   Hmen=uimenu(gcf,'Label','Draw',...
      'Visible','Off');
   Hmen1=uimenu(Hmen,'Label','ODE23',...
      'Callback','defwrite(''solvenow'',1)');
   Hmen2=uimenu(Hmen,'Label','ODE45',...
      'Callback','defwrite(''solvenow'',2)');
   Hmen3=uimenu(Hmen,'Label','ODE113',...
      'Callback','defwrite(''solvenow'',3)');
   Hmen4=uimenu(Hmen,'Label','ODE15S',...
      'Callback','defwrite(''solvenow'',4)');
   Hmen5=uimenu(Hmen,'Label','ODE23S',...
      'Callback','defwrite(''solvenow'',5)');
   Hf1=uicontrol('Style','Frame',...
      'BackgroundColor',[.8 .8 .8],...
      'Position',[5 230 240 30]);
   Hf2=uicontrol('Style','Frame',...
      'BackgroundColor',[.8 .8 .8],...
      'Position',[250 140 240 120]);
   Hf3=uicontrol('Style','Frame',...
      'BackgroundColor',[.8 .8 .8],...
      'Position',[5 140 240 85]);
   Hf4=uicontrol('Style','Frame',...
      'BackgroundColor',[.8 .8 .8],...
      'Position',[125 5 180 130]);
   Hf5=uicontrol('Style','Frame',...
      'BackgroundColor',[.8 .8 .8],...
      'Position',[310 5 180 130]);
   Ht1=uicontrol('Style','Text',...
      'BackgroundColor',[.8 .8 .8],...
      'Position',[10 235 100 20],...
      'String','Output File Name:');
   Ht2=uicontrol('Style','Text',...
      'BackgroundColor',[.8 .8 .8],...
      'Position',[255 235 230 18],...
      'String','Enter Equations As Functions of x, y, and z');
   Ht3=uicontrol('Style','Text',...
      'BackgroundColor',[.8 .8 .8],...
      'Position',[265 205 30 20],...
      'String','x'' = ');
   Ht4=uicontrol('Style','Text',...
      'BackgroundColor',[.8 .8 .8],...
      'Position',[265 175 30 20],...
      'String','y'' = ');
   Ht5=uicontrol('Style','Text',...
      'BackgroundColor',[.8 .8 .8],...
      'Position',[265 145 30 20],...
      'String','z'' = ');
   Htfn=uicontrol('Style','Edit',...
      'BackgroundColor',[.9 .9 .9],...
      'Position',[110 235 130 20],...
      'HorizontalAlignment','Left');
   Hteq1=uicontrol('Style','Edit',...
      'BackgroundColor',[.9 .9 .9],...
      'Position',[295 210 190 20],...
      'HorizontalAlignment','Left');
   Hteq2=uicontrol('Style','Edit',...
      'BackgroundColor',[.9 .9 .9],...
      'Position',[295 180 190 20],...
      'HorizontalAlignment','Left');
   Hteq3=uicontrol('Style','Edit',...
      'BackgroundColor',[.9 .9 .9],...
      'Position',[295 150 190 20],...
      'HorizontalAlignment','Left');
   Htopt=uicontrol('Style','Text',...
      'Position',[10 205 230 15],...
      'BackgroundColor',[.8 .8 .8],...
      'String','Enter Parameters if Applicable');
   Hopt1=uicontrol('Style','Edit',...
      'Position',[10 180 60 20],...
      'HorizontalAlignment','Left',...
      'BackgroundColor',[.9 .9 .9]);
   Hopteq1=uicontrol('Style','Text',...
      'Position',[72 183 6 15],...
      'BackgroundColor',[.8 .8 .8],...
      'String','=');
   Hopt1e=uicontrol('Style','Edit',...
      'Position',[80 180 40 20],...
      'HorizontalAlignment','Left',...
      'BackgroundColor',[.9 .9 .9]);
   Hopt2=uicontrol('Style','Edit',...
      'Position',[130 180 60 20],...
      'HorizontalAlignment','Left',...
      'BackgroundColor',[.9 .9 .9]);
   Hopteq2=uicontrol('Style','Text',...
      'Position',[192 183 6 15],...
      'BackgroundColor',[.8 .8 .8],...
      'String','=');
   Hopt2e=uicontrol('Style','Edit',...
      'Position',[200 180 40 20],...
      'HorizontalAlignment','Left',...
      'BackgroundColor',[.9 .9 .9]);
   Hopt3=uicontrol('Style','Edit',...
      'Position',[10 150 60 20],...
      'HorizontalAlignment','Left',...
      'BackgroundColor',[.9 .9 .9]);
   Hopteq3=uicontrol('Style','Text',...
      'Position',[72 153 6 15],...
      'BackgroundColor',[.8 .8 .8],...
      'String','=');
   Hopt3e=uicontrol('Style','Edit',...
      'Position',[80 150 40 20],...
      'HorizontalAlignment','Left',...
      'BackgroundColor',[.9 .9 .9]);
   Hopt4=uicontrol('Style','Edit',...
      'Position',[130 150 60 20],...
      'HorizontalAlignment','Left',...
      'BackgroundColor',[.9 .9 .9]);
   Hopteq4=uicontrol('Style','Text',...
      'Position',[192 153 6 15],...
      'BackgroundColor',[.8 .8 .8],...
      'String','=');
   Hopt4e=uicontrol('Style','Edit',...
      'Position',[200 150 40 20],...
      'HorizontalAlignment','Left',...
      'BackgroundColor',[.9 .9 .9]);
   Httsp=uicontrol('Style','Text',...
      'Position',[135 100 160 20],...
      'BackgroundColor',[.8 .8 .8],...
      'String','Enter Time Span (Optional)');
   Htt0=uicontrol('Style','Text',...
      'Position',[145 65 38 20],...
      'HorizontalAlignment','Right',...
      'BackgroundColor',[.8 .8 .8],...
      'String','t0 =');
   Httf=uicontrol('Style','Text',...
      'Position',[145 25 38 20],...
      'HorizontalAlignment','Right',...
      'BackgroundColor',[.8 .8 .8],...
      'String','tf =');
   Ht0=uicontrol('Style','Edit',...
      'Position',[185 68 100 20],...
      'HorizontalAlignment','Left',...
      'BackgroundColor',[.9 .9 .9]);
   Htf=uicontrol('Style','Edit',...
      'Position',[185 28 100 20],...
      'HorizontalAlignment','Left',...
      'BackgroundColor',[.9 .9 .9]);
   Htic=uicontrol('Style','Text',...
      'Position',[320 100 160 20],...
      'BackgroundColor',[.8 .8 .8],...
      'String','Enter Initial Conditions (Optional)');
   Hticx=uicontrol('Style','Text',...
      'Position',[330 75 38 17],...
      'BackgroundColor',[.8 .8 .8],...
      'HorizontalAlignment','Right',...
      'String','x0 =');
   Hticy=uicontrol('Style','Text',...
      'Position',[330 45 38 17],...
      'BackgroundColor',[.8 .8 .8],...
      'HorizontalAlignment','Right',...
      'String','y0 =');
   Hticz=uicontrol('Style','Text',...
      'Position',[330 15 38 17],...
      'BackgroundColor',[.8 .8 .8],...
      'HorizontalAlignment','Right',...
      'String','z0 =');
   Hicx=uicontrol('Style','Edit',...
      'Position',[370 75 100 20],...
      'HorizontalAlignment','Left',...
      'BackgroundColor',[.9 .9 .9]);
   Hicy=uicontrol('Style','Edit',...
      'Position',[370 45 100 20],...
      'HorizontalAlignment','Left',...
      'BackgroundColor',[.9 .9 .9]);
   Hicz=uicontrol('Style','Edit',...
      'Position',[370 15 100 20],...
      'HorizontalAlignment','Left',...
      'BackgroundColor',[.9 .9 .9]);
   Hbqt=uicontrol('Style','Push',...
      'Position',[5 5 115 40],...
      'String','Cancel',...
      'Callback','close(gcf)');
   Hbrst=uicontrol('Style','Push',...
      'Position',[5 50 115 40],...
      'String','Reset Values',...
      'Callback','defwrite resetvals');
   Hbpr=uicontrol('Style','Push',...
      'Position',[5 95 115 40],...
      'String','Proceed',...
      'Callback','defwrite proceed');
elseif strcmp(action, 'solvenow')
   figure
   clear functions
   switch solnum
   case 1
      ode23(get(Htfn,'String'))
   case 2
      ode45(get(Htfn,'String'))
   case 3
      ode113(get(Htfn,'String'))
   case 4
      ode15s(get(Htfn,'String'))
   case 5
      ode23s(get(Htfn,'String'))
   end
elseif strcmp(action, 'resetvals')
   close(gcf)
   defwrite
elseif strcmp(action, 'proceed')
   warning off
   Fname=get(Htfn,'String');
   if isempty(findstr(Fname,'.m'))
      Fname=[Fname '.m'];
   end
   opts={};
   if ~isempty(get(Hopt1,'String'))
      opts=[opts,{get(Hopt1,'String')}];
   end
   if ~isempty(get(Hopt2,'String'))
      opts=[opts,{get(Hopt2,'String')}];
   end
   if ~isempty(get(Hopt3,'String'))
      opts=[opts,{get(Hopt3,'String')}];
   end
   if ~isempty(get(Hopt4,'String'))
      opts=[opts,{get(Hopt4,'String')}];
   end
   opteq=[];
   if ~isempty(get(Hopt1e,'String'))
      opteq=[opteq, str2num(get(Hopt1e,'String'))];
   end
   if ~isempty(get(Hopt2e,'String'))
      opteq=[opteq, str2num(get(Hopt2e,'String'))];
   end
   if ~isempty(get(Hopt3e,'String'))
      opteq=[opteq, str2num(get(Hopt3e,'String'))];
   end
   if ~isempty(get(Hopt4e,'String'))
      opteq=[opteq, str2num(get(Hopt4e,'String'))];
   end
   Eq1=eqify(vec(get(Hteq1,'String')));
   Eq2=eqify(vec(get(Hteq2,'String')));
   Eq3=eqify(vec(get(Hteq3,'String')));
   if ~isempty(get(Ht0,'String'))
      tspan=[str2num(get(Ht0,'String'))...
            str2num(get(Htf,'String'))];
   else
      tspan=[];
   end
   if ~isempty(Hicx)
      ic=[str2num(get(Hicx,'String'))...
            str2num(get(Hicy,'String'))...
            str2num(get(Hicz,'String'))];
   end
   writeF(Fname,Eq1,Eq2,Eq3,opts,tspan,ic,opteq)
   set(Hbqt,'String','Done')
   set(Hmen,'Visible','On')
   warning on
end

%-------------------------------------------------------

function F = vec(F)
%VEC Vectorize a symbolic expression.

warning off
l = length(F);
for k = fliplr(find((F=='^') | (F=='*') | (F=='/')))
   F = [F(1:k-1) '.' F(k:l)];
   l = l+1;
end
F(findstr(F,'..')) = [];
warning on

%-----------------------------------------------------------

function F=eqify(F)

warning off
l=length(F);
for k=fliplr(find(F=='x'))
   if k-1==0 | F(k-1)~='e'
      F=[F(1:k-1) 'Y(1)' F(k+1:l)];
      l=l+3;
   end
end
for k=fliplr(find(F=='y'))
   F=[F(1:k-1) 'Y(2)' F(k+1:l)];
   l=l+3;
end
for k=fliplr(find(F=='z'))
   F=[F(1:k-1) 'Y(3)' F(k+1:l)];
   l=l+3;
end
warning on

%-------------------------------------------------------------

function writeF(Fname,Eq1,Eq2,Eq3,opts,tspan,ic,opteq)

warning off
if exist(Fname)==2
   response=questdlg('what do you want to do?',...
   'That file already exists','Overwrite','Cancel','Cancel');
   switch response
   case 'Cancel'
      return
   case 'Overwrite'
      delete(Fname)
   end
end
if ~isempty(Eq2)
   Eq2=[';' Eq2];
end
if ~isempty(Eq3)
   Eq3=[';' Eq3];
end
Fid=fopen(Fname,'w');
fprintf(Fid,['function [out1, out2, out3]='...
      Fname(1:length(Fname)-2) '(t,Y,flag']);
for k=opts
   fprintf(Fid,[',' k{1}]);
end
fprintf(Fid,[')\n\n']);
fprintf(Fid,['%%This ODE file was created by defwrite.m\n\n']);
mn=1;
for k=opteq
   fprintf(Fid,'if nargin < %d | isempty(%s)\n\n',...
      mn+3,opts{mn});
   fprintf(Fid,'   %s = %d;\n\n',opts{mn},opteq(mn));
   fprintf(Fid,'end\n\n');
   mn=mn+1;
end
if ~isempty(tspan) | ~isempty(ic)
   fprintf(Fid,'if nargin < 3 | isempty(flag)\n\n   ');
end
fprintf(Fid,['out1=[' Eq1 Eq2 Eq3 '];\n\n']);
if ~isempty(tspan) | ~isempty(ic)
   fprintf(Fid,...
 'elseif strcmp(flag, ''init'')\n\n   out1=[%12.8f ;%12.8f ];\n',...
      tspan(1),tspan(2));
   fprintf(Fid,'   out2=[');
   for k=ic
      fprintf(Fid,'%12.8f',k);
   end
   fprintf(Fid,']'';\n   out3=[];\n\nend\n');
end
fclose(Fid);
warning on


