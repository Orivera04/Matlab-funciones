function out=get(hnd,varargin)
%TABLE/GET   Get interface for table object
%   GET(TBL,'Property') returns the value of the table Property
%   (or values, if Property is a cell array).  Execute get(TBL) to
%   see a full list of available properties.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.3.2.2 $  $Date: 2004/02/09 07:32:32 $


%   
% Bail if we've not been given a table
if ~isa(hnd,'xregtable')
   error('Cannot set properties: not a table')
end
out=[];
% Want to handle different 'subobjects' nicely, eg frame properties
% so parse the input first to look for 'x.y' inputs
global fud
fud=get(hnd.frame.handle,'Userdata');
% Clear the data from frame: if we hold it then we end up with two copies
% which slows things down dramatically!

try
   % Try construct to prevent the table from being wrecked by an erroneous call
   if isempty(varargin)
      dispprops(hnd);
      return
   else
      set(hnd.frame.handle,'UserData',[]);
      inp=varargin{1};
   end
   
   % Loop over input selections
   rowsel=fud.cells.rowselection;
   colsel=fud.cells.colselection;
   k=size(rowsel,1);
   for j=1:k
      fud.cells.rowselection=[rowsel(j,1) rowsel(j,2)];
      fud.cells.colselection=[colsel(j,1) colsel(j,2)];
      pos=findstr(inp,'.');
      if isempty(pos)
         % If there's no x then set to 'toplevel'
         switch lower(inp)
         case {'number', 'numbers', 'value', 'values', 'type', 'format', 'string'}
            section='cells';
         otherwise
            section='toplevel';
         end
         property=inp;
      else
         section=inp(1:pos-1);
         property=inp(pos+1:end);
      end
      
      switch lower(section)
      case 'toplevel'
         outtmp=gettoplevel(hnd,property);  
      case 'frame'
         outtmp=getframes(hnd,property);
      case 'vslider'
         outtmp=getvslider(hnd,property);
      case 'hslider'
         outtmp=gethslider(hnd,property);
      case 'rows'
         outtmp=getrows(hnd,property);
      case 'cols'
         outtmp=getcols(hnd,property);
      case 'cells'
         outtmp=getcells(hnd,property);
      case 'filters'
         outtmp=getfilters(hnd,property);
      otherwise
         error(['Couldn''t find property: ' section]);
      end
      
      % Plug outtmp into out matrix
      
      % Need to be careful we only do this if indexing has bee used, ie on output from getcells
      % Do this by leaving alone if there's only one row in the rowselection
      if length(rowsel(:))>2
         out(rowsel(j,1):rowsel(j,2),colsel(j,1):colsel(j,2))=outtmp;
      else
         out=outtmp;
      end
      
   end
   
   
   
   
   % change back to default selection (all)
   fud.cells.rowselection=[fud.zeroindex(1) fud.rows.number];
   fud.cells.colselection=[fud.zeroindex(2) fud.cols.number];
   set(fud.frame.handle,'UserData',fud);
catch
   set(fud.frame.handle,'UserData',fud);
   clear global fud;
   error(lasterr);
end
clear global fud;
return





%-----------------------------------------------------------------------
%-----------------------------------------------------------------------
% Functions to get properties within each section
%-----------------------------------------------------------------------
%-----------------------------------------------------------------------

%============================================================
% Top level properties
%============================================================

function out=gettoplevel(hnd,property)
global fud
switch lower(property)
% all easy settings to get
case 'parent'   
   out=hnd.parent;
case 'position'
   % get position in pixels
   out=fud.position;
   % convert to normalised if necessary
   if strcmp(fud.units,'normalised');
      un=get(hnd.parent,'units');
      set(hnd.parent,'units','pixels');
      figsize=get(hnd.parent,'position');
      set(hnd.parent,'units',un);
      figsize(1:2)=figsize(3:4);
      out=out./figsize;
   end
case 'units'
	out=fud.units;
case 'visible'
   out=fud.visible;
case 'defaultcelltype'
   out=fud.defaultcelltype;
   out=invcodetype(out);
case 'defaultcellformat'
   out=fud.defaultcellformat;
case 'zeroindex'
   out=fud.zeroindex;
case 'showzeros'
   % No direct field.  Reflects a certain setting of filters
   if strcmp(fud.filters.type,'eq') & fud.filters.value==0 & fud.filters.tol==0
      out='off';
   else
      out='on';
   end
case 'redrawmode'
   if fud.redrawmode==0
      out='basic';
   elseif fud.redrawmode==1
      out='normal';
   else
      out='invalid setting';
   end
case 'colormap'
   out=fud.colormap;
case 'colorintervals'
   out=fud.colorintervals;
case 'usecolors'
   out=fud.usecolors;
case 'userdata'
   out=fud.userdata;
case 'diagscroll'
   out=get(fud.dslider.handle,'value');
   if out
      out='on';
   else
      out='off';
   end
case 'toosmall'
   out=istoosmall(hnd,1);
case 'bghandle'
   % another unpublished one: return handle to background axes
   out=hnd.frame.handle;
