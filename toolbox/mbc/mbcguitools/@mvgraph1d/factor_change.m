function factor_change(gr)
% GRAPH1D/FACTOR_CHANGE   Graph1D callback function.
%   Callback function for the graph1d object.  This is not designed
%   to be used from the command line.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:18:49 $

%  Date: 16/9/1999

pr_graphlim(gr);
% put data into line object
pr_plot(gr);

% update histogram if needed
if get(gr.hist.axes,'userdata')
   pr_histplot(gr);
end
