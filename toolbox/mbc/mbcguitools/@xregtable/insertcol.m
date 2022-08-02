function insertcol(hnd,numcols,colpos,varargin)
%TABLE/INSERTCOL  Insert column into table
%   INSERTCOL(TBL,NUMCOLS,COLPOS)  inserts NUMCOLS into TBL
%   at position COLPOS.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.3.2.2 $  $Date: 2004/02/09 07:32:34 $


% varargin{1} is a flag indicating whether a global copy of fud is available
global fud
if nargin<4 | ~varargin{1}
   fud=get(hnd.frame.handle,'Userdata');
   set(hnd.frame.handle,'Userdata',[]);
end


% need to actually shift fixed handles right to preserve properties.
% scroll cells are easier: just shift data right and redraw
% Problems arise if we attempt to add a col to the fixed area.  For now I'll
% block out this possibility

if colpos<=fud.cols.fixed
   disp('Cannot insert a column in fixed area');
elseif colpos>fud.cols.number
   disp('Cannot insert columns outside current table area');
elseif ~fud.cols.number
   % Don't do it if there's no cells anyway
else
   
   fud.cells.exist=[fud.cells.exist(:,1:(colpos+fud.zeroindex(2)-2)), ...
         false(fud.rows.number,numcols), ...
         fud.cells.exist(:,(colpos+fud.zeroindex(2)-1):end)];
   fud.cells.userprops=[fud.cells.userprops(:,1:(colpos+fud.zeroindex(2)-2)), ...
         false(fud.rows.number,numcols), ...
         fud.cells.userprops(:,(colpos+fud.zeroindex(2)-1):end)];
   fud.cells.value=[fud.cells.value(:,1:(colpos+fud.zeroindex(2)-2)), ...
         zeros(fud.rows.number,numcols), ...
         fud.cells.value(:,(colpos+fud.zeroindex(2)-1):end)];
   fud.cells.visible=[fud.cells.visible(:,1:(colpos+fud.zeroindex(2)-2)), ...
         cell(fud.rows.number,numcols), ...
         fud.cells.visible(:,(colpos+fud.zeroindex(2)-1):end)];
   fud.cells.format=[fud.cells.format(:,1:(colpos+fud.zeroindex(2)-2)), ...
         cell(fud.rows.number,numcols), ...
         fud.cells.format(:,(colpos+fud.zeroindex(2)-1):end)];
   fud.cells.string=[fud.cells.string(:,1:(colpos+fud.zeroindex(2)-2)), ...
         cell(fud.rows.number,numcols), ...
         fud.cells.string(:,(colpos+fud.zeroindex(2)-1):end)];
   fud.cells.ctype=[fud.cells.ctype(:,1:(colpos+fud.zeroindex(2)-2)), ...
         zeros(fud.rows.number,numcols), ...
         fud.cells.ctype(:,(colpos+fud.zeroindex(2)-1):end)];
   
   if fud.rows.fixed
      % Shift handles right
      fud.cells.ftophandles=[...
            fud.cells.ftophandles(:,1:(colpos+fud.zeroindex(2)-2-fud.cols.fixed)), ...
            zeros(fud.rows.fixed,numcols), ...
            fud.cells.ftophandles(:,(colpos+fud.zeroindex(2)-1-fud.cols.fixed):end)];
      % create new cells in hole
      fud.cells.colselection=[colpos+fud.zeroindex(2)-1 colpos+numcols-2+fud.zeroindex(2)];
      fud.cells.rowselection=[1 fud.rows.fixed];
      n=createfixedcells;
   end
   
   % Create default data in gap
   fud.cells.value(:,(colpos+fud.zeroindex(2)-1):(colpos+fud.zeroindex(2)+numcols-2))=NaN;
   fud.cells.exist(:,(colpos+fud.zeroindex(2)-1):(colpos+fud.zeroindex(2)+numcols-2))=true;
   fud.cells.visible(:,(colpos+fud.zeroindex(2)-1):(colpos+fud.zeroindex(2)+numcols-2))={'on'};
   fud.cells.format(:,(colpos+fud.zeroindex(2)-1):(colpos+fud.zeroindex(2)+numcols-2))={fud.defaultcellformat};
   fud.cells.string(:,(colpos+fud.zeroindex(2)-1):(colpos+fud.zeroindex(2)+numcols-2))={''};
   fud.cells.type(:,(colpos+fud.zeroindex(2)-1):(colpos+fud.zeroindex(2)+numcols-2))=fud.defaultcelltype;
   if size(fud.cells.uiprops,2)>=(colpos+fud.zeroindex(2)-1)
      fud.cells.uiprops=[fud.cells.uiprops(:,1:(colpos+fud.zeroindex(2)-2)), ...
            cell(fud.rows.number,numcols), ...
            fud.cells.uiprops(:,(colpos+fud.zeroindex(2)-1):end)];
   end
   
   fud.cols.number=fud.cols.number+numcols;     
   
   fud.cells.colselection=[colpos+fud.zeroindex(2)-1-fud.cols.fixed fud.cols.number];
   fud.cells.rowselection=[1 fud.rows.number];
   
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