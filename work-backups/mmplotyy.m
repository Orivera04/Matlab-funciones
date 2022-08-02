function H=mmplotyy(x,y,a,b,c,d,e)
%MMPLOTYY Plot 2 Data Arrays on a Common X Axis. (MM)
% MMPLOTYY(X,Y,S1,Ylim,R,S2,Rlim)
% plots   Y vs. X with Y labeled on the left hand side, and
% plots   R vs. X with R labeled on the right hand side.
% X must be a vector, whereas Y and R can be matrices.
%
% Ylim = [Ymin Ymax] and Rlim = [Rmin Rmax] are optional row
% vectors specifying Y and R axis limits.
% S1 and S2 are optional color and line/marker style for Y and R data.
% Default: S1 = '-' (solid lines) S2 = ':' (dotted lines).
%
% MMPLOTYY('RLabelstring') places/changes a right side axis label.
% MMPLOTYY(Ha,'RLabelstring') places/changes a right side axis label
% on the axes having handle Ha. 
% H=MMPLOTYY(...) returns handles to the created lines or label.
%
% Only a Single Axes Object is Created.
% As a result, AXIS, ZOOM, LEGEND, SUBPLOT, and MMZOOM work.
% SUBPLOT deletes axes that are not its defined sizes, so MMPLOTYY
% does not shrink axes to make room for right ticks and label. To
% make room after all subplots are created, issue MMPLOTYY('shrink')
% or MMPLOTYY(Ha,'shrink'). To restore so that SUBPLOT does not
% delete the axes, issue MMPLOTYY('grow') or MMPLOTYY(Ha,'grow').
%
% If plot is modified by the above, the right side tick mark labels
% can be updated by clicking on one of them with the mouse or by
% issuing MMPLOTYY with no arguments.
%
% See also PLOTYY, MMPLOTXX

% Calls: mmgcf mmgca mmdeal

% D.C. Hanselman, University of Maine, Orono, ME, 04469
% 2/20/96, revised 3/27/96, 5/2/96, 8/16/96, 10/31/96, v5: 1/14/97, 1/20/99
% Mastering MATLAB 5, Prentice Hall, ISBN 0-13-858366-8
% Mastering MATLAB 6, Prentice Hall, ISBN 0-13-019468-9

if nargin==0 % callback or command line update requested
   
   Hf=mmgcf(1);
   Ha=mmgca(Hf,1);
   if ~strcmp(get(Ha,'Tag'),'MMPLOTYY')
      error('MMPLOTYY is not Current Axes.')
   end
   Hl=findobj(Ha,'Tag','MMPLOTYYL'); % label handle
   
   delete(findobj(Ha,'Tag','MMPLOTYYT')) % delete old ticks
   if strcmp(get(Ha,'Visible'),'off') % respond to axis off command
      set(Hl,'Visible','off')
      return
   else % respond to axis on command
      set(Hl,'Visible','on')
   end
   Yrev=strcmp(get(Ha,'YDir'),'reverse'); % get y axis direction
   Yt=get(Ha,'Ytick');  % get new y axis ticks
   ylims=get(Ha,'Ylim'); % get new y axis limits
   ntick=length(Yt);
   ymm=[min(Yt) max(Yt)];
   [m,ymin,rmin]=mmdeal(get(Hl,'UserData'));
   
   rmm=(ymm-ymin)/m + rmin;
   if Yrev  % handle axis ij command
      rmm=[rmm(2) rmm(1)];
      ymm=[ymm(2) ymm(1)];
      ylims=[ylims(2) ylims(1)];
   end	
   rmax=rmm(2);rmin=rmm(1);
   rtick=linspace(rmin,rmax,ntick); % right side tick marks
   re=max(abs(rmm));
   re=max(floor(log10(re+(re==0))));% compute r-axis exponent
   if abs(re)>1 % scale right side tick marks
      rtick=rtick/(10^re);
   end
   rmm=[rtick(1) rtick(ntick)];rx=max(abs(rmm));
   dig=min(ceil(abs(log10(abs(rmm(2)-rmm(1))/rx)))+2,4);
   i=find(abs(rtick)<10^(-dig)); % find near zero ticks
   if length(i)==1,rtick(i)=0; end
   dstr=['%.' sprintf('%.0f',dig) 'gx10^{%.0f}'];
   ymm=(ymm-ylims(1))./(ylims(2)-ylims(1)); % tick locations
   Th=linspace(ymm(1),ymm(2),ntick);
   extw=0;
   for i=1:ntick  % place right side tick labels
      rtstr=sprintf(dstr(1:4),rtick(i));
      if (i==ntick)&abs(re)>1
         rtstr=sprintf(dstr,rtick(i),re);
      end
      ht=text('String',rtstr,...
         'Units','normalized',...
         'HorizontalAlignment','left',...
         'VerticalAlignment','middle',...
         'Color',get(Ha,'YColor'),...
         'FontAngle',get(Ha,'FontAngle'),...
         'FontName',get(Ha,'FontName'),...
         'FontSize',get(Ha,'FontSize'),...
         'FontWeight',get(Ha,'FontWeight'),...
         'HandleVisibility','callback',...
         'Position',[1.005,Th(i)],...
         'Erasemode','normal',...
         'Tag','MMPLOTYYT',...
         'ButtonDownFcn','mmplotyy');
      if i<ntick  % get width of text to place label
         ext=get(ht,'extent');
         extw=max(extw,ext(3));
      end
   end
   set(Hl,'Position',[1.02+extw,0.5]) % move right side string as required
   
   return
   
