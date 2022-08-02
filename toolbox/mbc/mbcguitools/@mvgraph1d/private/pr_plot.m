function pr_plot(gr)
%GRAPH1D/PRIVATE/PR_PLOT
%   This is a private graph1d plotting function.  

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:19:19 $

%  Date: 16/9/1999

data=get(gr.line,'userdata');
if ~isempty(data)
   xval=get(gr.factorsel,'value');
   xdata=data(:,xval);
   
   set(gr.line,'xdata',xdata,...
      'ydata',zeros(1,length(xdata)));
else
   % empty out the line plot data
   set(gr.line,'xdata',[],...
      'ydata',[]);
end
return

