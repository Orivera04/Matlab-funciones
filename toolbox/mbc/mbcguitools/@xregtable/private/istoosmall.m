function [ok,allowed]=istoosmall(hnd,varargin)
% ISTOOSMALL
%
%  OK=ISTOOSMALL(T) returns 1 if T is too small to sensibly
%  be rendered
%  OK=ISTOOSMALL(T,FUD) where FUD is a flag indicating whether
%  there is a global copy of the table data available
%  OK=ISTOOSMALL(T,FUD,POS) checks the new position, POS
%  OK=ISTOOSMALL(T,FUD,POS,FIX) where FIX is a 2-element vector
%  containing the number of fixed rows and columns respectively.
%
%  [OK,ALLOWED]=ISTOOSMALL(T,....) returns a valid size vector in
%  ALLOWED.
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:33:01 $

% Created 19/1/2000

% use a global fud if available
if length(varargin)>0 & varargin{1}
   global fud
else
   global fud
   fud=get(hnd.frame.handle,'UserData');
   set(hnd.frame.handle,'UserData',[]);
end

if nargin>2
   pos=varargin{2};
else
   pos=fud.position;
end
if nargin>3
   fx=varargin{3};
else
   fx=[fud.rows.fixed fud.cols.fixed];
end

allowed=pos;

rendarea(1)=pos(3)-sum(fud.frame.hborder)-fud.vslider.width-(fx(2).*(fud.cols.size+fud.cols.spacing));
rendarea(2)=pos(4)-sum(fud.frame.vborder)-fud.hslider.width-(fx(1).*(fud.rows.size+fud.rows.spacing));

if all(size(fud.cells.shandles))
   szneeded(1)=(fud.cols.size+fud.cols.spacing+1);
   szneeded(2)=(fud.rows.size+fud.rows.spacing+1);
else
   szneeded=[0 0];
end

if (rendarea(1)<szneeded(1)) ...
   ok=1;
   allowed(3)=(pos(3)-rendarea(1)+szneeded(1))+1;
else
   ok=0;
end
if  (rendarea(2)<szneeded(2))
   ok=1;
   allowed(4)=(pos(4)-rendarea(2)+szneeded(2))+1;
else
   ok=(ok | 0);
end 


if nargin==1
   % Reset data into table
   set(hnd.frame.handle,'Userdata',fud);
   clear global fud
elseif ~varargin{1}
   % Reset data into table
   set(hnd.frame.handle,'Userdata',fud);
   clear global fud
end

return