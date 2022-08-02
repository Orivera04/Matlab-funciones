function selectbox(src,ev,nd,cb)
%SELECTBOX

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.4.2.2 $  $Date: 2004/02/09 08:22:57 $

seltype=get(gcbf,'selectiontype');

switch seltype
case 'normal'
   % first make sure that there is no other
   % button down function defined
   set(gcbf,'windowbuttondownfcn','',...
      'windowbuttonmotionfcn','');
   i_zoom(cb);
case {'open','extend'}
    mv_zoom;
end
%----------------------------------------------------------
% function i_zoom
%----------------------------------------------------------
function i_zoom(cb)

myax = gca;
pt=get(myax,'currentpoint');
pt=pt(1,1:2);

% get the axes position and 
oldunits=get(myax,'units');
set(myax,'units','pixels');
apos=get(myax,'pos');
set(myax,'units',oldunits);
xlim=get(myax,'xlim');
xlen=xlim(2)-xlim(1);
ylim=get(myax,'ylim');
ylen=ylim(2)-ylim(1);

% get ratios to convert pt to pixel units.
xratio=xlen/apos(3);
yratio=ylen/apos(4);

% check for a shift in x or y
xshift=(0-xlim(1));
yshift=(0-ylim(1));

% convert pt into pixels from bottom left of figure.
pt=apos(1:2)+[((pt(1)+xshift)/xratio) ((pt(2)+yshift)/yratio)];

% draw the rubber band box
frect=rbbox([pt(1) pt(2) 0 0 ]);
frect(1:2)=frect(1:2)-apos(1:2);
newxlim=sort(([frect(1) frect(1)+frect(3)]).*xratio)-xshift;
newylim=sort(([frect(2) frect(2)+frect(4)]).*yratio)-yshift;
% Ensure box remains within axis
newxlim(2) = min(newxlim(2),xlim(2));
newxlim(1) = max(newxlim(1),xlim(1));
newylim(2) = min(newylim(2),ylim(2));
newylim(1) = max(newylim(1),ylim(1));

if diff(newxlim)>0 & diff(newylim)>0 
   % update the axes limits
   if iscell(cb)
       xregcallback(cb)
   else
       xregcallback({cb,newxlim,newylim});
   end
end  

