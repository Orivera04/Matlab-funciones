function h=mmplotxx(x1,x2,y,s)
%MMPLOTXX Plot Data with Top and Bottom X-Axes. (MM)
% MMPLOTXX(X1,X2,Y,S) plots Y versus X1 and X2. S is an optional color and
% line/marker styles for the plotted lines.
% X1 appears across the bottom of the plot and X2 appears across the top.
% X1 and X2 must be vectors, but Y may be a matrix. The vectors X1 and X2
% must be the same length, with the (i)th element of each vector containing
% corresponding elements associated with the (i)th element of Y.
% Two axes objects are created. As a result, AXIS, ZOOM, LEGEND, and SUBPLOT
% do not work as expected. TITLE('String') should be avoided as it will
% overwrite the top X-axis tick marks and label.
%
% MMPLOTXX('TopLabelString') places/changes the X-axis label for X2.
%
% H=MMPLOTXX(...) returns handles to the created lines or top X-axis label.
%
% See also MMPLOTYY

% Calls: mmget

% D.C. Hanselman, University of Maine, Orono, ME, 04469
% 1/28/99
% Mastering MATLAB 6, Prentice Hall, ISBN 0-13-019468-9

if nargin==1 %MMPLOTXX('TopLabelString')
   if ~ischar(x1)
      error('Top Label Must be a String.')
   end
   Hx=findobj(gcf,'Type','axes','Tag','MMPLOTXX');
   if isempty(Hx)
      error('An MMPLOTXX Axes Does Not Exist.')
   end
   Hx=get(Hx(1),'UserData');
   set(Hx,'String',x1)
   if nargout, h=Hx; end
   return
   
elseif nargin==3
   s='';
elseif nargin~=4
   error('Incorrect Number of Input Arguments.')
end
% construct plot
x1=x1(:);
x2=x2(:);
lenx1=length(x1);
lenx2=length(x2);
if lenx1~=lenx2
   error('X1 and X2 Must be the Same Length.')
end
if ~any(lenx1==size(y))
   error('Y Must Conform to X1 and X2.')
end

xmm=[min(x2) max(x2)];
plot(xmm,zeros(1,2)) % plot data to create top X-axis
Hf=gcf;
Ha2=gca;
set(Ha2,'XAxisLocation','top',...
   'TickDir','out',...
   'XGrid','off','YGrid','off','Box','off',...
   'Xlim',xmm,...
   'Ytick',[],...
   'HandleVisibility','CallBack',...
   'Units','Normal',...
   'Tag','MMPLOTXX2') % modify axes to hide in the back
p=get(Ha2,'Position');
p(2)=p(2)-.05; % nudge axes down just a bit
set(Ha2,'Position',p)


set(gcf,'Nextplot','add') % Hold Ha2
Ha1=axes('NextPlot','replacechildren','Box','on',...
   'Xlim',[min(x1) max(x1)],...
   'UserData',get(Ha2,'Xlabel'),...
   'Units','Normal',...
   'Position',p,...
   'Tag','MMPLOTXX');

Hl=plot(x1,y,s);
% Keep y data from scaling y-axis by x10^n, which messes up upper x-axis,
% move scaling factor out of the way under top y-axis tick mark
[ylim,ytick]=mmget(Ha1,'Ylim','YTick');
ex=max(abs(ylim));
ex=max(floor(log10(ex+(ex==0))));
if ex<-2 | ex>3 % must rescale y to avoid default scaling
   Hl=plot(x1,y/10^ex,s); % replotting data is easiest
   text('Clipping','off',... % place scaling where it fits
      'Color',get(Ha1,'YColor'),...
      'FontName',get(Ha1,'FontName'),...
      'FontUnits',get(Ha1,'FontUnits'),...
      'FontSize',get(Ha1,'FontSize'),...
      'HandleVisibility','off',...
      'HorizontalAlignment','right',...
      'Interpreter','tex',...
      'Units','normal',...
      'Position',[-.005 abs(ytick(end)-min(ylim))/abs(diff(ylim))-.015],...
      'String',sprintf('x10^{%d}',ex),...
      'VerticalAlignment','top');
end
text('Parent',Ha1,'Visible','off',... % hidden text object in front axes
   'HandleVisibility','off',...  % that deletes back axes when it disappears
   'DeleteFcn','delete(findobj(''Type'',''axes'',''Tag'',''MMPLOTXX2''))')

set([Ha1,Ha2,Hf],'NextPlot','replace') % turn hold off
if nargout, h=Hl; end
