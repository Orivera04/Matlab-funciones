%PLOTCS is an interactive tool designed to simplify 3d plotting 
%in cylindrical and spherical coordinates.
%                                1996, Jonathan duSaint

function plotcs(choice1)

global Hf Ht1 Hb Ht2 H_clrmp A x y z r rho phi theta H_srf H_prnt rt H_opt1 ...
   Xmin Xmax Ymin Ymax Thetamin Thetamax Zmin Zmax Phimin Phimax Xincr Yincr ...
   Zdiv Thetadiv Phidiv Huda Haxlim1 Haxlim2 Haxlim3 Haxlim4 Haxlim5 Haxlim6 ...
   Hf3cl H_f3cla H_f3clb Ndft H_cntra H_cntrb

if nargin == 0
     % First we make sure that there is no other copy of PLOTCS
  % running, since this causes problems.	
  pph = findobj('tag','PLOTCS');
  if ~isempty(pph);
    qstring = {'There are some PLOTCS figures open although they may be invisible.  ';...
    'What do you want to do?'};
    tstring = 'Only one copy of PLOTCS can be open at one time.';
    b1str = 'Close all such figures and restart PLOTCS.';
    b2str = 'Just close all of those figures.';
    b3str = 'Do nothing.';
    answer = questdlg(qstring,tstring,b1str,b2str,b3str,b1str);
    if strcmp(answer,b1str)
      delete(pph);
      plotcs;return
    elseif strcmp(answer,b2str)
      delete(pph);return
    else
      return
    end 
  end  % if ~isempty(pph);
   Xmin=-2;
   Xmax=2;
   Ymin=Xmin;
   Ymax=Xmax;
   Zmin=-5;
   Zmax=5;
   Thetamin=0;
   Thetamax=2*pi;
   Phimin=0;
   Phimax=pi;
   Xincr=.1;
   Yincr=Xincr;
   Thetadiv=40;
   Zdiv=80;
   Phidiv=Thetadiv;
   Ndft=20;
   Hf3cl='yellow';
   warning off
   Hf = figure('Numbertitle','off',...
      'Name','Cylindrical or Spherical Plotting',...
      'Units','Normalized',...
      'Resize','off','Tag','PLOTCS'); 
   colordef(Hf,'white') %Make sure "white" is the default color
   %First we need a custom menubar
   set(Hf,'Menubar','None');
   Hm1 = uimenu(gcf,'Label','&Type');
   Hm1aa = uimenu(Hm1,'Label','&Rectangular',...
      'Callback','plotcs Rectangular');
   Hm1a = uimenu(Hm1,'Label','&Cylindrical',...
                 'Callback','plotcs Cylindrical');
   Hm1b = uimenu(Hm1,'Label','&Spherical',...
                 'Callback','plotcs Spherical');
   H_opt = uimenu(gcf,'Label','&Options');
   H_opt1 = uimenu(H_opt,'Label','&Rotate',...
      'Callback','plotcs rot');
   H_opt3 = uimenu(H_opt,'Label','&Background',...
                   'Callback','whitebg');
   H_opt4 = uimenu(H_opt,'Label','&Grid');
   H_opt4a = uimenu(H_opt4,'Label','O&n',...
                    'Callback','grid on');
   H_opt4b = uimenu(H_opt4,'Label','O&ff',...
                    'Callback','grid off');
   H_opt5 = uimenu(H_opt,'Label','H&idden');
   H_opt5a = uimenu(H_opt5,'Label','O&n',...
                    'Callback','hidden on');
   H_opt5b = uimenu(H_opt5,'Label','O&ff',...
      'Callback','hidden off');
   H_opt6 = uimenu(H_opt,'Label','H&old');
   H_opt6a = uimenu(H_opt6,'Label','O&n',...
      'Callback','hold on');
   H_opt6b = uimenu(H_opt6,'Label','O&ff',...
      'Callback','hold off');
   H_opt7 = uimenu(H_opt,'Label','Axi&s');
   H_opt7a = uimenu(H_opt7,'Label','&Equal',...
      'Callback','axis equal');
   H_opt7b = uimenu(H_opt7,'Label','&Image',...
      'Callback','axis image');
   H_opt7c = uimenu(H_opt7,'Label','&Normal',...
      'Callback','axis normal');
   H_opt7d = uimenu(H_opt7,'Label','&Square',...
      'Callback','axis square');
   H_opt7e = uimenu(H_opt7,'Label','&Default',...
      'Callback','plotcs defaultaxes');
   H_opt7f = uimenu(H_opt7,'Label','&User Defined',...
      'Callback','plotcs useraxis');
   Hhlp = uimenu(gcf,'Label','&Help');
   Hhlp1 = uimenu(Hhlp,'Label','&About...',...
      'Callback','ht=help(''plotcs''); helpdlg(ht,''PLOTCS Help'');');
   Hhlp2 = uimenu(Hhlp,'Label','&Function Types...',...
      'Callback','plotcs helpfxn');
   Hhlp3 = uimenu(Hhlp,'Label','&Options Menu...',...
      'Callback','plotcs helpopt');
   Hhlp4 = uimenu(Hhlp,'Label','&Plot Type/Color...',...
      'Callback','plotcs helpptyp');
   Hhlp5 = uimenu(Hhlp,'Label','&The Author...',...
      'Callback','plotcs helpauthor');
   Ht1 = uicontrol(gcf,'Style','edit',...
                   'Position',[10 10 240 20],...
                   'Callback','plotcs (''FXNEval'');');
   Ht2 = uicontrol(gcf,'Style','text',...
      'Position',[10 40 100 20]);
   %Now we need some buttons
   Hb = uicontrol(gcf,'Style','push',...
                  'Position',[10 290 40 30],...
                  'String','Draw',...
                  'Enable','off',...
                  'Callback','plotcs DrawNow');
   H_srf = uicontrol(Hf,'Style','popupmenu',...
                     'Position',[260 10 150 20],...
                     'String','surfl|mesh|meshc|meshz|surf|surfc|contour3|contour|fill3|pcolor|waterfall',...
                     'Value',1,...
                     'Callback','plotcs DrawNow');
   H_clrmp = uicontrol(gcf,'Style','popupmenu',...
                       'Position',[420 10 150 20],...
                       'String','Copper|Hsv|Hot|Cool|Pink|Gray|Bone|Jet|Prism|Flag|Autumn|Colorcube|Lines|Spring|Summer|Winter',...
                       'Value',1,...
                       'Userdata',[copper hsv hot cool pink gray bone jet prism flag autumn colorcube lines spring summer winter],...
                       'Callback','plotcs ColormapSelect');
   H_prnt = uicontrol(gcf,'Style','push',...
                      'Position',[10 330 40 30],...
                      'String','Print',...
                      'Callback','print -noui',...
                      'Enable','off');
   H_quit = uicontrol(gcf,'Style','push',...
      'Position',[10 250 40 30],...
      'String','Quit',...
      'Callback','close(gcf)');
   H_f3cla = uicontrol(gcf,'Style','Text',...
      'Position',[420 35 30 18],'String','Color:',...
      'Visible','off');
   H_f3clb = uicontrol(gcf,'Style','PopUpMenu',...
      'Position',[460 35 100 18],...
      'String','yellow | magenta | cyan | red | green | blue | white | black',...
      'UserData',['y' 'm' 'c' 'r' 'g' 'b' 'w' 'k'],...
      'Value',1,'Visible','off','Callback','plotcs DrawNow');
   H_cntra = uicontrol(gcf,'Style','Text',...
      'Position',[460 35 40 18],'String','#Lines:',...
      'Visible','off');
   H_cntrb = uicontrol(gcf,'Style','Edit',...
      'Position',[520 35 40 20],'String',num2str(Ndft),...
      'Visible','off','Callback','plotcs DrawNow');
   rand('state',sum(100*clock));
   dt=ceil(rand(1)*3);
   switch dt
   case 1
      set(Ht1,'String','cos(x)*sin(y)')
      plotcs Rectangular
   case 2
      set(Ht1,'String','cos(theta)+sin(z)')
      plotcs Cylindrical
   otherwise
      set(Ht1,'String','sin(theta)*cos(phi)')
      plotcs Spherical
   end
   plotcs FXNEval
   plotcs DrawNow
