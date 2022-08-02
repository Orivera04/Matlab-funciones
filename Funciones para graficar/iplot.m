function H=iplot(Ha,x,y)
%IPLOT Incremental 2-D Line Plotting.
% IPLOT is a 2-D plotting routine intended to be called repeatedly inside
% an interative loop with each call updating the plot with additional data.
% This routine is much faster than repeatedly calling the standard PLOT
% function since it only adds the new data to the current plot.
%
% Ha = IPLOT(V) or IPLOT(Ha,V) where V = [Xmin Xmax Ymin Ymax] initializes
% IPLOT with the axis limits set by V. Ha is the axes handle where the plot
% is to appear. This initial call must appear before the iterative loop
% where data is incrementally added to the plot.
%
% IPLOT(Ha,x,Y) incrementally plots Y versus x on the axes having handle Ha.
% If x is a scalar and Y is a vector, one point at x on length(Y) lines are
% added to the plot. If x is a vector, Y must be a matrix having length(x)
% rows. In this case, length(x) points are added to size(Y,2) lines. The
% number of lines drawn, length(Y) or size(Y,2), must remain the same for
% each call.
%
% Hl = IPLOT(Ha) refreshes the entire plot after all data has been added
% and returns the handles to the lineseries objects created. This final
% call should appear after the iterative loop where incremental data was
% added.
%
% Because IPLOT requires specifying the axes handle Ha, multiple
% incremental plots can be created and updated independent of one another.
%
% Example:
%         Ha = IPLOT([0 100 -10 10]) % initialize with axis limits
%         for k = 1:500
%            % many lines of code implementing an algorithm
%            % ...
%            IPLOT(Ha,x(k),Y(:,k)) % update plot with latest computed data
%         end
%         IPLOT(Ha) % refresh entire plot after iterative updates are done
%
% See also PLOT, ODEPLOT.

% D.C. Hanselman, University of Maine, Orono, ME 04469
% MasteringMatlab@yahoo.com
% Mastering MATLAB 7
% 2007-06-01

if (nargin==1 && ~isscalar(Ha)) || ... % IPLOT(V) or IPLOT(Ha,V) Initialize
   (nargin==2 && isscalar(Ha) && ishandle(Ha) && numel(x)==4)

   if nargin == 1
      xlim=Ha(1:2);
      ylim=Ha(3:4);
      Ha=newplot;
   else
      xlim=x(1:2);
      ylim=x(3:4);
   end
   Hfig=ancestor(Ha,'figure');             % find figure parent
   set(Hfig,'BackingStore','off');         % speed up figure rendering
   set(Ha,'Xlim',[min(xlim) max(xlim)],... % set x-axis limits
          'Ylim',[min(ylim) max(ylim)],... % set y-axis limits
          'Box','on',...                   % turn box on
          'View',[0 90],...                % 2-D view
          'Nextplot','add',...             % turn hold on
          'Tag','IPLOT')                   % tag this plot
   xlabel(Ha,'Plot Initialized')           % provide feedback to user
   figure(Hfig)                            % bring figure to the front
   H=Ha;                                   % return axes handle
   
elseif nargin==3 && ishandle(Ha)                   % IPLOT(Ha,x,Y) add data
   
   if ~strcmp(get(Ha,'Tag'),'IPLOT')
      error('IPLOT:NotInitialized',...
            'IPLOT Must be Initialized Prio to Plotting Data.')
   end
   x=x(:);               % make x a column
   xlen=length(x);
   [yr,yc]=size(y);
   if xlen==1            % check for scalar data point
      y=reshape(y,1,[]);
      yr=1;
      yc=length(y);
   end
   if xlen~=yr
      error('IPLOT:IncorrectDimensions',...
            'length(x) = size(Y,1) Required.')
   end
   
   if ~isappdata(Ha,'hline')                           % first data to plot
      chunk=max(128,xlen);   % allocate data in chunks 
      xdata=zeros(chunk,1);  % to minimize memory reallocation
      ydata=zeros(chunk,yc);
      xdata(1:xlen)=x;       % poke in first data
      ydata(1:xlen,:)=y;
      xynum=xlen;            % index of last new data
      hline=zeros(yc,1);     % storage for line handles
      C=get(Ha,'ColorOrder');% honor line color order when drawing
      Clen=size(C,1);
      for k=1:yc             % create one line for each column in y
         hline(k)=line('xdata',x,'ydata',y(:,k),...
            'Erasemode','none',...
            'Color',C(rem(k-1,Clen)+1,:));
      end
      xlabel(Ha,'Plotting Incremental Data...') % provide feedback to user
      setappdata(Ha,'xdata',xdata) % store all data for future calls
      setappdata(Ha,'ydata',ydata)
      setappdata(Ha,'xynum',xynum)
      setappdata(Ha,'hline',hline)
      
   else                                               % add to plotted data
      xdata=getappdata(Ha,'xdata'); % get previous data
      ydata=getappdata(Ha,'ydata');
      xynum=getappdata(Ha,'xynum');
      hline=getappdata(Ha,'hline');
      xtotal=length(xdata);
      if xynum+yr > xtotal % another chunk of memory is needed
         chunk=max(128,xlen);
         xdata=[xdata; zeros(chunk,1)];  %#ok
         ydata=[ydata; zeros(chunk,yc)]; %#ok
      end
      if yc~=size(ydata,2)
         error('IPLOT:InputDataError',...
               'size(Y,2) Must Stay the Same From Call to Call.')
      end
      idx=xynum:xynum+yr; % poke in newest data
      xdata(idx(2:end))=x;
      ydata(idx(2:end),:)=y;
      
      for k=1:yc % just draw new pieces without erasing old data
         set(hline(k),'xdata',xdata(idx),'ydata',ydata(idx,k))
      end
      setappdata(Ha,'xdata',xdata) % store data for future calls
      setappdata(Ha,'ydata',ydata)
      setappdata(Ha,'xynum',idx(end))

   end

elseif nargin == 1 && ishandle(Ha)               % IPLOT(Ha) wrap things up
   
   Hfig=ancestor(Ha,'figure');
   color=get(Hfig,'color');
   set(Hfig,'BackingStore','on',...
            'Color',[0 1 2]/pi,'Color',color) % force refresh of figure
   xdata=getappdata(Ha,'xdata'); % get data for final plot
   rmappdata(Ha,'xdata')         % get rid of stored data
   ydata=getappdata(Ha,'ydata');
   rmappdata(Ha,'ydata')
   xynum=getappdata(Ha,'xynum');
   rmappdata(Ha,'xynum')
   hline=getappdata(Ha,'hline');
   rmappdata(Ha,'hline')
   delete(hline) % get rid of incremental lines
   set(Ha,'NextPlot','Replace',...                % turn hold off
          'XLimMode','auto','YLimMode','auto',... % reset axis limits
          'Tag','')                               % remove tag
   Hl=plot(xdata(1:xynum),ydata(1:xynum,:));      % use plot for final pass
   xlabel(Ha,'Plot Completed') % provide user feedback
   if nargout==1 % return lineseries handles if requested
      H=Hl;
   end
   
else
   error('IPLOT:rhs','Unknown Input Arguments.')
end
drawnow % force update of plot
