function H=mmpolar(varargin)
%MMPOLAR Linear or Logarithmic Polar Coordinate Plot. (MM)
% Hl=MMPOLAR(THETA,RHO,S1,S2,...) generates a polar coordinate plot using
% the angle vector THETA in radians and radius array RHO and optional 
% linestyle specifications S1,S2, etc. THETA must be a vector, but RHO can
% be either a vector the same size as THETA or a matrix having length(THETA)
% rows. If RHO is a vector only S1 is valid. If RHO is a matrix the (i)th
% column is plotted using Si. Empty Si applies the default linestyle to the 
% (i)th column of RHO. If present, Hl contains handles to the plotted lines.
%
% Hl=MMPOLAR(THETA,RHO,'log',S1,S2,...) generates a polar plot with a
% log10 RHO axis.
%
% MMPOLAR on {off} enables {disables} feedback of mouse position over
% the current plot with the mouse button down. Clicking in the figure window
% outside the axis rectangle also disables mouse feedback.
%
% MMPOLAR or MMPOLAR(Ha) displays the polar graphics property settings
% for the current polar axes or the axes having handle Ha.
% MMPOLAR('Name') or MMPOLAR(Ha,'Name') gets the polar property value
% associated with the polar property name 'Name'.
% MMPOLAR('Name','Value',...) or MMPOLAR(Ha,'Name','Value',...) sets polar
% property values according to the property name-property value pairs:
% NAME         VALUE  {default}
% Axis         [{on} off] shortcut for Box and Rgrid and Tgrid [{on} off]
% Box          [{on} off]  for axes bounding circle
% Color        [y m c r g b w k] or an rgb for axes background color
% FontName     [any valid font name] font for tick labels
% FontSize     [size in points] for tick label font size
% RColor       [y m c r g b w k] or an rgb for rho axis grid color
% RGrid        [{on} off] for rho axis grid visibility
% RGridStyle   [-  --  {:}  -.] for rho axis grid linestyle
% Rlim         [Rmin Rmax] rho axis limits (Read Only)
% RScale       [{lin} log] rho axis tick label scaling (Read Only)
% RTickNum     [number] for rho axis tick number ('lin' rho scaling only)
% TColor       [y m c r g b w k] or an rgb for theta axis grid color
% TGrid        [{on} off] for theta axis grid visibility
% TGridStyle   [-  --  {:}  -.] for theta axis grid linestyle
% TScale       [{deg} rad] theta axis tick label scaling, 'rad'=radians/pi
% TTickNum     [number] for theta axis tick number
%
% MMPOLAR does NOT work with the commands: hold, axis, grid.
%
% See also POLAR, GRAPH2D

% Calls: mmgcf mmgca mmdeal mmget mmrgb mmprintf mmgetpos mmgetsiz

% B.R. Littlefield, D.C. Hanselman, University of Maine, Orono, ME, 04469
% 9/3/96, revised 9/12/96, 11/4/96, 11/26/96, v5: 1/14/97, 4/25/97
% Mastering MATLAB 5, Prentice Hall, ISBN 0-13-858366-8
% Mastering MATLAB 6, Prentice Hall, ISBN 0-13-019468-9

nargi=nargin;
Ha=findobj('Type','axes','Tag','MMPOLAR');
% tasks: logical vector to direct action
% tasks(1)=getprops  tasks(2)=showprops tasks(3)=retprop
% tasks(4)=setprop   tasks(5)=linplot   tasks(6)=logplot
% tasks(7)=on        tasks(8)=buttondwn tasks(9)=motion
% tasks(10)=buttonup tasks(11)=off

if nargi==0                       % show properties
   tasks=[1 1 0 0 0 0 0 0 0 0 0];
elseif nargi==1 & (varargin{1}==-1)        % button down
   tasks=[1 0 0 0 0 0 0 1 0 0 0];
elseif nargi==1 & (varargin{1}==-2)        % button motion
   tasks=[1 0 0 0 0 0 0 0 1 0 0];
elseif nargi==1 & (varargin{1}==-3)        % button up
   tasks=[1 0 0 0 0 0 0 0 0 1 0];
elseif nargi==1 & ~ischar(varargin{1})      % show properties
   tasks=[1 1 0 0 0 0 0 0 0 0 0];
   Ha=varargin{1};