elseif strcmp(choice1, 'defaultaxes')
   Xmin=-2;
   Xmax=2;
   Ymin=Xmin;
   Ymax=Xmax;
   Zmin=-5;
   Zmax=5;
   Thetamin=0;
   Thetamax=2*pi;
   Phimin=0;
   Phimax=pi;
   Xincr=.1;
   Yincr=Xincr;
   Thetadiv=40;
   Zdiv=80;
   ptyp=get(Ht2,'String');
   plotcs(ptyp)
   plotcs DrawNow
elseif strcmp(choice1, 'helpopt')
   hlp='In the Options menu, there are six useful ways of manipulating graphs.';
   Hhlpdlg=helpdlg(hlp,'PLOTCS Help');
elseif strcmp(choice1,'helpptyp')
   hlp='For both the plot types and the colormaps, all the standard MATLAB functions are available';
   Hhlpdlg=helpdlg(hlp,'PLOTCS Help');
elseif strcmp(choice1, 'helpauthor')
   hlp='At the moment, the author is a starving student. One day, however, he will rule the world.';
   Hhlpdlg=helpdlg(hlp,'PLOTCS Help');
elseif strcmp(choice1, 'useraxis')
   ptyp=get(Ht2,'String');
   Huda=figure('NumberTitle','off',...
      'Name','User Defined Axes',...
      'Position',[300 300 330 90],...
      'MenuBar','None',...
      'Resize','off');
   txtstrg=['Current Plot Type is ' ptyp];
   Hg1=uicontrol('Style','Text',...
      'Position',[80 75 170 16],...
      'String',txtstrg);
   switch ptyp
   case 'Rectangular'
      bx1tx='Xmin:';
      bx2tx='Xmax:';
      bx3tx='Xincr:';
      bx4tx='Ymin:';
      bx5tx='Ymax:';
      bx6tx='Yincr:';
      bx1str=num2str(Xmin);
      bx2str=num2str(Xmax);
      bx3str=num2str(Xincr);
      bx4str=num2str(Ymin);
      bx5str=num2str(Ymax);
      bx6str=num2str(Yincr);
   case 'Cylindrical'
      bx1tx='Thetamin:';
      bx2tx='Thetamax:';
      bx3tx='#Points:';
      bx4tx='Zmin:';
      bx5tx='Zmax:';
      bx6tx='#Points:';
      bx1str=num2str(Thetamin);
      bx2str=num2str(Thetamax);
      bx3str=num2str(Thetadiv);
      bx4str=num2str(Zmin);
      bx5str=num2str(Zmax);
      bx6str=num2str(Zdiv);
   case 'Spherical'
      bx1tx='Thetamin:';
      bx2tx='Thetamax:';
      bx3tx='#Points:';
      bx4tx='Phimin:';
      bx5tx='Phimax:';
      bx6tx='#Points:';
      bx1str=num2str(Thetamin);
      bx2str=num2str(Thetamax);
      bx3str=num2str(Thetadiv);
      bx4str=num2str(Phimin);
      bx5str=num2str(Phimax);
      bx6str=num2str(Phidiv);
   end
   Hbx1=uicontrol('Style','Text','Position',[1 55 50 15],...
      'String',bx1tx);
   Hbx2=uicontrol('Style','Text','Position',[111 55 50 15],...
      'String',bx2tx);
   Hbx3=uicontrol('Style','Text','Position',[221 55 50 15],...
      'String',bx3tx);
   Hbx4=uicontrol('Style','Text','Position',[1 25 45 15],...
      'String',bx4tx);
   Hbx5=uicontrol('Style','Text','Position',[111 25 45 15],...
      'String',bx5tx);
   Hbx6=uicontrol('Style','Text','Position',[221 25 45 15],...
      'String',bx6tx);
   Hquitb=uicontrol('Style','Push','Position',[1 1 163 20],...
      'String','Don''t Change','Callback','close(gcf)');
   Hrescl=uicontrol('Style','push','Position',[166 1 163 20],...
      'String','Apply','Callback','plotcs changeaxisnow');
   Haxlim1=uicontrol('Style','Edit','Position',[56 55 53 20],...
      'String',bx1str);
   Haxlim2=uicontrol('Style','Edit','Position',[166 55 53 20],...
      'String',bx2str);
   Haxlim3=uicontrol('Style','Edit','Position',[276 55 53 20],...
      'String',bx3str);
   Haxlim4=uicontrol('Style','Edit','Position',[51 25 53 20],...
      'String',bx4str);
   Haxlim5=uicontrol('Style','Edit','Position',[161 25 53 20],...
      'String',bx5str);
   Haxlim6=uicontrol('Style','Edit','Position',[270 25 53 20],...
      'String',bx6str);
