function clear(hnd,varargin)
%TABLE/CLEAR   Reinitialise table object
%   Clear deletes all information held in a table object
%   and reinitialises the object.  Note that the number of
%   fixed rows and columns is reset to zero and the zeroindex
%   is set to [1 1].

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.3.2.2 $  $Date: 2004/02/09 07:32:28 $


% first shut off any editing which is in progress
cellcb(hnd,'tempeditoff');

% varargin{1} is a flag indicating whether a global copy of fud is available
if length(varargin)>0 & varargin{1}
   global fud
else
   fud=get(hnd.frame.handle,'Userdata');
   set(hnd.frame.handle,'Userdata',[]);
end
% First trash actual objects
hndls=[fud.cells.fcornerhandles(:);...
      fud.cells.ftophandles(:);...
      fud.cells.flefthandles(:);...
      fud.cells.shandles(:)];

% Note that hndls may have zeros in it...
delete(hndls(hndls~=0));

% Now reset scrollbars
set([fud.vslider.handle;fud.hslider.handle;fud.dslider.handle],'visible','off');

% Reset some data
fud.zeroindex=[1 1];
fud.rows.fixed=0;
fud.cols.fixed=0;
fud.rows.number=0;
fud.cols.number=0;

% Remove cell data
fud.cells.shandles=[];
fud.cells.flefthandles=[];
fud.cells.ftophandles=[];
fud.cells.fcornerhandles=[];
fud.cells.exist=false(0,0);
fud.cells.userprops=false(0,0);
fud.cells.uiprops={};
fud.cells.ctype=[];
fud.cells.positions=[];
fud.cells.visible={};
fud.cells.value=[];
fud.cells.format={};
fud.cells.string={};

if length(varargin)==0
   % Reset data into table
   set(hnd.frame.handle,'Userdata',fud);
elseif ~varargin{1}
   % Reset data into table
   set(hnd.frame.handle,'Userdata',fud);
end
return



