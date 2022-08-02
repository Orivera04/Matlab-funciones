function pr_graphlim(gr)
%GRAPH1d/PRIVATE/PR_GRAPHLIM
%   Private function for sorting out correct limits on axes and colorbar.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:19:17 $

%  Date: 16/9/1999


% redo limits on axes and colourbar
data=get(gr.line,'userdata');
if ~isempty(data)
   minmax=get(gr.factortext,'userdata');
   % check minmax for correct size
   if length(minmax)<size(data,2)
      minmax(end+1:size(data,2))={0};
   elseif length(minmax)>size(data,2)
      minmax(size(data,2)+1:end)=[];
   end
   
   xval=get(gr.factorsel,'value');
   if all(minmax{xval}==0)
      xmn=min(data(:,xval));
      xmx=max(data(:,xval));
   else
      xmn=min(minmax{xval});
      xmx=max(minmax{xval});
   end
   
   % do sanity check on min,max
   if xmn>=xmx
      if xmn==0
         xmn=-0.01;
         xmx=0.01;
      else
         xmn=(1-sign(xmn).*0.01)*xmx;
         xmx=(1+sign(xmx).*0.01)*xmx;
      end
   end
   set(gr.axes,'xlim',[xmn xmx]);
      
end
return
