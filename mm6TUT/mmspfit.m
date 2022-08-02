function ppo=mmspfit(x,y)
%MMSPFIT Spline Creation and Manipulation GUI. (MM)
%
% MMSPFIT(X,Y) returns a spline piecewise polynomial based on the data
% in X and Y after manipulation by a GUI.
% MMSPFIT(PP) returns a spline piecewise polynomial based on the spline
% piecewise polynomial PP after manipulation by a GUI.
%
% The spline GUI generates a plot showing the input data and its spline
% interpolation.
% GUI Features:
% Clicking on a data point displays editable data describing the point.
% Clicking an open area in the figure border deselects a chosen point.
%
% See also MMSPHELP

% Calls: mmspget mmputptr mmspchk mmfitpos mmspder

% D.C. Hanselman, University of Maine, Orono, ME 04469
% 10/10/98, 6/2/99, 8/20/99, 6/14/00
% Mastering MATLAB 6, Prentice Hall, ISBN 0-13-019468-9

if nargin==2
   x=x(:); y=y(:);
   pp=spline(x,y);
   arg='initial';
elseif nargin==1 & ~ischar(x)
   pp=x;
   error(mmspchk(pp,'dim',1,'order',4))
   [x,y]=mmspget(pp,'x','y');
   arg='initial';
elseif nargin==1 & ischar(x)
   arg=x;
else
   error('Unknown Input.')
