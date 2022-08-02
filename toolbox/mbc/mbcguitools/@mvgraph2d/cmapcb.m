function cmapcb(gr)
%CMAPCB Callback function for the mvGraph2D object.
% Callback function for interactively changing colormap in image
% display of graph2d object.
%  
% Requires: UISETCOLORMAP.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:19:00 $

figh = get(gr.axes,'parent');

if strcmp(lower(get(figh,'selectiontype')),'open')
   set(figh,'pointer','watch');
   cmapnow = get(gr,'colormap');
   % pop up ui for colormap
   cmap=uisetcolormap(cmapnow,NaN);
   
   if cmap==0
      % User pressed cancel
      set(figh,'pointer','arrow');
      return
   end
   
   % Apply colormap to object
   set(gr,'colormap',cmap);
   set(figh,'pointer','arrow');
end
return