function pr_graphlim(gr)
%PR_GRAPHLIM Private Function
%  Private function for sorting out correct limits on axes and colorbar.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:19:57 $

% redo limits on axes and colourbar
ud = gr.DataPointer.info;
data = ud.data;
if ~isempty(data)
   minmax = ud.limits;
   % check minmax for correct size
   if length(minmax)<size(data,2)
      minmax(end+1:size(data,2))={0};
   elseif length(minmax)>size(data,2)
      minmax(size(data,2)+1:end)=[];
   end
   
   xval=get(gr.xfactor,'value');
   if all(minmax{xval}==0)
      xmn=min(data(:,xval));
      xmx=max(data(:,xval));
   else
      xmn=min(minmax{xval});
      xmx=max(minmax{xval});
   end
   
   yval=get(gr.yfactor,'value');
   if all(minmax{yval}==0)
      ymn=min(data(:,yval));
      ymx=max(data(:,yval));
   else
      ymn=min(minmax{yval});
      ymx=max(minmax{yval});
   end
   
   zval=get(gr.zfactor,'value');
   if all(minmax{zval}==0)
      zmn=min(data(:,zval));
      zmx=max(data(:,zval));
   else
      zmn=min(minmax{zval});
      zmx=max(minmax{zval});
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
   if ymn>=ymx
      if ymn==0
         ymn=-0.01;
         ymx=0.01;
      else
         ymn=(1-sign(ymn).*0.01)*ymx;
         ymx=(1+sign(ymx).*0.01)*ymx;
      end
   end
   if zmn>=zmx
      if zmn==0
         zmn=-0.01;
         zmx=0.01;
      else
         zmn=(1-sign(zmn).*0.01)*zmx;
         zmx=(1+sign(zmx).*0.01)*zmx;
      end
   end  

   set(gr.axes,{'xlim','ylim','zlim'},{[xmn xmx],[ymn ymx],[zmn zmx]});
   
   cmn=zmn;
   cmx=zmx;
   
   % Do colorbar ticklabels
   clim=[cmn cmx];
   ylim=get(gr.colorbar.axes,'ylim');
   set(gr.axes,'clim',clim);
   labpoints=get(gr.colorbar.axes,'ytick');
   actpoints=clim(1)+(labpoints-0.5).*(cmx-cmn)./(ylim(2)-ylim(1));
   actpoints=cellstr(num2str(actpoints','%3.2f'));
   set(gr.colorbar.axes,'yticklabel',actpoints);
end
return