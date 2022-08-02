function insertrow(hnd, numrows, rowpos, varargin)
%TABLE/INSERTROW  Insert rows into table
%   INSERTROW(TBL,NUMROWS,ROWPOS) inserts NUMROWS rows into
%   TBL at position ROWPOS.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.3.2.2 $  $Date: 2004/02/09 07:32:35 $


% varargin{1} is a flag indicating whether a global copy of fud is available
global fud
if nargin<4 | ~varargin{1}
   fud=get(hnd.frame.handle,'Userdata');
   set(hnd.frame.handle,'Userdata',[]);
end


% need to actually shift fixed handles downwards to preserve properties.
% scroll cells are easier: just shift data downwards and redraw
% Problems arise if we attempt to add a row to the fixed area.  For now I'll
% block out this possibility

% Also cannot insert a row onto the end of a table.  Use the rows.number
% property for this

if rowpos<=fud.rows.fixed
   disp('Cannot insert a row in fixed area');
elseif rowpos>fud.rows.number
   disp('Cannot insert rows outside current table area');
elseif ~fud.cols.number
   % Don't do it if there's no cells anyway
else
   
   fud.cells.exist=[fud.cells.exist(1:(rowpos+fud.zeroindex(1)-2),:); ...
         false(numrows,fud.cols.number); ...
         fud.cells.exist((rowpos+fud.zeroindex(1)-1):end,:)];
   fud.cells.userprops=[fud.cells.userprops(1:(rowpos+fud.zeroindex(1)-2),:); ...
         false(numrows,fud.cols.number); ...
         fud.cells.userprops((rowpos+fud.zeroindex(1)-1):end,:)];
   fud.cells.value=[fud.cells.value(1:(rowpos+fud.zeroindex(1)-2),:); ...
         zeros(numrows,fud.cols.number); ...
         fud.cells.value((rowpos+fud.zeroindex(1)-1):end,:)];
   fud.cells.visible=[fud.cells.visible(1:(rowpos+fud.zeroindex(1)-2),:); ...
         cell(numrows,fud.cols.number); ...
         fud.cells.visible((rowpos+fud.zeroindex(1)-1):end,:)];
   fud.cells.format=[fud.cells.format(1:(rowpos+fud.zeroindex(1)-2),:); ...
         cell(numrows,fud.cols.number); ...
         fud.cells.format((rowpos+fud.zeroindex(1)-1):end,:)];
   fud.cells.string=[fud.cells.string(1:(rowpos+fud.zeroindex(1)-2),:); ...
         cell(numrows,fud.cols.number); ...
         fud.cells.string((rowpos+fud.zeroindex(1)-1):end,:)];
   fud.cells.ctype=[fud.cells.ctype(1:(rowpos+fud.zeroindex(1)-2),:); ...
         zeros(numrows,fud.cols.number); ...
         fud.cells.ctype((rowpos+fud.zeroindex(1)-1):end,:)];
   
   if fud.cols.fixed
      % Shift handles down
      fud.cells.flefthandles=[...
            fud.cells.flefthandles(1:(rowpos+fud.zeroindex(1)-2-fud.rows.fixed),:); ...
            zeros(numrows,fud.cols.fixed); ...
            fud.cells.flefthandles((rowpos+fud.zeroindex(1)-1-fud.rows.fixed):end,:)];
      % create new cells in hole
      fud.cells.rowselection=[rowpos+fud.zeroindex(1)-1 rowpos+numrows-2+fud.zeroindex(1)];
      fud.cells.colselection=[1 fud.cols.fixed];
      n=createfixedcells;
   end
   
   % Create default data in gap
   fud.cells.value((rowpos+fud.zeroindex(1)-1):(rowpos+fud.zeroindex(1)+numrows-2),:)=NaN;
   fud.cells.exist((rowpos+fud.zeroindex(1)-1):(rowpos+fud.zeroindex(1)+numrows-2),:)=true;
   fud.cells.visible((rowpos+fud.zeroindex(1)-1):(rowpos+fud.zeroindex(1)+numrows-2),:)={'on'};
   fud.cells.format((rowpos+fud.zeroindex(1)-1):(rowpos+fud.zeroindex(1)+numrows-2),:)={fud.defaultcellformat};
   fud.cells.string((rowpos+fud.zeroindex(1)-1):(rowpos+fud.zeroindex(1)+numrows-2),:)={''};
   fud.cells.ctype((rowpos+fud.zeroindex(1)-1):(rowpos+fud.zeroindex(1)+numrows-2),:)=fud.defaultcelltype;
   if size(fud.cells.uiprops,1)>=(rowpos+fud.zeroindex(1)-1)
      fud.cells.uiprops=[fud.cells.uiprops(1:(rowpos+fud.zeroindex(1)-2),:); ...
            cell(numrows,fud.cols.number); ...
            fud.cells.uiprops((rowpos+fud.zeroindex(1)-1):end,:)];
   end
   
   fud.rows.number=fud.rows.number+numrows;     
   
   fud.cells.rowselection=[rowpos+fud.zeroindex(1)-1-fud.rows.fixed fud.rows.number];
   fud.cells.colselection=[1 fud.cols.number];
   if fud.redrawmode
      redraw(hnd,[1 1 0 0 1 1 0 1 1 0],1);
   else
      redraw(hnd,[1 1 0 0 0 0 0 0 0 0],1);
   end
   
   fud.cells.rowselection=[fud.zeroindex(1) fud.rows.number];
   fud.cells.colselection=[fud.zeroindex(2) fud.cols.number];
   
end
if length(varargin)==0 | ~varargin{1}
   % Reset data into table
   set(hnd.frame.handle,'Userdata',fud);
   clear global fud
end
return