elseif nargi==1 & ischar(varargin{1})
   if strcmp(varargin{1},'on')            % enable probe
      tasks=[1 0 0 0 0 0 1 0 0 0 0];
   elseif strcmp(varargin{1},'off')       % disable probe
      tasks=[1 0 0 0 0 0 0 0 0 0 1];
   else                          % return property
      tasks=[1 0 1 0 0 0 0 0 0 0 0];
      varargin{2}=varargin{1};
   end	
elseif nargi==2 & ~ischar(varargin{1}) & ischar(varargin{2}) % return property
   tasks=[1 0 1 0 0 0 0 0 0 0 0];
   Ha=varargin{1};
elseif nargi>=2 & ischar(varargin{1})       % set properties, update plot
   tasks=[1 0 0 1 0 0 0 0 0 0 0];
   sp=1;
elseif nargi>2 & length(varargin{1})==1    % set properties, update plot
   tasks=[1 0 0 1 0 0 0 0 0 0 0];
   sp=2; Ha=varargin{1};
elseif nargi==2                   % plot linear data
   tasks=[0 0 0 0 1 0 0 0 0 0 0];
elseif nargi>2 & strcmp(varargin{3},'log') % plot log data
   tasks=[0 0 0 0 0 1 0 0 0 0 0];
else                              % plot linear data
   tasks=[0 0 0 0 1 0 0 0 0 0 0];
end
% generic data
ass=1.07;  % axes size scaling
tu=linspace(0,2*pi)'; xu=cos(tu); yu=sin(tu);
onoff=['on ';'off']; degrad=['deg';'rad']; linlog=['lin';'log'];

%cycle through tasks
if tasks(1)  % get stored properties
   if isempty(Ha)
      error('No MMPOLAR Plot Exists.')
   elseif ~strcmp(get(Ha,'Tag'),'MMPOLAR')
      error('Handle Does NOT Point to an MMPOLAR Axes.')
   end
   % Axes UserData stores handles to (1) rho grid lines
   % (2) theta grid lines, (3) axes background patch
   % Rho grid UserData stores handles to Rho tick labels
   % Theta grid UserData stores handles to Theta tick labels
   % Patch UserData stores property value vector
   Ha=Ha(1);
   Hf=get(Ha,'Parent');
   Hx=get(Ha,'Userdata');  % handles of MMPOLAR objects
   [Hrg,Htg,Hp]=mmdeal(Hx);   % rho grid lines, theta grid lines, patch
   [Hrt,Htt,tmp]=mmget(Hx,'Userdata'); % rho ticks, theta ticks, values
   [box,rgrid,rmin,rmax,rscale,tgrid,tscale]=mmdeal(tmp);
   
end
if tasks(2)  % show all properties
   
   fprintf('MMPOLAR Object Properties\n')
   fprintf('\tBox = %s\n',onoff(box,:))
   fprintf('\tColor = [%.3g %.3g %.3g]\n',get(Hp,'FaceColor'))
   fprintf('\tFontName = %s\n',get(Hrt(1),'FontName'))
   fprintf('\tFontSize = %.3g\n',get(Hrt(1),'FontSize'))
   fprintf('\tRColor = [%.3g %.3g %.3g]\n',get(Hrg,'Color'))
   fprintf('\tRGrid = %s\n',onoff(rgrid,:))
   fprintf('\tRGridStyle = %s\n',get(Hrg,'Linestyle'))
   fprintf('\tRlim = [%.3g %.3g]\n',rmin,rmax)
   fprintf('\tRScale = %s\n',linlog(rscale,:))
   fprintf('\tRtickNum = %.0f\n',length(Hrt))
   fprintf('\tTColor = [%.3g %.3g %.3g]\n',get(Htg,'Color'))
   fprintf('\tTGrid = %s\n',onoff(tgrid,:))
   fprintf('\tTGridStyle = %s\n',get(Htg,'Linestyle'))
   fprintf('\tTScale = %s\n',degrad(tscale,:))
   fprintf('\tTtickNum = %.0f\n',length(Htt))