elseif strcmp(choice1, 'changeaxisnow')
   num1=str2num(get(Haxlim1,'String'));
   num2=str2num(get(Haxlim2,'String'));
   num3=str2num(get(Haxlim3,'String'));
   num4=str2num(get(Haxlim4,'String'));
   num5=str2num(get(Haxlim5,'String'));
   num6=str2num(get(Haxlim6,'String'));
   ptyp=get(Ht2,'String');
   switch ptyp
   case 'Rectangular'
      Xmin=num1;
      Xmax=num2;
      Xincr=num3;
      Ymin=num4;
      Ymax=num5;
      Yincr=num6;
      plotcs Rectangular
   case 'Cylindrical'
      Thetamin=num1;
      Thetamax=num2;
      Thetadiv=num3;
      Zmin=num4;
      Zmax=num5;
      Zdiv=num6;
      plotcs Cylindrical
   case 'Spherical'
      Thetamin=num1;
      Thetamax=num2;
      Thetadiv=num3;
      Phimin=num4;
      Phimax=num5;
      Phidiv=num6;
      plotcs Spherical
   end
   close(gcf)
   plotcs DrawNow
elseif strcmp(choice1, 'rot')
   rotate3d
   a=get(H_opt1,'Checked');
   if strcmp(a,'off')
      set(H_opt1,'Checked','on')
   else
      set(H_opt1,'Checked','off')
   end
