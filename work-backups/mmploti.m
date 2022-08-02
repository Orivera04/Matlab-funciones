function H=mmploti(x,y)
%MMPLOTI Incremental 2D Line Plotting.
% Ha=MMPLOTI(V) initializes a 2D plot for future plotting
% by using the axis limits given in V=[Xmin Xmax Ymin Ymax].
% Ha is a handle to the created axes.
%
% Hl=MMPLOTI(x,Y) plots Y versus x, appending data to any
% prior calls. x is a vector and Y is a vector or column
% oriented data matrix having as many rows as length(x).
% Hl contains handles to the created or appended lines.
%
% MMPLOTI('done') or MMPLOTI done  refreshes the final plot,
% turns hold off and auto scales the axis.

% D.C. Hanselman, University of Maine, Orono, ME 04469
% 7/12/96, revised 9/11/96, v5: 1/14/97
% Mastering MATLAB 5, Prentice Hall, ISBN 0-13-858366-8
% Mastering MATLAB 6, Prentice Hall, ISBN 0-13-019468-9

global MMPLOTI_X MMPLOTI_Y MMPLOTI_K

if ischar(x)
   if x(1)=='d'  % done
      Ha=findobj('Tag','MMPLOTI');
      if isempty(Ha), error('No MMPLOTI plot exists.'), end
      Hf=get(Ha,'Parent');
      set(Hf,'BackingStore','on',...
         'color',[0 1 2]/pi,'color',get(Hf,'color')) % refresh
      Hl=findobj(Ha(1),'Type','line');
      for i=1:length(Hl)  % replot entire data set
         Hli=findobj(Hl,'flat','Tag',sprintf('%.0f',i));
         set(Hli,'xdata',MMPLOTI_X(1:MMPLOTI_K),...
            'ydata',MMPLOTI_Y(1:MMPLOTI_K,i),...
            'EraseMode','Normal')
      end
      set(Ha(1),'NextPlot','Replace',...   % hold off
         'XLimMode','auto','YLimMode','auto') % auto scale axis
      xlabel('Done')
      MMPLOTI_X=[]; MMPLOTI_Y=[]; MMPLOTI_K=[];
      if nargout, H=Ha(1); end
   end
   
elseif nargin==1  % initialize plotting surface
   Ha=newplot;
   Hf=get(Ha,'Parent');
   set(Hf,'BackingStore','off')
   delete(findobj(Ha,'Type','line'))  % delete old plot if there 
   set(Ha,'Xlim',sort(x(1:2)),'Ylim',sort(x(3:4)),...
      'Box','on',...
      'View',[0 90],...
      'NextPlot','add',...
      'Tag','MMPLOTI')
   xlabel('Initialized')
   figure(Hf)  % bring figure to front for viewing
   if nargout, H=Ha; end
   
else  % there's data to plot
   Ha=findobj('Tag','MMPLOTI');
   if isempty(Ha)
      error('Initialize Plot Axes Before Plotting Data.')
   end
   x=x(:); xlen=length(x);
   [ry,cy]=size(y);
   if xlen==1 & ry>1, y=y.'; [ry,cy]=size(y); end
   if xlen~=ry, error('length(x) and Rows of Y Must Agree.'), end
   Hl=findobj(Ha(1),'Type','line');
   Hlen=length(Hl);
   
   if Hlen==0  % no current data, start things up
      chunk=max(128,ry);
      MMPLOTI_X=zeros(chunk,1);  % store data for final replot
      MMPLOTI_Y=zeros(chunk,cy); % allocate chunks for speed
      MMPLOTI_X(1:xlen)=x;
      MMPLOTI_Y(1:xlen,:)=y;
      MMPLOTI_K=xlen; % index to last filled data point
      C=get(Ha(1),'ColorOrder');Clen=size(C,1);
      Hl=zeros(cy,1);
      for i=1:cy
         Hl(i)=line('xdata',x,'ydata',y(:,i),...
            'EraseMode','none',...
            'Color',C(rem(i-1,Clen)+1,:),...
            'Tag',sprintf('%.0f',i));
      end
      xlabel('Plotting . . .')
   elseif Hlen~=cy
      error('Number of Lines and Columns in Y must Agree.')
   else     % add data to existing plot
      Xlen=length(MMPLOTI_X);
      if MMPLOTI_K+ry>Xlen  % allocate more space for data
         chunk=max(128,ry);
         MMPLOTI_X=[MMPLOTI_X;zeros(chunk,1)];
         MMPLOTI_Y=[MMPLOTI_Y;zeros(chunk,cy)];
      end
      idx=MMPLOTI_K+1:MMPLOTI_K+xlen;
      MMPLOTI_X(idx)=x;
      MMPLOTI_Y(idx,:)=y;
      idx=[MMPLOTI_K idx]; % plot from prior point thru new ones
      for i=1:Hlen
         Hli=findobj(Hl,'flat','Tag',sprintf('%.0f',i));
         set(Hli,'xdata',MMPLOTI_X(idx),...
            'ydata',MMPLOTI_Y(idx,i))
      end
      MMPLOTI_K=MMPLOTI_K+xlen; % index of last filled data
   end
   if nargout,H=Hl;end
end
drawnow  % force screen update