end
if tasks(3)  % return a specific property
   
   pstr=[lower(varargin{2}) blanks(6-length(varargin{2}))];
   if     strcmp(pstr(1),'b'),       H=deblank(onoff(box,:));
   elseif strcmp(pstr(1),'c'),       H=get(Hp,'FaceColor');
   elseif strcmp(pstr(1:5),'fontn'), H=get(Hrt(1),'FontName');
   elseif strcmp(pstr(1:5),'fonts'), H=get(Hrt(1),'FontSize');
   elseif strcmp(pstr(1:2),'rc'),    H=get(Hrg,'Color');
   elseif strcmp(pstr,'rgrids'),     H=get(Hrg,'Linestyle');
   elseif strcmp(pstr(1:5),'rgrid'), H=deblank(onoff(rgrid,:));
   elseif strcmp(pstr(1:2),'rl'),    H=[rmin,rmax];
   elseif strcmp(pstr(1:2),'rs'),    H=linlog(rscale,:);
   elseif strcmp(pstr(1:2),'rt'),    H=length(Hrt);
   elseif strcmp(pstr(1:2),'tc'),    H=get(Htg,'Color');
   elseif strcmp(pstr,'tgrids'),     H=get(Htg,'Linestyle');
   elseif strcmp(pstr(1:5),'tgrid'), H=deblank(onoff(tgrid,:));
   elseif strcmp(pstr(1:2),'ts'),    H=degrad(tscale,:);
   elseif strcmp(pstr(1:2),'tt'),    H=length(Htt);
   else, error(['Unknown Object Property: ' varargin{2}])
   end
end
if tasks(4)  % set property, update plot as necessary
   for i=sp:2:nargi-1
      name=varargin{i};
      name=[lower(name) blanks(6)];
      value=varargin{i+1};
      err=0;
      if strcmp(name(1),'a')  % change total axis visibility
         if strcmp(value,'on')
            box=1;   set(Hp,'EdgeColor',get(Hrg,'Color'))
            rgrid=1; set([Hrt;Hrg],'Visible','on')
            tgrid=1; set([Htt;Htg],'Visible','on')
         elseif strcmp(value,'off')
            box=2;   set(Hp,'Edgecolor','none')
            rgrid=2; set([Hrt;Hrg],'Visible','off')
            tgrid=2; set([Htt;Htg],'Visible','off')
         else, err=1;
         end
      elseif strcmp(name(1),'b')  % change box
         if strcmp(value,'on')
            box=1; set(Hp,'EdgeColor',get(Hrg,'Color'))
         elseif strcmp(value,'off')
            box=2; set(Hp,'Edgecolor','none')
         else, err=1;
         end
      elseif strcmp(name(1),'c')  % change axes background color
         if value(1) == '[', value=eval(value); end
         set(Hp,'FaceColor',mmrgb(value,get(Hp,'FaceColor')))
      elseif strcmp(name(1:5),'fontn')  % change font name
         if ischar(value)
            set([Hrt;Htt],'FontName',value)
         else, err=1;			
         end
      elseif strcmp(name(1:5),'fonts')  % change font size
         if ischar(value), value=eval(value); end
         if length(value)==1 & value>6
            set([Hrt;Htt],'FontSize',value)
         else, err=1;
         end
      elseif strcmp(name(1:2),'rc')  % change rho grid color
         if value(1) == '[', value=eval(value); end
         value=mmrgb(value,get(Hrg,'Color'));
         set([Hrt;Hrg],'Color',value)
         if box==1, set(Hp,'EdgeColor',value); end
      elseif strcmp(name(1:6),'rgrids')  % change rho grid style
         if ischar(value)
            set(Hrg,'LineStyle',value)
         else, err=1;			
         end
      elseif strcmp(name(1:5),'rgrid')  % change rho grid visibility
         if strcmp(value,'on')
            rgrid=1; set([Hrt;Hrg],'Visible','on')
         elseif strcmp(value,'off')
            rgrid=2; set([Hrt;Hrg],'Visible','off')
         else, err=1;
         end
      elseif strcmp(name(1:2),'rt') & rscale==1 % # rho ticks
         if ischar(value), value=eval(value); end
         value=value(1);
         rtv=linspace(rmin,rmax,value);
         tmpx=[xu;NaN];
         tmp=repmat(rtv,length(tmpx),1);
         tmpx=repmat(tmpx,1,value).*tmp;
         tmpy=[yu;NaN];
         tmpy=repmat(tmpy,1,value).*tmp;
         tmp=mmprintf('%.3g',rtv);
         tmp(1,:)=blanks(size(tmp,2));
         [fname,fsize]=mmget(Hrt(1),'FontName','FontSize');
         delete(Hrt)
         Hrt=text(zeros(size(rtv)),rtv,tmp,...
            'Color',get(Hrg,'Color'),...
            'FontName',fname,'FontSize',fsize,...
            'Visible',onoff(rgrid,:),...
            'HorizontalAlignment','Left','VerticalAlignment','Top');
         set(Hrg,'Xdata',tmpx(:),'Ydata',tmpy(:),'UserData',Hrt);
      elseif strcmp(name(1:2),'rt') & rscale==2
         disp('RTickNum is Read Only for RScale=''log'' Scaling.')
      elseif strcmp(name(1:2),'rl')
         disp('RLim is a Read Only Property.')
      elseif strcmp(name(1:2),'rs')
         disp('Rscale is a Read Only Property.')
      elseif strcmp(name(1:2),'tc')  % change theta grid color
         if value(1) == '[', value=eval(value); end
         set([Htt;Htg],'Color',mmrgb(value,get(Htg,'Color')))	
      elseif strcmp(name(1:6),'tgrids')  % change theta grid style
         if ischar(value)
            set(Htg,'LineStyle',value)
         else, err=1;			
         end
      elseif strcmp(name(1:5),'tgrid')  % change theta grid visibility
         if strcmp(value,'on')
            tgrid=1; set([Htt;Htg],'Visible','on')
         elseif strcmp(value,'off')
            tgrid=2; set([Htt;Htg],'Visible','off')
         else, err=1;
         end
      elseif strcmp(name(1:2),'ts')  % change theta axes scaling
         if     value(1)=='d', value='deg';
         elseif value(1)=='r', value='rad'; 
         end
         if ischar(value) & ~strcmp(degrad(tscale),value)
            ttv=linspace(0,2*pi,length(Htt)+1);
            ttv(length(Htt)+1)=[];
            if     strcmp(value,'deg'), tscale=1;ttv=ttv*180/pi;
            elseif strcmp(value,'rad'), tscale=2;ttv=ttv/pi;
            end
            for i=1:length(Htt)
               set(Htt(i),'String',sprintf('%.3g',ttv(i)))
            end
         else, err=1;
         end
      elseif strcmp(name(1:2),'tt')  % # theta ticks
         if ischar(value), value=eval(value); end
         value=value(1)+rem(value(1),2); % must be even
         ttv=linspace(0,2*pi,value+1); ttv(value+1)=[];
         rm=rmax;
         if rscale==2, rm=1; end
         tmpx=[zeros(1,value);rm*cos(ttv);NaN+zeros(1,value)];
         tmplx=tmpx(2,:)*ass;
         tmpy=[zeros(1,value);rm*sin(ttv);NaN+zeros(1,value)];
         tmply=tmpy(2,:)*ass;
         if     tscale==1, ttv=ttv*180/pi;
         elseif tscale==2, ttv=ttv/pi;
         end
         [fname,fsize]=mmget(Htt(1),'FontName','FontSize');
         delete(Htt);
         tmp=mmprintf('%.3g',ttv);
         Htt=text(tmplx(:),tmply(:),tmp,...
            'Color',get(Htg,'Color'),...
            'FontName',fname,'FontSize',fsize,...
            'Visible',onoff(tgrid,:),...
            'HorizontalAlignment','Center','VerticalAlignment','Middle');
         set(Htg,'Xdata',tmpx(:),'Ydata',tmpy(:),'UserData',Htt);
      else
         disp(['Warning: Property Name: ' name ' Unknown'])
      end
      set(Hp,'UserData',[box,rgrid,rmin,rmax,rscale,tgrid,tscale])
      if err
         disp(['Warning: Value for Property Name: ' name ' Unknown'])
      end
   end
