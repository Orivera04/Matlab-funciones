function pp=mmpfit(x,y,n,we)
%MMPFIT Interactive Polynomial Curve Fitting GUI. (MM)
% MMPFIT(X,Y) or MMPFIT(X,Y,N) or MMPFIT(X,Y,N,W) fits a polynomial P(X)
% to the data in X and Y in the least-squares sense. N is an optional initial
% polynomial order. W is an optional positive weighting vector identifying
% the weight to be applied to each pair of data points in X and Y.
%
% The resulting polynomial and the data X and Y are plotted in a figure
% window with GUI controls for adjusting the weight applied at each point
% and the order of the fit.
%
% Pressing the Done button returns the adjusted polynomial vector.
%
% The y-axis label shows the current error norm, NORM(Y-POLYVAL(P,X)).
%
% Clicking on a data point circle displays the weight at the chosen point
% and allows it to be edited. Clicking on an open area in the figure deselects
% a chosen point.

% Calls: mmrwpfit mmp2str mmrwpfit mmgetpos mmputptr

% D.C. Hanselman, University of Maine, Orono ME,  04469
% 4/14/98, 5/8/98, 10/10/98, 6/14/00
% Mastering MATLAB 6, Prentice Hall, ISBN 0-13-019468-9

if nargin>=2 % new call
   
   x=x(:); y=y(:);
   nmax=length(x)-1;
   if nmax>40
      warning('It is difficult to use this GUI with so many points.')
   end
   
   if nargin==2
      n=min(ceil(nmax/2),5);
   end
   if nargin<=3
      we=ones(size(x));
   end
   we=we(:);
   if any(we<=0)
      error('W Must Contain Positive Values.')
   end
   if length(we)~=length(x)
      error('W and X Must Be Same Length.')
   end
   if length(x)~=length(y)
      error('X and Y Must Must Be Same Length.')
   end
   if fix(n)~=n | n<0
      error('Order Must be a Positive Integer.')
   elseif n>nmax
      error('Requested Polynomial Order too High.')
   end
   p=mmrwpfit(x,y,n,we);
   ne=norm(y-polyval(p,x));
   xmin=min(x); xmax=max(x);
   xx=linspace(xmin,xmax,100);
   yy=polyval(p,xx);
   
   ud.Hlfit=plot(xx,yy);
   grid on
   title(['P(x) = ' mmp2str(p)])
   ylabel(['NORM(Error) = ' sprintf('%.4g',ne)])
   Hf=gcf;
   Hfrgb=get(0,'DefaultUicontrolBackgroundColor');
   Ha=gca;
   set(Ha,'Xlim',[xmin xmax])
   tmp=get(Ha,'ColorOrder');
   ud.c1=tmp(1,:);
   ud.c3=tmp(3,:);
   ud.Hlpts=zeros(size(x));
   for i=1:length(x)
      ud.Hlpts(i)=line('Xdata',x(i),'Ydata',y(i),...
         'LineStyle','none','Marker','o',...
         'Color',ud.c1,...
         'ButtonDownFcn','mmpfit data');
   end
   
   inc=1/9;
   apos=mmgetpos(Ha,'normalized');
   w=inc-.02; h=.05; b=.01; he=.05; l=apos(1)+b;
   
   Hfr=uicontrol('Parent',Hf,'Style','Frame',...
      'Units','normalized',...
      'Position',[apos(1) 0 apos(3) apos(2)-.05]);
   ud.Huiw=uicontrol('Parent',Hf,'Style','Edit',... % Weight Edit
      'Units','Normalized','Position',[l+inc b w he],...
      'String',' ',...
      'HorizontalAlignment','Left',...
      'Enable','off',...
      'Callback','mmpfit weight');
   tmp=get(ud.Huiw,'Extent'); he=1.3*tmp(4); h=tmp(4);
   set(ud.Huiw,'Position',[l+inc b w he])
   set(Hfr,'Position',[apos(1) 0 apos(3) he+2*b]);
   uicontrol('Parent',Hf,'Style','Text',... % Weight Text
      'Units','Normalized','Position',[l b w h],...
      'String','Weight',...
      'HorizontalAlignment','Right')	
   ud.Huio=uicontrol('Parent',Hf,'Style','Edit',... % Order Edit
      'Units','Normalized','Position',[l+3*inc b w he],...
      'String',sprintf('%d',n),...
      'HorizontalAlignment','Left',...
      'Callback','mmpfit order');
   uicontrol('Parent',Hf,'Style','Text',... % Order Text
      'Units','Normalized','Position',[l+2*inc b w h],...
      'String','Order',...
      'HorizontalAlignment','Right')
   uicontrol('Parent',Hf,'Style','Pushbutton',... % Apply
      'Units','Normalized','Position',[l+4*inc b w he],...
      'String','Apply',...
      'Callback','mmpfit apply')
   uicontrol('Parent',Hf,'Style','PushButton',... % Done
      'Units','Normalized','Position',[l+6*inc b w he],...
      'String','Done',...
      'Callback','mmpfit done')
   uicontrol('Parent',Hf,'Style','PushButton',... % Revert
      'Units','Normalized','Position',[l+5*inc b w he],...
      'String','Revert',...
      'Callback','mmpfit revert')
   
   ud.Ha=Ha; % store data in a structure
   ud.x=x;   % original x data
   ud.y=y;   % original y data
   ud.n=n;   % current poly order
   ud.xx=xx; % poly interp x
   ud.yy=yy; % original poly interp y
   ud.defn=n;% default order
   ud.nmax=nmax; % max poly order
   ud.weight=we; % current weight vector
   ud.defweight=we; % default weight vector
   ud.idx=1; % index of current selected point
   ud.p=p;   % current poly
   ud.pdef=p;% default poly
   
   set(Hf,'NumberTitle','off',...
      'Name','MMPFIT',...
      'Color',Hfrgb,...
      'UserData',ud,...
      'ButtonDownFcn','mmpfit deselect',...
      'HandleVisibility','Callback')
   mmputptr(Hf)
   uiwait(Hf)
   ud=get(Hf,'UserData');
   pp=ud.p;
   close(Hf)
   
