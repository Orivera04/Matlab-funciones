function createscrollcells
%CREATESCROLLCELLS Private function
%
%  Private function to create the correct number of cells to fill the fully
%  scrolling window.  Operates on the global table userdata that is in
%  memory.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:32:55 $

global fud

% Need to work out how many cells need to be created
% Extent numbers are the size of the viewing window: from
% the fixed rows/cols to the sliders if they are on
extenth=fud.position(3)-fud.frame.hborder(1)-fud.frame.hborder(2)...
   -fud.cols.fixed.*(fud.cols.size+fud.cols.spacing);
if strcmp(fud.vslider.visible,'on')
   extenth=extenth-fud.vslider.width;
end

extentv=fud.position(4)-fud.frame.vborder(1)-fud.frame.vborder(2)...
   -fud.rows.fixed*(fud.rows.size+fud.rows.spacing);
if strcmp(fud.hslider.visible,'on')
   extentv=extentv-fud.hslider.width;
end


nr=floor((extentv+fud.rows.spacing)/(fud.rows.size+fud.rows.spacing));
nc=floor((extenth+fud.cols.spacing)/(fud.cols.size+fud.cols.spacing));

% Quicker way of doing things: only create/delete necessary cells.

len=nr*nc;
hndls=fud.cells.shandles';
hndls=hndls(:);
oldlen=length(hndls);

if len<oldlen
   delete(hndls(len+1:end));
   hndls=hndls(1:len);
elseif len>oldlen
   hndls(oldlen+1:len)=0;    % Expand vector in one go
   for n=oldlen+1:len
      hndls(n)=xreguicontrol('parent',fud.parent, 'visible', 'off');
   end
   % set callback function on new cells
   set(hndls(oldlen+1:end),'Callback',...
      ['cellcb(get(' sprintf('%20.15f',fud.objecthandle) ',''Userdata''));']);
end

hndls=reshape(hndls,nc,nr);
hndls=hndls';

% Create userdata structure for each cell
cud.parent=fud.frame.handle;
cud.type='scroll';
for x=1:nr
   for y=1:nc
      cud.row=x;
      cud.col=y;
      set(hndls(x,y),'Userdata',cud);
   end
end

fud.cells.shandles=hndls;