case 'sliders'
   opts={'off','on'};
   out=opts{fud.sliders+1};
case 'cellchangecallback'
   out=fud.cellchangecb;
   
   % methods called here.  Need a way of blocking output for this if possible
case 'clear'
   % method for clearing out table completely.  Use external function for this one.
   clear(hnd,1);
   out = hnd;
case 'redraw'
   % Need to expand selection out to cover fixed cells first
   fud.cells.rowselection=[1 fud.rows.number];
   fud.cells.colselection=[1 fud.cols.number];
   hnd=redraw(hnd,[1 1 1 1 1 1 1 1 1 1],1);
   out=hnd;
case 'delete'
   delete(hnd,1);
   fud.frame.handle=[];
   out=hnd;
otherwise
   error(['Couldn''t find property:' property]); 
end

return


%============================================================
% Frame properties
%============================================================

function out=getframes(hnd,property)
global fud
switch lower(property)
case 'visible'
	out=fud.frame.visible;
case 'hborder'
   out=fud.frame.hborder;
case 'vborder'
   out=fud.frame.vborder;
case 'position'
   % Prevents user from accessing position property below
   error('No such property: frame.position');
case {'backgroundcolor','color'}
   out=get(fud.frame.handle,'Color');
case 'boxcolor'
   out=fud.frame.boxcolor;
case 'box'
   out=get(fud.frame.handle,'box');
otherwise
   % pass property onto frame object
   % might want to alter this to make the background axis properties look like a frame
   out=get(fud.frame.handle,property);
end

return


%============================================================
% Vslider properties
%============================================================

function out=getvslider(hnd,property)
global fud
switch lower(property)
case 'visible'
   out=fud.vslider.visible;
case 'width'
	out=fud.vslider.width;   
case 'position'
	% This isn't a external property
   error('No such property: vslider.position');
case 'value'
   slud=get(fud.vslider.handle,'userdata');
   slval=get(fud.vslider.handle,'value');
   slval=-slval';
   if isempty(slud.steps)
      slud.steps=[fud.rows.fixed+1 fud.rows.number];
   end
   rowval=slud.steps(slval,1);
   out=rowval-fud.zeroindex(1)+1;
case 'offset'
   out=fud.vslider.offset;
otherwise
   % pass property and value onto slider object
   out=get(fud.vslider.handle,property);
end

return

%============================================================
% Hslider properties
%============================================================

function out=gethslider(hnd,property)
global fud
switch lower(property)
case 'visible'
   out=fud.hslider.visible;
case 'width'
   out=fud.hslider.width;   
case 'position'
   % This isn't a external property
   error('No such property: hslider.position');
case 'value'
   slud=get(fud.hslider.handle,'userdata');
   slval=get(fud.hslider.handle,'value');
   if isempty(slud.steps)
      slud.steps=[fud.cols.fixed+1 fud.cols.number];
   end
   colval=slud.steps(slval,1);
   out=colval-fud.zeroindex(2)+1;
case 'offset'
   out=fud.hslider.offset;
otherwise
   % pass property and value onto slider object
   out=get(fud.hslider.handle,property);
end

return

%============================================================
% Rows properties
%============================================================

function out=getrows(hnd,property)
global fud

switch lower(property)
case 'number'
   out=fud.rows.number;
case 'size'
   out=fud.rows.size;
case 'fixed'
   out=fud.rows.fixed;
case 'spacing'
   out=fud.rows.spacing;
case 'onscreen'
   % return total number of rows fittable in current table config
   out=size(fud.cells.shandles,1)+size(fud.cells.ftophandles,1);
case 'autosize'
   opts={'none','minsize','fixed'};
   out=opts(fud.rows.autosize+1);
case 'autosizenumber'
   out=fud.rows.autosizenumber;
otherwise
   error(['No such property: rows.' property]);  
end

return



%============================================================
% Cols properties
%============================================================

function out=getcols(hnd,property)
global fud

switch lower(property)
case 'number'
   out=fud.cols.number;
case 'size'
   out=fud.cols.size;
case 'fixed'
   out=fud.cols.fixed;
case 'spacing'
   out=fud.cols.spacing;
case 'onscreen'
   % return total number of cols fittable in current table config
   out=size(fud.cells.shandles,2)+size(fud.cells.flefthandles,2);
case 'autosize'
   opts={'none','minsize','fixed'};
   out=opts(fud.cols.autosize+1);
case 'autosizenumber'
   out=fud.cols.autosizenumber;
otherwise
   error(['No such property: cols.' property]);  
end

return


%============================================================
% Cells properties
%============================================================

function out=getcells(hnd,property)
global fud

% For getting properties, need to make sure colselection and rowselection
% don't go outside the range of the current cells.

if fud.cells.colselection(2)>fud.cols.number | fud.cells.rowselection(2)>fud.rows.number
   error('???  Index exceeds table dimensions.');
end

switch lower(property)
case 'positions'
   error('No such property: cells.positions');
