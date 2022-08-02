function buttons = buttonv(loc,intvec,start,callback,arg1,arg2,arg3,arg4)
%BUTTONV Vector of buttons.  Used by CENSUS demo.
%	BUTTONV([xmin ymin],k1:k2,ks,'callback', ... )
%	The lower left corner is [xmin ymin] in figure normalized coordinates.
%	The buttons are labeled with integers k1:k2.
%	Initially, button ks is highlighted.
%	After each button push, a variable named button is set to the
%	button index and the string 'callback' is evaluated.
%	Up to 3 additional optional arguments are extra button labels.

%	Copyright (c) 1984-94 by The MathWorks, Inc.

del = 12/256;
n = 0;
for k = intvec
   n = n+1;
   buttons(n) = uicontrol('style','push','string',int2str(k), ...
     'units','normal','pos',[loc(1)+k*del loc(2) del del], ...
     'call',['button = ' int2str(n) '; ' callback]);
end
for k = 1:nargin-4
   n = n+1;
   buttons(n) = uicontrol('style','push','string',eval(['arg' int2str(k)]), ...
     'units','normal','pos',[loc(1)+2*(k-1)*del loc(2)-1.5*del 2*del del], ...
     'call',['button = ' int2str(n) '; ' callback]);
end
set(buttons(find(intvec==start)),'back',[.9 .6 .3])
