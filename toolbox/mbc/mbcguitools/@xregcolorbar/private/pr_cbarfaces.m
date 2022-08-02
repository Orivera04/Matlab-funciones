function pr_cbarfaces(pt,cmap,gr)
%GRAPH4D/PRIVATE/PR_CBARFACES   Private function 
%   Private function to set up the colorbar faces to the number of
%   colormap entries and set up cdata nicely.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:31:43 $

n=size(cmap,1);
verty=[0.5:1:(n+0.5)];

if get(gr.colorbar.userange,'value')
    ud=get(gr.ctext,'userdata');
    if strcmp(ud.limitstyle,'color') | strcmp(ud.limitstyle,'limit')
        clim=ud.clim;
        cmax=get(gr.colorbar.maxrange,'userdata');
        cmin=get(gr.colorbar.minrange,'userdata');
        % convert to actual units
        ylim=get(gr.colorbar.axes,'ylim');
        cmax=clim(1)+(clim(2)-clim(1))*(cmax-ylim(1))/(ylim(2)-ylim(1));
        cmin=clim(1)+(clim(2)-clim(1))*(cmin-ylim(1))/(ylim(2)-ylim(1));
        
        sf = (cmax - cmin)/(clim(2)-clim(1));
        off = (cmin - clim(1))/(clim(2)-clim(1))*n;
        
        verty = (verty * sf) + off;
        verty(1) = 0.5; verty(end) = n+0.5;
    end
end
vertx=zeros(size(verty));
verty=[verty;verty];
vertx=[vertx;(vertx+1)];
vertz=zeros(size(verty));
vertx=vertx(:);
verty=verty(:);
vertz=vertz(:);

faces=[[1:2:(2*n-1)]' , [2:2:(2*n)]' , [3:2:(2*n+1)]' , [4:2:(2*n+2)]'];
faces=faces(:,[1 2 4 3]);

set(pt,'vertices',[vertx verty vertz],...
   'faces',faces,...
   'facevertexcdata',cmap);