end
if tasks(5) | tasks(6) % create plot and set default properties
   
   theta=varargin{1}(:); % create column vector
   tlen=length(theta);
   rc=size(varargin{2});
   if min(rc)==1 & tlen==max(rc), rho=varargin{2}(:); rc(1)=max(rc);rc(2)=1;
   elseif rc(1)==tlen,            rho=varargin{2};
   elseif rc(2)==tlen,            rho=varargin{2}.';  rc=rc([2 1]);
   else, error('Sizes of THETA and RHO do Not Match.')
   end
   
   Hf=mmgcf;
   if isempty(Hf), Hf=figure('Visible','off'); end
   delete(mmgca);
   
   if tasks(5)
      rlim=[min(0,min(min(rho))) max(max(rho))];
      tmp=plot([0 1],rlim);
   else
      if any(rho<=1e-12)
         error('RHO Must Contain Positive Values Only.')
      end
      rlim=[min(min(rho)) max(max(rho))];
      tmp=semilogy([0 1],rlim);
   end
   
   rlim=get(gca,'Ylim');
   rtickn=length(get(gca,'Ytick'));
   delete(tmp)
   
   % set default property values
   box=1;
   rgrid=1;
   rmin=rlim(1);
   rmax=rlim(2);
   tgrid=1;
   tscale=1;
   
   Ha=mmgca(Hf);
   reset(Ha)
   dap=get(Hf,'DefaultAxesPosition');
   aap=get(Ha,'Position');
   if all(dap(3:4)==aap(3:4)) % adjust axes and figure sizes
      set(Ha,'Units','Normalized',...
         'Position',[10 10 80 80]/100)
      dfp=get(0,'DefaultFigurePosition');
      afp=get(Hf,'Position');
      if all(afp(3:4)==dfp(3:4))
         wh=0.5*(afp(3)+afp(4));
         set(Hf,'Position',[afp(1)+afp(3)-wh afp(4)+afp(2)-wh wh wh])
      end
   end
   set(Hf,'ButtonDownFcn','mmpolar(''off'')')
   
   if tasks(5)
      rscale=1; mmax=rmax-rmin; mmin=0; mscale=1; mdt=2;
      if rtickn>8
         if     rem(rtickn,2)==0, rtickn=rtickn/2;
         elseif rem(rtickn,3)==0, rtickn=rtickn/3;
         end
      end
      if rtickn<4; rtickn=2*rtickn; end
      rhol=rho-rmin;
   else
      rscale=2; mmax=1; mmin=0; mscale=0.99; mdt=3;
      rhol=(log10(rho)-log10(rmin))/(log10(rmax)-log10(rmin));
   end
   
   % create axes background color patch
   tmp=mmrgb(get(Ha,'Color'),get(Hf,'Color'));  % axes color
   Hp=patch('Xdata',xu*mmax,...
      'Ydata',yu*mmax,...
      'Zdata',zeros(size(xu))-1e-3,...
      'EdgeColor',get(Ha,'YColor'),...
      'FaceColor',tmp);
   axis('off','square','equal')
   axis([-1 1 -1 1]*ass*mmax)
   set([Ha;Hf],'Nextplot','add') % hold on
   
   % create rho grid and labels
   rtv=linspace(mmin,mmax,rtickn);
   rtv=rtv(2:rtickn);
   tmpx=[xu;NaN];
   tmp=repmat(rtv,length(tmpx),1);
   tmpx=repmat(tmpx,1,length(rtv)).*tmp;
   tmpy=[yu;NaN];
   tmpy=repmat(tmpy,1,length(rtv)).*tmp;
   
   if tasks(5)
      tmpl=mmprintf('%.3g',rtv+rmin);
   else
      tmp=round(log10(rlim));
      rtvl=10.^(tmp(1)+1:tmp(2));
      tmpl=mmprintf('%.4g',rtvl);
   end
   
   Hrg=plot(tmpx(:),tmpy(:),get(Ha,'GridLineStyle'),...
      'Color',get(Ha,'Ycolor'),'LineWidth',1);
   
   Hrt=text(zeros(size(rtv)),mscale*rtv,tmpl,'Color',get(Ha,'Ycolor'),...
      'FontName',get(Ha,'FontName'),'FontSize',get(Ha,'FontSize'),...
      'HorizontalAlignment','Left','VerticalAlignment','Top');
   
   % create theta axis grid and labels
   ttickn=12;
   ttv=linspace(0,2*pi,ttickn+1); ttv(ttickn+1)=[];
   tmpx=[zeros(1,ttickn);mmax*cos(ttv);NaN+zeros(1,ttickn)];
   tmpy=[zeros(1,ttickn);mmax*sin(ttv);NaN+zeros(1,ttickn)];
   tmplx=tmpx(2,:)*ass;
   tmply=tmpy(2,:)*ass;
   ttv=ttv*180/pi;
   Htg=plot(tmpx(:),tmpy(:),get(Ha,'GridLineStyle'),...
      'Color',get(Ha,'Xcolor'),'Linewidth',1);
   
   tts=mmprintf('%.3g',ttv);
   Htt=text(tmplx(:),tmply(:),tts,'Color',get(Ha,'Xcolor'),...
      'FontName',get(Ha,'FontName'),'FontSize',get(Ha,'FontSize'),...
      'HorizontalAlignment','Center','VerticalAlignment','Middle');
   
   % plot input data
   th=repmat(theta,1,rc(2));
   Hl=plot(rhol.*cos(th),rhol.*sin(th));
   for i=1:min(rc(2),nargi-mdt)
      cs=varargin{i+mdt};
      if ~isempty(cs) & ischar(cs)
         [ls,co,ms]=colstyle(cs);
         if ~isempty(ls), set(Hl(i),'Linestyle',ls), end
         if ~isempty(co), set(Hl(i),'Color',co),     end
         if ~isempty(ms), set(Hl(i),'Marker',ms),    end
         if isempty(ls) & ~isempty(ms), set(Hl(i),'Linestyle','none'), end
      end
   end
   set(Ha,'Nextplot','replace') % hold off
   set(Hf,'Visible','on')
   if nargout, H=Hl; end
   
   % store handles and data
   set(Ha,'Tag','MMPOLAR','UserData',[Hrg Htg Hp])
   set(Hrg,'UserData',Hrt)
   set(Htg,'UserData',Htt)
   set(Hp,'UserData',[box,rgrid,rmin,rmax,rscale,tgrid,tscale]);
