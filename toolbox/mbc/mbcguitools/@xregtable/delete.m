function delete(hnd,varargin)
%TABLE/DELETE
%   DELETE(H) deletes the table with handle H
%   Note that this removes all HG objects that are
%   associated with H, but H is still seen by MATLAB
%   as a valid object.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.4.2.2 $  $Date: 2004/02/09 07:32:30 $



% end emulated edit callbacks if necessary
cellcb(hnd,'tempeditoff');

% Use global data if available (from table/get)
if length(varargin)>0 & varargin{1}
   global fud
else
   fud=get(hnd.frame.handle,'Userdata');
   set(hnd.frame.handle,'Userdata',[]);
end
hndls1=[fud.cells.fcornerhandles(:)];
hndls2=[fud.cells.ftophandles(:)];
hndls3=[fud.cells.flefthandles(:)];
hndls4=[fud.cells.shandles(:)];
hndls=[hndls1;hndls2;hndls3;hndls4];
hndls=hndls(hndls~=0);
delete([hndls(:);hnd.frame.handle;hnd.vslider.handle;hnd.hslider.handle;fud.objecthandle;hnd.dslider.handle]);

return