elseif strcmp(choice1, 'helpfxn')
   hlp='There are three function types:  Rectangular: z=f(x,y)  Cylindrical: r=f(theta,z)  Spherical: rho=f(phi,theta)';
   Hhlpdlg=helpdlg(hlp,'PLOTCS Help');
elseif strcmp(choice1, 'Rectangular') %Although the program is for cyl/sph, rec might also be nice
   [x,y]=meshgrid(Xmin:Xincr:Xmax,Ymin:Yincr:Ymax);
   A = -1;
   set(Hb,'Enable','on')
   set(Ht2,'String','Rectangular')
elseif strcmp(choice1, 'Cylindrical')
   set(Ht2,'String','Cylindrical')
   set(Hb,'Enable','on')
   A = 0;
   THETA=linspace(Thetamin,Thetamax,Thetadiv);
   Z=linspace(Zmin,Zmax,Zdiv);
   [theta,z]=meshgrid(THETA,Z);
elseif strcmp(choice1, 'Spherical')
   set(Ht2,'String','Spherical')
   set(Hb,'Enable','on')
   A = 1;
   PHI=linspace(Phimin,Phimax,Phidiv);
   THETA=linspace(Thetamin,Thetamax,Thetadiv);
   [phi,theta]=meshgrid(PHI,THETA);
elseif strcmp(choice1, 'FXNEval')
   switch A
   case 0
      r=leftstrp(get(Ht1,'String'));
      r=vect(r);
      r=eval(r);
      k=find(real(r)~=r);  %This bit of code is to get rid of complex numbers
      r(k)=NaN*ones(size(k));  %The only problem is the "jaggies" that appear around the edges
      x=r.*cos(theta);
      y=r.*sin(theta);
   case 1
      rho=vect(leftstrp(get(Ht1,'String')));
      rho=eval(rho);
      k=find(real(rho)~=rho);
      rho(k)=NaN*ones(size(k));
      x=rho.*sin(phi).*cos(theta);
      y=rho.*sin(phi).*sin(theta);
      z=rho.*cos(phi);
   otherwise
      z=vect(leftstrp(get(Ht1,'String')));
      z=eval(z);
      k=find(real(z)~=z);
      z(k)=NaN*ones(size(k));
   end