end
if tasks(7)
   set(Hf,'WindowButtonDownFcn','mmpolar(-1)')
end
if tasks(8) % button down function
   set(Hf,'WindowButtonMotionFcn','mmpolar(-2)',...
      'WindowButtonUpFcn','mmpolar(-3)',...
      'BackingStore','off',...
      'Pointer','crossh')
   set(Hrg,'Visible','off')  % turn rgrid off
   xd=[xu;nan+zeros(6,1)];
   yd=[yu;nan+zeros(6,1)];
   Hc=findobj(Hf,'type','line','Tag','MMPOLARC');
   if isempty(Hc)  % create line if it does not exist
      line('Xdata',xd,'Ydata',yd,...
         'Color',get(Hrg,'Color'),...
         'LineWidth',1,'LineStyle','--',...
         'EraseMode','xor',...
         'HandleVisibility','callback',...
         'Tag','MMPOLARC');
      
      apos=mmgetpos(Ha,'pixels');
      asiz=mmgetsiz(Ha,'pixels');			
      apos=[apos(1) (apos(2)-asiz-20) apos(3) 20];
      uicontrol(Hf,'Style','text',...
         'units','pixels',...
         'Position',apos,...
         'FontName',get(Ha,'FontName'),...
         'FontUnits','pixels',...
         'FontSize',asiz,...
         'BackGroundColor',get(Hf,'Color'),...
         'ForeGroundColor',get(Ha,'XColor'),...
         'HorizontalAlignment','center',...
         'Tag','MMPOLAR',...
         'String','Hi there');
   end