elseif nargin==1
   Hf=mmgcf(1);
   Ha=mmgca(Hf,1);
   if ~strcmp(get(Ha,'Tag'),'MMPLOTYY')
      error('MMPLOTYY is not Current Axes.')
   end
   if strcmp(x,'shrink')    % MMPLOTYY('shrink')
      set(Ha,'Position',get(Ha,'Position')-[0 0 .05 0])
   elseif strcmp(x,'grow')  % MMPLOTYY('grow')
      set(Ha,'Position',get(Ha,'Position')+[0 0 .05 0])
   else                     % MMPLOTYY('RLabelstring')
      Hl=findobj(Ha,'Tag','MMPLOTYYL'); % label handle
      set(Hl,'string',x,'Visible','on');
      if nargout, H=Hl; end
   end
   return
   
elseif nargin==2
   Ha=x;
   if ~strcmp(get(Ha,'Tag'),'MMPLOTYY')
      error('Handle Ha does not point to MMPLOTYY Axes.')
   end
   if strcmp(y,'shrink')    % MMPLOTYY(Ha,'shrink')
      set(Ha,'Position',get(Ha,'Position')-[0 0 .05 0])
   elseif strcmp(y,'grow')  % MMPLOTYY(Ha,'grow')
      set(Ha,'Position',get(Ha,'Position')+[0 0 .05 0])
   else                     % MMPLOTYY(Ha,'RLabelstring')
      Hl=findobj(Ha,'Tag','MMPLOTYYL'); % label handle
      set(Hl,'string',y,'Visible','on');
      if nargout, H=Hl; end
   end	
   return
   
elseif nargin==3                       % MMPLOTYY(X,Y,R)
   S1='-'; YMM=[]; r=a; S2=':'; RMM=[];
   
elseif nargin==4
   if ischar(a)                        % MMPLOTYY(X,Y,S1,R)
      S1=a; YMM=[]; r=b; S2=':'; RMM=[];
   elseif ischar(b)                    % MMPLOTYY(X,Y,R,S2)
      S1='-'; YMM=[]; r=a; S2=b; RMM=[];
   elseif length(a)==2                % MMPLOTYY(X,Y,Ylim,R)
      S1='-'; YMM=a; r=b; S2=':'; RMM=[];;
   elseif length(b)==2                % MMPLOTYY(X,Y,R,Rlim)
      S1='-'; YMM=[]; r=a; S2=':'; RMM=b;
   else
      error('Unknown Input Argument Format')
   end
elseif nargin==5
   if ischar(a)&ischar(c)               % MMPLOTYY(X,Y,S1,R,S2)
      S1=a; YMM=[]; r=b; S2=c; RMM=[];
   elseif ischar(a)&length(c)==2       % MMPLOTYY(X,Y,S1,R,Rlim)
      S1=a; YMM=[]; r=b; S2=':'; RMM=c;
   elseif ischar(a)&length(b)==2       % MMPLOTYY(X,Y,S1,Ylim,R)
      S1=a; YMM=b; r=c; S2=':'; RMM=[];
   elseif ischar(b)&length(c)==2       % MMPLOTYY(X,Y,R,S2,Rlim)
      S1='-'; YMM=[]; r=a; S2=b; RMM=c;
   elseif ischar(c)&length(a)==2       % MMPLOTYY(X,Y,Ylim,R,S2)
      S1='-'; YMM=a; r=b; S2=c; RMM=[];
   elseif length(a)==2&length(c)==2;  % MMPLOTYY(X,Y,Ylim,R,Rlim)
      S1='-'; YMM=a; r=b; S2=':'; RMM=c;
   else
      error('Unknown Input Argument Format.')
   end
elseif nargin==6
   if ischar(a)&ischar(c)               % MMPLOTYY(X,Y,S1,R,S2,Rlim)
      S1=a; YMM=[]; r=b; S2=c; RMM=d(1:2);
   elseif length(a)==2&ischar(c)       % MMPLOTYY(X,Y,Ylim,R,S2,Rlim)
      S1='-'; YMM=a; r=b; S2=c; RMM=d(1:2);
   elseif ischar(a)&ischar(d)           % MMPLOTYY(X,Y,S1,Ylim,R,S2)
      S1=a; YMM=b(1:2); r=c; S2=d; RMM=[];
   elseif ischar(a)&length(b)==2;      % MMPLOTYY(X,Y,S1,Ylim,R,Rlim)
      S1=a; YMM=b; r=c; S2=':'; RMM=d(1:2);
   else
      error('Unknown Input Argument Format.')
   end
