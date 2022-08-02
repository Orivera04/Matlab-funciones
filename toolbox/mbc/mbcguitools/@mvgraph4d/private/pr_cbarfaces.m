function pr_cbarfaces(pt,cmap)
%PR_CBARFACES   Private function 
%   Private function to set up the colorbar faces to the number of
%   colormap entries and set up cdata nicely.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:20:07 $

n=size(cmap,1);

verty=[0.5:1:(n+0.5)];
vertx=zeros(size(verty));
verty=[verty;verty];
vertx=[vertx;(vertx+1)];
vertz=repmat(-1,size(verty));
vertx=vertx(:);
verty=verty(:);
vertz=vertz(:);

faces=[[1:2:(2*n-1)]' , [2:2:(2*n)]' , [3:2:(2*n+1)]' , [4:2:(2*n+2)]'];
faces=faces(:,[1 2 4 3]);

set(pt,'vertices',[vertx verty vertz],...
   'faces',faces,...
   'facevertexcdata',cmap);
