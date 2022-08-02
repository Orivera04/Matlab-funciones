function pr_graphlim(gr)
%PR_GRAPHLIM
%  Private function for sorting out correct limits on axes and colorbar.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:19:37 $

ud = gr.DataPointer.info;
tp = ud.type;
data = ud.data;

% axes limits depend on type.
switch lower(tp)
case 'graph'
   % normal limits
   if ~isempty(data)
      minmax = ud.limits;
      % check minmax for correct size
      if length(minmax)<size(data,2)
         minmax(end+1:size(data,2))={0};
      elseif length(minmax)>size(data,2)
         minmax(size(data,2)+1:end)=[];
      end
      
      xval=get(gr.xfactor,'value');
      if ischar(minmax{xval}) & strcmp(minmax{xval},'auto')
         xmn=[];
         xmx=[];
      elseif all(minmax{xval}==0)
         xmn=min(data(:,xval));
         xmx=max(data(:,xval));
      else
         xmn=min(minmax{xval});
         xmx=max(minmax{xval});
      end
      
      yval=get(gr.yfactor,'value');
      if ischar(minmax{yval}) & strcmp(minmax{yval},'auto')
         ymn=[];
         ymx=[];
      elseif all(minmax{yval}==0)
         ymn=min(data(:,yval));
         ymx=max(data(:,yval));
      else
         ymn=min(minmax{yval});
         ymx=max(minmax{yval});
      end
      
   else
      xmn=0;ymn=0;xmx=1;ymx=1;
   end
   
case 'sparse'
   xmn=0.5;ymn=0.5;
   xmx=size(data,2)+0.5;
   ymx=size(data,1)+0.5;
   
case 'image'
   xmn=0.5;ymn=0.5;
   xmx=size(data,2)+0.5;
   ymx=size(data,1)+0.5;
   
end

% do sanity check on min,max

if ~isempty(xmn) & xmn>=xmx
   if xmn==0
      xmn=-0.01;
      xmx=0.01;
   else
      xmn=(1-sign(xmn).*0.01)*xmx;
      xmx=(1+sign(xmx).*0.01)*xmx;
   end
end
if ~isempty(ymn) & ymn>=ymx
   if ymn==0
      ymn=-0.01;
      ymx=0.01;
   else
      ymn=(1-sign(ymn).*0.01)*ymx;
      ymx=(1+sign(ymx).*0.01)*ymx;
   end
end

% check for NaN's
if ~any(isnan([xmn,xmx]))
   if ~isempty(xmn)
      % push min and max apart a smidgeon to fix an R12 axes bug
      delt=(xmx-xmn).*1e-10;
      xmn=xmn-delt;
      xmx=xmx+delt;
      set(gr.axes,'xlim',real([xmn xmx]));
   else
      set(gr.axes,'xlimmode','auto');
   end
end
if ~any(isnan([ymn,ymx]))
   if ~isempty(ymn)
      % push min and max apart a smidgeon to fix an R12 axes bug
      delt=(ymx-ymn).*1e-10;
      ymn=ymn-delt;
      ymx=ymx+delt;
      set(gr.axes,'ylim',real([ymn ymx]));
   else
      set(gr.axes,'ylimmode','auto');
   end
end


% clim determined by absolute min/max of data
if ~isempty(data)
   data=data(~isinf(data));
   cmn=min(data(:));
   cmx=max(data(:));
else
   cmn=0;cmx=1;
end
if cmn>=cmx
   if cmn==0
      cmn=-0.01;
      cmx=0.01;
   else
      cmn=0.99*cmx;
      cmx=1.01*cmx;
   end
end

% Do colorbar ticklabels
clim=real([cmn cmx]);
xlim=get(gr.colorbar.axes,'xlim');
if ~any(isnan(clim))
   set(gr.axes,'clim',clim);
end
labpoints=get(gr.colorbar.axes,'xtick');
actpoints=clim(1)+(labpoints-0.5).*(clim(2)-clim(1))./(xlim(2)-xlim(1));
actpoints=cellstr(num2str(actpoints','%3.2f'));
set(gr.colorbar.axes,'xticklabel',actpoints);
return