case 'type'
   tp=fud.cells.ctype(fud.cells.rowselection(1):fud.cells.rowselection(2),...
      fud.cells.colselection(1):fud.cells.colselection(2)); 
   out=invcodetype(tp);
   
case {'number', 'value', 'numbers', 'values'}
   out=fud.cells.value(fud.cells.rowselection(1):fud.cells.rowselection(2),...
      fud.cells.colselection(1):fud.cells.colselection(2));
case 'string'
   strcell=fud.cells.string(fud.cells.rowselection(1):fud.cells.rowselection(2),...
      fud.cells.colselection(1):fud.cells.colselection(2));
   if length(strcell)==1
      out=strcell{1};
   else
      out=strcell;
   end
case 'visible'
   % need to get visible matrix, then convert to on's and off's
   out=fud.cells.visible(fud.cells.rowselection(1):fud.cells.rowselection(2),...
      fud.cells.colselection(1):fud.cells.colselection(2));
case 'format'
   fmtcell=fud.cells.format(fud.cells.rowselection(1):fud.cells.rowselection(2),...
      fud.cells.colselection(1):fud.cells.colselection(2));
   if length(fmtcell)==1
      out=fmtcell{1};
   else
      out=fmtcell;
   end
case 'rowselection'
   out=fud.cells.rowselection;
case 'colselection'
   out=fud.cells.colselection;
case 'position'
   error('No such property: cells.position');
   
   
   % Cell methods called here
case 'delete'
   % Need to trash arrays and delete objects if its in a fixed array
   % First get any fixed handles
   % create matrix indicating where selection is
   sel=false(fud.rows.number,fud.cols.number);
   sel(fud.cells.rowselection(1):fud.cells.rowselection(2),...
      fud.cells.colselection(1):fud.cells.colselection(2))=true;
   hndls1=fud.cells.fcornerhandles(sel(1:fud.rows.fixed,1:fud.cols.fixed));
   hndls2=fud.cells.ftophandles(sel(1:fud.rows.fixed,fud.cols.fixed+1:end));
   hndls3=fud.cells.flefthandles(sel(fud.rows.fixed+1:end,1:fud.cols.fixed));
   hndls=[hndls1(:);hndls2(:);hndls3(:)];
   hndls=hndls(hndls~=0);
   delete(hndls(:));
   
   % need to delete dead handles to ensure table works ok...
   fud.cells.fcornerhandles(sel(1:fud.rows.fixed,1:fud.cols.fixed))=0;
   fud.cells.ftophandles(sel(1:fud.rows.fixed,fud.cols.fixed+1:end))=0;
   fud.cells.flefthandles(sel(fud.rows.fixed+1:end,1:fud.cols.fixed))=0;
   
   % Now remove information in other matrices
   fud.cells.exist(fud.cells.rowselection(1):fud.cells.rowselection(2),...
      fud.cells.colselection(1):fud.cells.colselection(2))=false;
   fud.cells.visible(fud.cells.rowselection(1):fud.cells.rowselection(2),...
      fud.cells.colselection(1):fud.cells.colselection(2))={[]};
   fud.cells.type(fud.cells.rowselection(1):fud.cells.rowselection(2),...
      fud.cells.colselection(1):fud.cells.colselection(2))=0;
   fud.cells.value(fud.cells.rowselection(1):fud.cells.rowselection(2),...
      fud.cells.colselection(1):fud.cells.colselection(2))=NaN;
   fud.cells.string(fud.cells.rowselection(1):fud.cells.rowselection(2),...
      fud.cells.colselection(1):fud.cells.colselection(2))={''};
   fud.cells.userprops(fud.cells.rowselection(1):fud.cells.rowselection(2),...
      fud.cells.colselection(1):fud.cells.colselection(2))=false;
   fud.cells.uiprops(fud.cells.rowselection(1):fud.cells.rowselection(2),...
      fud.cells.colselection(1):fud.cells.colselection(2))={[]};
   fud.cells.format(fud.cells.rowselection(1):fud.cells.rowselection(2),...
      fud.cells.colselection(1):fud.cells.colselection(2))={[]};
   
   % Now do a redraw to reflect information changes
   
   % Honor redrawmode setting:
   if ~fud.redrawmode
      hnd=redraw(hnd,[1 1 0 0 0 0 0 0 0 0],1);
   else
      hnd=redraw(hnd,[1 1 0 0 1 0 1 0 0 0],1);   
   end
   out='TBL_METHODCALL';
  
otherwise
   % pass on call to indexed cells
   %out=get([fud.cells.handles{fud.cells.rowselection(1):fud.cells.rowselection(2),...
   %fud.cells.colselection(1):fud.cells.colselection(2)}],property);
   error('No such property');
   
end
return


%============================================================
% Filters properties
%============================================================

function out=getfilters(hnd,property)
global fud

switch(lower(property))
case 'type'
   out=fud.filters.type;     
case 'value'
   out=fud.filters.value;   
case 'tolerance'
   out=fud.filters.tol;
otherwise
   error(['No such property: filters.' property]);
end

return










