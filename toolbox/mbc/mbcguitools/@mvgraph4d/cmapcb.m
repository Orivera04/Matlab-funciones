function cmapcb(gr)
%CMAPCB   Callback function
% callback function for interactively chnaging colormap in image
% display of graph3d object.  Uses UISETCOLORMAP.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:19:40 $


figh=get(gr.axes,'parent');

% look for a double click
if strcmp(lower(get(figh,'selectiontype')),'open')
   set(figh,'pointer','watch');
   
   cmapnow=get(gr.colorbar.bar,'facevertexcdata');
   cmap=uisetcolormap(cmapnow,NaN);
   
   if cmap==0
      % User pressed cancel
      set(figh,'pointer','arrow');
      return
   end
   
   % Apply colormap to object
   set(gr,'colormap',cmap);
   set(figh,'pointer','arrow');
   figure(figh);
end
return