elseif strcmp(choice1, 'DrawNow')
   plotcs('FXNEval');
   set(H_prnt,'Enable','on')
   b=get(H_srf,'Value');
   set(H_cntra,'Visible','off')
   set(H_cntrb,'Visible','off')
   set(H_f3cla,'Visible','off')
   set(H_f3clb,'Visible','off')
   switch b
   case 1
      surfl(x,y,z)
      shading interp
   case 2
      mesh(x,y,z)
   case 3
      meshc(x,y,z)
   case 4
      meshz(x,y,z)
   case 5
      surf(x,y,z)
      shading interp
   case 6
      surfc(x,y,z)
      shading interp
   case 7
      set(H_cntra,'Visible','on')
      set(H_cntrb,'Visible','on')
      Ndft=str2num(get(H_cntrb,'String'));
      contour3(x,y,z,Ndft)
   case 8
      set(H_cntra,'Visible','on')
      set(H_cntrb,'Visible','on')
      Ndft=str2num(get(H_cntrb,'String'));
      contour(x,y,z,Ndft)
   case 9
      set(H_f3cla,'Visible','on')
      set(H_f3clb,'Visible','on')
      colst=get(H_f3clb,'UserData');
      Colrg=colst(get(H_f3clb,'Value'));
      fill3(x,y,z,Colrg)
   case 10
      pcolor(x,y,z)
      shading interp
   otherwise
      waterfall(x,y,z)
   end
   xlabel('x-axis');
   ylabel('y-axis');
   zlabel('z-axis');
   titlestr=leftstrp(get(Ht1,'String'));
   switch A
   case -1
      titlestr=['z=' titlestr];
   case 0
      titlestr=['r=' titlestr];
   otherwise
      titlestr=['rho=' titlestr];
   end
   titlestr=grkify(titlestr);
   titlestr=exponify(titlestr);
   title(titlestr);
   val=get(H_clrmp,'Value');
   cval=[val*3-2 val*3-1 val*3];
   Clr=get(H_clrmp,'Userdata');
   Clrg=Clr(:,cval);
   colormap(Clrg)
elseif strcmp(choice1, 'ColormapSelect')
   val=get(H_clrmp,'Value');
   cval=[val*3-2 val*3-1 val*3];
   Clr=get(H_clrmp,'Userdata');
   Clrg=Clr(:,cval);
   colormap(Clrg)
end

%------------------A "borrowed" subprogram----------------------------

function F = vect(F)
%VECT Vectorize a symbolic expression.
%	VECT(F) inserts a '.' before any '^', '*' and '/' in F.

l = length(F);
for k = fliplr(find((F=='^') | (F=='*') | (F=='/')))
   F = [F(1:k-1) '.' F(k:l)];
   l = l+1;
end
F(findstr(F,'..')) = [];

%----------------------------------------------------------------------

function F = leftstrp(F)
%LEFTSTRP Removes the left side of an equation

k=find(F=='=');
l=length(F);
if ~isempty(k)
   F=F(k+1:l);
end

%----------------------------------------------------------------------

function F=grkify(F)
%GRKIFY formats text so that the greek alphabet appears as written

l = length(F);
for k = fliplr(sort([findstr(F,'theta') findstr(F,'rho') findstr(F,'phi')]))
   F = [F(1:k-1) '\' F(k:l)];
   l = l+1;
end

%-----------------------------------------------------------------------

function F=exponify(F)
%EXPONIFY further formats text to appear as written

l=length(F);
for k=fliplr(find(F=='('))
   F = [F(1:k-1) '{' F(k:l)];
   l = l+1;
end
for k=fliplr(find(F==')'))
   F = [F(1:k) '}' F(k+1:l)];
   l = l+1;
end

for k=fliplr(findstr(F,'exp'))
   F=[F(1:k-1) 'e^' F(k+3:l)];
end