end
if tasks(9) % button motion function
   xy=get(Ha,'CurrentPoint');xy=xy(1,1:2);
   r=norm(xy);
   t=180/pi*(atan2(xy(2),xy(1)));
   t=t+(t<0)*360;
   tmp=[-xy;xy;nan nan;xy(1) -xy(2);-xy(1) xy(2)];
   if rscale==1, rl=r; % linear scale
   else,   rl=r; r=10.^((log10(rmax)-log10(rmin))*r+log10(rmin)); % log scale
   end
   if tscale==1, ts='deg';           % degrees scale
   else,         t=t/180; ts='* pi'; % radians scale
   end
   if r<=rmax-rmin  % update gradicule if inside axes
      Hlab=findobj(Hf,'Type','uicontrol','Tag','MMPOLAR');
      set(Hlab,'String',sprintf('THETA=%.3g %s   RHO=%.3g',t,ts,r+rmin))
      xd=[rl*xu;nan;tmp(:,1)];
      yd=[rl*yu;nan;tmp(:,2)];
      Hc=findobj(Hf,'Type','line','Tag','MMPOLARC');
      set(Hc,'Xdata',xd,'Ydata',yd)
   end
end
if tasks(10) % button up function
   set(Hf,'Pointer','arrow',...
      'WindowButtonMotionFcn','',...
      'WindowButtonUpFcn','')
end
if tasks(11) % off probe
   set(Hf,'WindowButtonMotionFcn','',...
      'WindowButtonUpFcn','',...
      'WindowButtonDownFcn','',...
      'BackingStore','on',...
      'Pointer','arrow')
   delete(findobj(Hf,'Type','line','Tag','MMPOLARC'))      % delete cursor
   delete(findobj(Hf,'Type','uicontrol','Tag','MMPOLAR')); % delete uicontrol
   set(Hrg,'Visible','on')                                 % make grid visible
end
