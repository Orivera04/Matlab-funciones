function pr_graphlim(gr)
%XREGCOLORBAR/PRIVATE/PR_GRAPHLIM   Private function
%   Private function for sorting out correct limits on colorbar.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:31:44 $

% Mungo Stacy 
%  15/06/01

% redo limits on axes and colourbar
data=get(gr.colorbar.frame1,'userdata');
if ~isempty(data)

    minmax = [0 0];
   cval=get(gr.cfactor,'value');
   if all(minmax==0)
      cmn=min(data(:,cval));
      cmx=max(data(:,cval));
   else
      cmn=min(minmax);
      cmx=max(minmax);
   end
   
   if cmn>=cmx
      if cmn==0
         cmn=-0.01;
         cmx=0.01;
      else
         cmn=(1-sign(cmn).*0.01)*cmx;
         cmx=(1+sign(cmx).*0.01)*cmx;
      end
   end 
   % Do colorbar ticklabels
   clim=[cmn cmx];
   ud = get(gr.ctext,'userdata');
   ud.clim = clim;
   ylim=get(gr.colorbar.axes,'ylim');
   set(gr.ctext,'userdata',ud);
   labpoints=get(gr.colorbar.axes,'ytick');
   actpoints=clim(1)+(labpoints-0.5).*(cmx-cmn)./(ylim(2)-ylim(1));
   actpoints=cellstr(num2str(actpoints','%3.2f'));
   set(gr.colorbar.axes,'yticklabel',actpoints);
   
end
return