end
switch arg
case 'initial'
   if mmono(x)<0 % make x increasing
      x=x(end:-1,1);
      y=y(end:-1,1);
   end
   if length(x)>60
      warning('It is difficult to use this GUI with so many points.')
   end
   xx=mmsubdiv(x,10);
   yy=mmppval(pp,xx);
   ud.Hl=plot(xx,yy,x,y,':');
   Hf=gcf;
   rgb=get(0,'DefaultUicontrolBackgroundColor');
   Ha=gca;
   set(Ha,'Xlim',[min(x) max(x)])
   tmp=get(Ha,'ColorOrder');
   ud.c1=tmp(1,:);
   ud.c3=tmp(3,:);
   ud.Hlpts=zeros(size(x));
   for i=1:length(x)
      ud.Hlpts(i)=line('Xdata',x(i),'Ydata',y(i),...
         'LineStyle','none','Marker','o',...
         'Color',ud.c1,...
         'UserData',i,...
         'ButtonDownFcn','mmspfit select');
   end
   ud.x=x; % break points
   ud.y=y; % y data at break points
   ud.xx=xx; % interpolated x data
   ud.yy=yy; % original interpolated y data
   tmp=(x==0).*x;
   ud.xl=(1-eps)*x-tmp; % points left of break points
   ud.xr=(1+eps)*x+tmp; % points right of break points
   ud.ldy=mmspder(pp,ud.xl); % slopes at left of breaks
   ud.rdy=mmspder(pp,ud.xr); % slopes at right of breaks
   ud.pp=pp; % current pp form
   ud.ppdef=pp; % default pp form
   ud.ipt=[];
   
   % build gui
   munits='pixels';
   bdr=5; % border amount in munits
   afh=mmgetsiz(gca,munits); % axes font height
   tmp=uicontrol('Style','Text',...
      'Units',munits,...
      'Visible','off',...
      'String','M');
   Me=get(tmp,'Extent'); % extent of default text M
   delete(tmp)
   Mw=Me(3); % width of text M
   Mh=Me(4); % height of text M
   Me=Mh+bdr; % height of edit box containing text M
   fh=4*bdr+2*Me+Mh; % frame height required
   b=[bdr bdr+Me+bdr bdr+Me+bdr+Me+bdr]; % bottoms of elements in frame
   
   fc=fh-afh;
   apos=mmgetpos(Ha,munits);
   apos(2)=apos(2)+fc;
   fpos=mmgetpos(Hf,munits);
   fpos=[fpos(1) fpos(2)-fc fpos(3) fpos(4)+fc];
   fpos=mmfitpos(fpos,0,munits);
   set(Hf,'Units',munits,'Position',fpos,...
      'BackingStore','off')
   set(Ha,'Units',munits,'Position',apos,...
      'DrawMode','fast')
   fw=0.4*(apos(3)-2*bdr); % frame width
   ll=apos(1); % left of left frame
   lr=ll+fw+bdr; % left of right frame
   lb=lr+fw+bdr; % left of button frame
   
   uicontrol('Style','Frame',... % Left Frame
      'Units',munits,...
      'Position',[ll 1 fw fh])
   uicontrol('Style','Text',... % Left Label
      'Units',munits,...
      'Position',[ll+fw/2-2*Mw b(3) 4*Mw Mh],...
      'HorizontalAlignment','center',...
      'String','LEFT');
   uicontrol('Style','Text',... % Left Y' Text
      'Units',munits,...
      'Position',[ll+bdr b(2) 5*Mw Mh],...
      'HorizontalAlignment','center',...
      'String','Slope');
   tmp=ll+bdr+5*Mw+bdr;
   ud.Hledit=uicontrol('Style','Edit',... % Edit of Left Y'
      'Units',munits,...
      'Position',[tmp  b(2) lr-2*bdr-tmp Me],...
      'Callback','mmspfit leftedit');
   ud.Hlbutton=uicontrol('Style','Pushbutton',... % Left Default Y' Pushbutton
      'Units',munits,...
      'Position',[ll+bdr b(1) 5*Mw Mh],...
      'String','Default',...
      'Callback','mmspfit leftdefaultbutton',...
      'Enable','off');
   ud.Hldefval=uicontrol('Style','Text',... % Left Default Y' Value
      'Units',munits,...
      'Position',[tmp b(1) lr-2*bdr-tmp Mh],...
      'String',' ');
   
   uicontrol('Style','Frame',... % Right Frame
      'Units',munits',...
      'Position',[lr 1 fw fh])
   uicontrol('Style','Text',... % Right Label
      'Units',munits,...
      'Position',[lr+fw/2-5*Mw/2 b(3) 5*Mw Mh],...
      'HorizontalAlignment','center',...
      'String','RIGHT');
   uicontrol('Style','Text',... % Right Y' Text
      'Units',munits,...
      'Position',[lr+bdr b(2) 5*Mw Mh],...
      'HorizontalAlignment','center',...
      'String','Slope');
   tmp=lr+bdr+5*Mw+bdr;
   ud.Hredit=uicontrol('Style','Edit',... % Edit of Right Y'
      'Units',munits,...
      'Position',[tmp  b(2) ll+2*fw-tmp Me],...
      'Callback','mmspfit rightedit');
   ud.Hrbutton=uicontrol('Style','Pushbutton',...% Right Default Y' Pushbutton
      'Units',munits,...
      'Position',[lr+bdr b(1) 5*Mw Mh],...
      'String','Default',...
      'Callback','mmspfit rightdefaultbutton',...
      'Enable','off');
   ud.Hrdefval=uicontrol('Style','Text',... % Right Default Y' value
      'Units',munits,...
      'Position',[tmp b(1) ll+2*fw-tmp Mh],...
      'String',' ');
   bht=(fh-4*bdr)/3;
   bwd=fw/2-2*bdr;
   uicontrol('Style','Frame',... % Button Frame
      'Units',munits,...
      'Position',[lb 1 fw/2 fh])
   uicontrol('Style','Pushbutton',... % Apply Button
      'Units',munits,...
      'Position',[lb+bdr 1+3*bdr+2*bht bwd bht],...
      'String','Apply',...
      'Callback','mmspfit applybutton')
   uicontrol('Style','PushButton',... % Revert Button
      'Units',munits,...
      'Position',[lb+bdr 1+2*bdr+bht bwd bht],...
      'String','Revert',...
      'Callback','mmspfit revertbutton')
   uicontrol('Style','PushButton',... % Done Button
      'Units',munits,...
      'Position',[lb+bdr 1+bdr bwd bht],...
      'String','Done',...
      'Callback','mmspfit donebutton')
   
   Hf=gcf;
   set(Hf,'NumberTitle','off',...
      'Name','MMSPFIT',...
      'Color',rgb,...
      'UserData',ud,...
      'KeyPressFcn','mmspfit keypress',...
      'ButtonDownFcn','mmspfit buttondown',...
      'HandleVisibility','Callback')
   mmputptr(Hf)
   uiwait(Hf)
   ud=get(Hf,'UserData');
   ppo=ud.pp;
   close(Hf)
   
case 'applybutton'
   % no operations required
   % simply puching the button forces the edit callback to act
case 'donebutton'
   uiresume(gcbf);
   
case 'revertbutton'
   Hf=gcbf;
   ud=get(Hf,'UserData');
   set(ud.Hl(1),'ydata',ud.yy)
   set(ud.Hlpts,'Marker','o','Color',ud.c1)
   set(ud.Hldefval,'Visible','off')
   set(ud.Hlbutton,'Enable','off')
   set(ud.Hledit,'String',' ','Enable','off')
   set(ud.Hrdefval,'Visible','off')
   set(ud.Hrbutton,'Enable','off')
   set(ud.Hredit,'String',' ','Enable','off')
   ud.pp=ud.ppdef;
   ud.ipt=[];
   set(Hf,'UserData',ud)
   