elseif nargin==7                       % MMPLOTYY(X,Y,S1,Ylim,R,S2,Rlim)
   S1=a; YMM=b(1:2); r=c; S2=d; RMM=e(1:2);     
else
   error('Incorrect number of input arguments.')
end
%-------- create initial plot ------------

if min(size(x))>1, error('X Must be a Vector.'), end
Ha=newplot;   % clear/create axes, can't place one MMPLOTYY on top of another
Hf=get(Ha,'Parent');

if isempty(RMM) % choose auto r-axis limits	
   Hr=plot(x,r); % plot right side data to get its auto axis limits
   rlims=get(Ha,'Ylim'); % r-axis limits
   delete(Hr)  % delete line since it is not needed any more
end

Hy=plot(x,y,S1); % plot left side data on a new axis
set(Ha,'Tag','MMPLOTYY','Units','normalized','NextPlot','add')
dpos=get(Hf,'DefaultAxesPosition'); % default position
pos=get(Ha,'Position'); % actual position
if all(pos(3:4)==dpos(3:4)) % decrease width if default
   pos=dpos-[0 0 .05 0];   % if not, assume that it's O.K.
end
set(Ha,'Position',pos)
if ~isempty(YMM) % user chose fixed axis limits
   set(Ha,'Ylim',[min(YMM) max(YMM)],'YlimMode','manual')
end
Yt=get(Ha,'Ytick');  % get y axis info
ymm=[min(Yt) max(Yt)];
ntick=length(Yt);
ylims=get(Ha,'Ylim');

if ~isempty(RMM) % user has chosen fixed r-axis limits
   set(Ha,'YLimMode','manual'); % freeze y-axis
   rlims=sort(RMM); % apply user chosen limits
end

re=max(abs(rlims));
re=max(floor(log10(re+(re==0)))); % r-axis exponent
m=(ylims(2)-ylims(1))/(rlims(2)-rlims(1));  % slope of r to y scaling
ry=m*(r-rlims(1)) + ylims(1);  % scale r data to y axis
Udata=[m ylims(1) rlims(1)];   % data to keep for later
Hr=plot(x,ry,S2);              % plot scaled right hand side data
set(Ha,'NextPlot','replace')   % turn hold off
ylims=get(Ha,'Ylim');          % get new limits in case they changed

rtick=linspace(rlims(1),rlims(2),ntick); % right side tick marks
if abs(re)>1 % scale right side tick marks
   rtick=rtick/(10^re);
end
rmm=[rtick(1) rtick(ntick)];rx=max(abs(rmm));
dig=min(ceil(abs(log10(abs(rmm(2)-rmm(1))/rx)))+2,4);
i=find(abs(rtick)<10^(-dig)); % find near zero ticks
if length(i)==1,rtick(i)=0; end
dstr=['%.' sprintf('%.0f',dig) 'gx10^{%.0f}'];
extw=0; % normalized width of tick labels
ymm=(ymm-ylims(1))./(ylims(2)-ylims(1)); % tick positions
Th=linspace(ymm(1),ymm(2),ntick);
for i=1:ntick  % place right side tick labels
   rtstr=sprintf(dstr(1:4),rtick(i));
   if (i==ntick) & abs(re)>1
      rtstr=sprintf(dstr,rtick(i),re);
   end
   ht=text('String',rtstr,...
      'Units','normalized',...
      'HorizontalAlignment','left',...
      'VerticalAlignment','middle',...
      'Color',get(Ha,'YColor'),...
      'FontAngle',get(Ha,'FontAngle'),...
      'FontName',get(Ha,'FontName'),...
      'FontSize',get(Ha,'FontSize'),...
      'FontWeight',get(Ha,'FontWeight'),...
      'HandleVisibility','callback',...
      'Position',[1.005,Th(i)],...
      'Erasemode','normal',...
      'Tag','MMPLOTYYT',...
      'ButtonDownFcn','mmplotyy');
   if i<ntick  % get width of text to place label
      ext=get(ht,'extent');
      extw=max(extw,ext(3));
   end
end
Hl=text('String','',...  % create object to store right label
   'Units','normalized',...
   'HorizontalAlignment','center',...
   'VerticalAlignment','baseline',...
   'Position',[1.02+extw,0.5],...
   'Rotation',270,...
   'Color',get(Ha,'YColor'),...
   'FontAngle',get(Ha,'FontAngle'),...
   'FontName',get(Ha,'FontName'),...
   'FontSize',get(Ha,'FontSize'),...
   'FontWeight',get(Ha,'FontWeight'),...
   'Tag','MMPLOTYYL',...
   'Visible','off',...
   'Userdata',Udata); % storage of scaling parameters

if nargout, H=[Hy;Hr]; end
