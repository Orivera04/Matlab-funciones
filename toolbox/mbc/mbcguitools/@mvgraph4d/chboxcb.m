function chboxcb(gr)
%CHBOXCB   Callback function
%
%   Callback function for the graph4d object

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:19:39 $


% Need to change visible state of lines
val=get(gr.colorbar.userange,'value');
switch val
case 0
   vis='off';
case 1
   vis='on';
end

set([gr.colorbar.minrange;gr.colorbar.midrange;gr.colorbar.maxrange],'visible',vis);

pr_plot(gr);
return