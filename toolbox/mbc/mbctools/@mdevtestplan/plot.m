function plot(Tp,ah,SNo,ydata)
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.3.2.2 $  $Date: 2004/02/09 08:08:11 $

% Get the Ydata 
%ud=get(findobj('Tag','mvModelBrowser'),'user');
%ydata=ud.Data.info;
if isa(ydata,'pointer')
   ydata= ydata.info;
end

% Get the Monitor Details
yvals=Tp.Monitor.values;
xdata=Tp.Monitor.Xdata;

if ~isempty(xdata)
   % X data
	Xall= ydata(:,xdata);
   X=ydata(:,xdata,SNo);
	
else
   % default X to indices
	Xall= 1:size(ydata,3);
	if length(Tp.DesignDev)==1
		X= SNo;
	else
		X= 1:size(ydata(:,:,SNo),1);
	end
end

% Error checking for numbers of axes vs. number of variables
if length(ah)~=length(yvals)
   error('Number of variables not equal to number of axes');
end

% Plot the data into the axes
for i=1:length(ah)
	if length(Tp.DesignDev)==1
		% one stage monitor plot
		plot(Xall,ydata(:,yvals(i)),'bo',X,ydata(:,yvals(i),SNo),'r*',...
			'bd',...
			'parent',ah(i),...
			'LineWidth',2);
	else
		% two stage monitor plot
		plot(X,ydata(:,yvals(i),SNo),'o',...
			'bd',...
			'parent',ah(i),...
			'LineWidth',2);
	end
end

% Sort out the xlabels
if ~isempty(ah)
   rc= get(get(ah(1),'ylabel'),'userdata');
   if isempty(rc)
      rc=0;
   end
end