case 'buttondown'
   Hf=gcbf;
   ud=get(Hf,'UserData');
   set(ud.Hlpts,'Marker','o','Color',ud.c1)
   set(ud.Hldefval,'Visible','off')
   set(ud.Hlbutton,'Enable','off')
   set(ud.Hledit,'String',' ','Enable','off')
   set(ud.Hrdefval,'Visible','off')
   set(ud.Hrbutton,'Enable','off')
   set(ud.Hredit,'String',' ','Enable','off')
   ud.ipt=[];
   set(Hf,'UserData',ud)
   
case 'select'
   
   [Hp,Hf]=gcbo; % handle of point selected and figure
   ud=get(Hf,'UserData');
   Hps=findobj(ud.Hlpts,'Marker','square');
   set(Hps,'Marker','o','Color',ud.c1)
   set(Hp,'Marker','square','Color',ud.c3)
   i=get(Hp,'UserData');
   if i~=1 % left spline exists
      str=sprintf('%.5g',(mmspder(ud.pp,ud.xl(i))));
      set(ud.Hldefval,'Visible','on',...
         'String',sprintf('%.5g',(ud.ldy(i))))
      set(ud.Hlbutton,'Enable','on')
      set(ud.Hledit,'Enable','on',...
         'String',str,...
         'UserData',str)
   else
      set(ud.Hldefval,'Visible','off')
      set(ud.Hlbutton,'Enable','off')
      set(ud.Hledit,'Enable','off','String','N. A.')
   end
   
   if i~=length(ud.x) % right spline exists
      str=sprintf('%.5g',(mmspder(ud.pp,ud.xr(i))));
      set(ud.Hrdefval,'Visible','on',...
         'String',sprintf('%.5g',(ud.rdy(i))))
      set(ud.Hrbutton,'Enable','on')
      set(ud.Hredit,'Enable','on',...
         'String',str,...
         'UserData',str)
   else
      set(ud.Hrdefval,'Visible','off')
      set(ud.Hrbutton,'Enable','off')
      set(ud.Hredit,'Enable','off','String','N. A.')
   end
   ud.ipt=i;
   set(Hf,'UserData',ud)
   
case 'leftdefaultbutton'
   
   Hf=gcbf; % handle of figure
   ud=get(Hf,'UserData'); % grab data
   str=sprintf('%.5g',ud.ldy(ud.ipt));
   set(ud.Hledit,'String',str,'UserData',str) % poke in default
   mmspfit 'leftedit' % update the pp and plot
   
case 'rightdefaultbutton'
   
   Hf=gcbf; % handle of figure
   ud=get(Hf,'UserData'); % grab data
   str=sprintf('%.5g',ud.rdy(ud.ipt));
   set(ud.Hredit,'String',str,'UserData',str) % poke in default
   mmspfit 'rightedit' % update the pp and plot
   
case 'leftedit'
   Hf=gcbf; % handle of figure
   ud=get(Hf,'UserData'); % grab data
   str=get(ud.Hledit,'String');
   yp=eval(str,'NaN');
   if isnan(yp) % can't decipher user input, restore previous
      str=get(ud.Hledit,'UserData');
      set(ud.Hledit,'String',str)
   else % apply user input
      set(ud.Hledit,'UserData',str)
      idx=[ud.ipt-1 ud.ipt];
      yp=[ud.rdy(ud.ipt-1) yp];
      [br,co]=unmkpp(ud.pp);
      co(idx(1),:)=chic(ud.x(idx),ud.y(idx),yp);
      ud.pp=mkpp(br,co);
      set(ud.Hl(1),'ydata',mmppval(ud.pp,ud.xx))
      set(Hf,'UserData',ud)
   end
case 'rightedit'
   Hf=gcbf; % handle of figure
   ud=get(Hf,'UserData'); % grab data
   str=get(ud.Hredit,'String');
   yp=eval(str,'NaN');
   if isnan(yp) % can't decipher user input, restore previous
      str=get(ud.Hredit,'UserData');
      set(ud.Hredit,'String',str)
   else % apply user input
      set(ud.Hredit,'UserData',str)
      idx=[ud.ipt ud.ipt+1];
      yp=[yp ud.ldy(ud.ipt+1)];
      [br,co]=unmkpp(ud.pp);
      co(idx(1),:)=chic(ud.x(idx),ud.y(idx),yp);
      ud.pp=mkpp(br,co);
      set(ud.Hl(1),'ydata',mmppval(ud.pp,ud.xx))
      set(Hf,'UserData',ud)
   end
   
otherwise
   disp('Unknown Argument')
end
%-------------------------------
function p=chic(x,y,yp)
%cubic hermite polynomial computation

dx=x(2)-x(1);
dx2=dx*dx;
dy=y(2)-y(1);
p=[(-2*dy/dx+yp(1)+yp(2))/dx2 (3*dy/dx-2*yp(1)-yp(2))/dx yp(1) y(1)];