elseif nargin==1
   
   if ~ischar(x)
      error('Unknown Input Argument.')
   end
   switch x
   case 'data'
      [Hp,Hf]=gcbo; % handle of point selected and figure
      ud=get(Hf,'UserData'); % grab data
      Hps=findobj(ud.Hlpts,'Marker','square');
      set(Hps,'Marker','o','Color',ud.c1)
      set(Hp,'Marker','square','Color',ud.c3)
      x=get(Hp,'xdata'); % x of point selected
      ud.idx=find(x==ud.x); % find point in original data
      
      w=ud.weight(ud.idx);
      if w<101*eps; w=0; end
      set(ud.Huiw,'Enable','on',...
         'String',sprintf('%.3g',w))
      set(Hf,'UserData',ud)
   case 'revert'
      Hf=gcbf;
      ud=get(Hf,'UserData');
      ne=norm(ud.y-polyval(ud.pdef,ud.x));		
      set(ud.Hlpts,'Marker','o','Color',ud.c1)
      set(ud.Hlfit,'ydata',ud.yy);
      set(get(ud.Ha,'Title'),'String',['P(x) = ' mmp2str(ud.pdef)])
      set(get(ud.Ha,'Ylabel'),'String',['NORM(Error) = ' sprintf('%.4g',ne)])
      set(ud.Huio,'String',sprintf('%d',ud.defn))
      set(ud.Huiw,'String',' ','Enable','off')
      ud.n=ud.defn;
      ud.weight=ud.defweight;
      ud.p=ud.pdef;
      set(Hf,'UserData',ud)
      
   case 'deselect'
      Hf=gcbf;
      ud=get(Hf,'UserData');
      set(ud.Hlpts,'Marker','o','Color',ud.c1)
      set(ud.Huiw,'String',' ','Enable','off')
      
   case 'apply'
      % no operations required
      % simply puching the button forces the edit callback to act
      
   case 'done'
      uiresume(gcbf);
      
   case 'weight'
      Hf=gcbf;
      ud=get(Hf,'UserData');
      w=abs(eval(get(ud.Huiw,'String'),'1'));
      ud.weight(ud.idx)=max(w,100*eps);
      set(ud.Huiw,'String',sprintf('%.3g',w))
      ud.p=mmrwpfit(ud.x,ud.y,ud.n,ud.weight);
      ne=norm(ud.y-polyval(ud.p,ud.x));		
      set(ud.Hlfit,'ydata',polyval(ud.p,ud.xx));
      set(get(ud.Ha,'Title'),'String',['P(x) = ' mmp2str(ud.p)])
      set(get(ud.Ha,'Ylabel'),'String',['NORM(Error) = ' sprintf('%.4g',ne)])
      set(ud.Huiw,'Enable','off')
      set(ud.Hlpts,'Marker','o','Color',ud.c1)
      set(Hf,'UserData',ud)
      
   case 'order'
      Hf=gcbf;
      ud=get(Hf,'UserData');
      n=eval(get(ud.Huio,'String'),'1');
      ud.n=min(fix(abs(n)),ud.nmax);
      set(ud.Huio,'String',sprintf('%d',ud.n))
      ud.p=mmrwpfit(ud.x,ud.y,ud.n,ud.weight);
      ne=norm(ud.y-polyval(ud.p,ud.x));		
      set(ud.Hlfit,'ydata',polyval(ud.p,ud.xx));
      set(get(ud.Ha,'Title'),'String',['P(x) = ' mmp2str(ud.p)])
      set(get(ud.Ha,'Ylabel'),'String',['NORM(Error) = ' sprintf('%.4g',ne)])
      set(ud.Huiw,'Enable','off')
      set(Hf,'UserData',ud)
      
   otherwise
      error('Unknown Input Argument.')
   end
else
   error('Incorrect Number of Input Arguments.')
end
