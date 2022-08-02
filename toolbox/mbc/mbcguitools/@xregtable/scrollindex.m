function [realrow, realcol]=scrollindex(tbl,row,col)
% SCROLLINDEX  Convert scroll region object indices
%
%   [R,C]=SCROLLINDEX(T,R,C) converts the row and col numbers R and C, 
%   as taken from th table T's scroll object's userdata, to a "real" 
%   row and col index into the table data.  The new values take into
%   account the scrollbar offsets and the zeroindex setting and any
%   fixed rows and columns.
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:33:45 $

% Created 10/5/2000

fud=get(tbl.frame.handle,'userdata');

vslud=get(tbl.vslider.handle,'userdata');
hslud=get(tbl.hslider.handle,'userdata');
vslval=abs(get(tbl.vslider.handle,'value'));
hslval=get(tbl.hslider.handle,'value');

voff=vslud.steps(vslval,1);
hoff=hslud.steps(hslval,1);

realrow = row + voff - fud.zeroindex(1);
realcol = col + hoff - fud.zeroindex(2);
return
