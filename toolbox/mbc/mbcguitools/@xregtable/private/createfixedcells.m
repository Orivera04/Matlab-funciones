function [n]=createfixedcells();
%CREATEFIXEDCELLS Private function
%
%  Simple cell creation routine for the fixed parts.
%  Requires a global copy of the table userdata to be in memory

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.3.2.2 $  $Date: 2004/02/09 07:32:54 $


global fud

% n is the variable used to count how many cells are created
n=0;

deftp=invcodetype(fud.defaultcelltype);
ui=(fud.defaultcelltype>1);
if ui
   tp='uicontrol';
   st=deftp(3:end);
else
   tp=deftp;
   st='none';
end

% Routine splits into 3 bits, one for each matrix of fixed handles

if (fud.cells.rowselection(1)<=fud.rows.fixed & fud.cells.colselection(1)<=fud.cols.fixed)
   % Do corner
   % Find limit to rows and cols
   if fud.cells.rowselection(2)>fud.rows.fixed
      rowlim=fud.rows.fixed;
   else
      rowlim=fud.cells.rowselection(2);
   end
   if fud.cells.colselection(2)>fud.cols.fixed
      collim=fud.cols.fixed;
   else
      collim=fud.cells.colselection(2);
   end
   
   % find cell positions that need creation.  These will also need array updates
   % with default values. cornr and cornc relative to row(col)selection(1) - remember
   [cornr,cornc]=find(~fud.cells.exist(fud.cells.rowselection(1):rowlim,...
      fud.cells.colselection(1):collim));
   % translate to normal coords
   cornr=cornr+fud.cells.rowselection(1)-1;
   cornc=cornc+fud.cells.colselection(1)-1;
   
   % No outside bit is possible for the corner - this would be a different region   
   % Create cells here (need to know any offsets for userdata)
   cud.parent=fud.frame.handle;
   cud.type='fixed';
   hndls=[];
   if ui  
      for m=1:length(cornr)
         cud.row=cornr(m);
         cud.col=cornc(m);
         fud.cells.fcornerhandles(cornr(m),cornc(m))=...
            xreguicontrol('parent',fud.parent,'style',st,'Userdata',cud,'Position',[-1 -1 1 1]);
         hndls(m)=fud.cells.fcornerhandles(cornr(m),cornc(m));
      end
      set(hndls(:),'Visible','off','Callback',...
         ['cellcb(get(' sprintf('%20.15f',fud.objecthandle) ',''Userdata''));']);
   else
      for m=1:length(cornr)
         cud.row=cornr(m);
         cud.col=cornc(m);
         fud.cells.fcornerhandles(cornr(m),cornc(m))=...
            feval(tp,'parent',fud.objecthandle,...
            'Visible','off',...
            'Userdata',cud,...
            'HorizontalAlignment','Center',...
            'Units','pixels');
      end
   end
   
   % update arrays that track cell status - need to create a logical index
   % For corner case, the overall size can't expand
   mask=false(fud.rows.number,fud.cols.number);
   mask(fud.cells.rowselection(1):rowlim,fud.cells.colselection(1):collim)=...
      ~fud.cells.exist(fud.cells.rowselection(1):rowlim,fud.cells.colselection(1):collim);
   fud.cells.exist(mask)=true;
   fud.cells.value(mask)=NaN;
   fud.cells.string(mask)={''};
   fud.cells.format(mask)={fud.defaultcellformat};
   fud.cells.visible(mask)={'on'};
   fud.cells.userprops(mask)=false;
   fud.cells.ctype(mask)=fud.defaultcelltype;
   
   % Handy for other parts of the program: make sure corner handles is an array
   % the same size as the number of fixed cols/rows
   
   sz=size(fud.cells.fcornerhandles);
   if sz(1)<fud.rows.fixed
      fud.cells.fcornerhandles(sz(1)+1:fud.rows.fixed,:)=0;
   end
   if sz(2)<fud.cols.fixed
      fud.cells.fcornerhandles(:,sz(2)+1:fud.cols.fixed)=0;
   end
   
   n=n+length(cornr);
end


if (fud.cells.rowselection(1)<=fud.rows.fixed)
   % Do top bit
   % Find limit to rows and cols
   if fud.cells.rowselection(2)>fud.rows.fixed
      rowlim=fud.rows.fixed;
   else
      rowlim=fud.cells.rowselection(2);
   end
   if fud.cells.colselection(2)>fud.cols.number
      collim=fud.cols.number;
   else
      collim=fud.cells.colselection(2);
   end
   if fud.cells.colselection(1)<=fud.cols.fixed
      colstrt=fud.cols.fixed+1;
   else
      colstrt=fud.cells.colselection(1);
   end
   
   % find cell positions that need creation. topr and topc will end up as
   % coordinates in the ftophandle array
   [topr,topc]=find(~fud.cells.exist(fud.cells.rowselection(1):rowlim,...
      colstrt:collim));
   
   topr=topr+fud.cells.rowselection(1)-1;
   topc=topc+colstrt-fud.cols.fixed-1;
   topr=topr(:);
   topc=topc(:);
   
   % Add any indices that are needed for the 'outside' bit 
   addr=[fud.cells.rowselection(1):rowlim]';
   addr=repmat(addr,1,fud.cells.colselection(2)-collim);
   addr=addr(:);
   
   addc=[collim+1-fud.cols.fixed:fud.cells.colselection(2)-fud.cols.fixed];
   addc=repmat(addc,rowlim-fud.cells.rowselection(1)+1,1);
   addc=addc(:);
   
   topr=[topr;addr];
   topc=[topc;addc];
   
   % Create cells here (need to know any offsets for userdata)
   cud.parent=fud.frame.handle;
   cud.type='fixed';
   hndls=[];
   if ui
      for m=1:length(topr)
         cud.row=topr(m);
         cud.col=topc(m)+fud.cols.fixed;
         fud.cells.ftophandles(topr(m),topc(m))=xreguicontrol(...
            'parent',fud.parent,'style',st,'Userdata',cud,'Position',[-1 -1 1 1]);    
         hndls(m)=fud.cells.ftophandles(topr(m),topc(m));
      end
      set(hndls(:),'Visible','off','Callback',...
         ['cellcb(get(' sprintf('%20.15f',fud.objecthandle) ',''Userdata''));']);
   else
      for m=1:length(topr)
         cud.row=topr(m);
         cud.col=topc(m)+fud.cols.fixed-1;
         fud.cells.ftophandles(topr(m),topc(m))=...
            feval(tp,'Parent',fud.objecthandle,...
            'Visible','off',...
            'Userdata',cud,...
            'HorizontalAlignment','Center',...
            'Units','pixels');
      end
   end
   
   % update arrays that track cell status - 2 bits: filling in holes in arrays
   % and then extending them if necessary
   mask=false(fud.rows.number,fud.cols.number);
   mask(fud.cells.rowselection(1):rowlim,colstrt:collim)=...
      ~fud.cells.exist(fud.cells.rowselection(1):rowlim,colstrt:collim);
   
   fud.cells.exist(mask)=true;
   fud.cells.exist(fud.cells.rowselection(1):rowlim,collim+1:fud.cells.colselection(2))=true;
   fud.cells.value(mask)=NaN;
   fud.cells.value(fud.cells.rowselection(1):rowlim,collim+1:fud.cells.colselection(2))=NaN;
   fud.cells.string(mask)={''};
   fud.cells.string(fud.cells.rowselection(1):rowlim,collim+1:fud.cells.colselection(2))={''};
   fud.cells.format(mask)={fud.defaultcellformat};
   fud.cells.format(fud.cells.rowselection(1):rowlim,collim+1:fud.cells.colselection(2))={fud.defaultcellformat};
   fud.cells.visible(mask)={'on'};
   fud.cells.visible(fud.cells.rowselection(1):rowlim,collim+1:fud.cells.colselection(2))={'on'};
   fud.cells.userprops(mask)=false;
   fud.cells.userprops(fud.cells.rowselection(1):rowlim,collim+1:fud.cells.colselection(2))=false;
   fud.cells.ctype(mask)=fud.defaultcelltype;
   fud.cells.ctype(fud.cells.rowselection(1):rowlim,collim+1:fud.cells.colselection(2))=fud.defaultcelltype;
   
   n=n+length(topr);
end
% Handy for other parts of the program: make sure corner handles is an array
% the same size as the number of fixed cols/rows

if fud.rows.fixed
   sz=size(fud.cells.ftophandles);
   if sz(1)<fud.rows.fixed
      fud.cells.ftophandles(sz(1)+1:fud.rows.fixed,1:fud.cols.number-fud.cols.fixed)=0;
   end
   if sz(2)<fud.cols.number-fud.cols.fixed
      fud.cells.ftophandles(1:fud.rows.fixed,sz(2)+1:fud.cols.number-fud.cols.fixed)=0;
   end
end

if (fud.cells.colselection(1)<=fud.cols.fixed)
   % Do left bit
   % Find limit to rows and cols
   % Find limit to rows and cols
   if fud.cells.rowselection(2)>fud.rows.number
      rowlim=fud.rows.number;
   else
      rowlim=fud.cells.rowselection(2);
   end
   if fud.cells.colselection(2)>fud.cols.fixed
      collim=fud.cols.fixed;
   else
      collim=fud.cells.colselection(2);
   end
   if fud.cells.rowselection(1)<=fud.rows.fixed
      rowstrt=fud.rows.fixed+1;
   else
      rowstrt=fud.cells.rowselection(1);
   end
   
   % find cell positions that need creation.
   [leftr,leftc]=find(~fud.cells.exist(rowstrt:rowlim,...
      fud.cells.colselection(1):collim));
   
   leftr=leftr+rowstrt-fud.rows.fixed-1;
   leftc=leftc+fud.cells.colselection(1)-1;
   leftr=leftr(:);
   leftc=leftc(:);
   
   % Add any indices that are needed for the 'outside' bit
   addr=[rowlim+1-fud.rows.fixed:fud.cells.rowselection(2)-fud.rows.fixed]';
   addr=repmat(addr,1,collim-fud.cells.colselection(1)+1);
   addr=addr(:);
   
   addc=[fud.cells.colselection(1):collim];
   addc=repmat(addc,fud.cells.rowselection(2)-rowlim,1);
   addc=addc(:);
   
   leftr=[leftr;addr];
   leftc=[leftc;addc];
   
   % Create cells here (need to know any offsets for userdata)
   cud.parent=fud.frame.handle;
   cud.type='fixed';
   hndls=[];
   if ui  
      for m=1:length(leftr)
         cud.row=leftr(m)+fud.rows.fixed;
         cud.col=leftc(m);
         fud.cells.flefthandles(leftr(m),leftc(m))=xreguicontrol(...
            'parent',fud.parent,'style',st,'Userdata',cud,'Position',[-1 -1 1 1]);
         hndls(m)=fud.cells.flefthandles(leftr(m),leftc(m));
      end
      set(hndls(:),'Visible','off','Callback',...
         ['cellcb(get(' sprintf('%20.15f',fud.objecthandle) ',''Userdata''));']);
   else
      for m=1:length(leftr)
         cud.row=leftr(m)+fud.rows.fixed;
         cud.col=leftc(m);
         fud.cells.flefthandles(leftr(m),leftc(m))=feval...
            (tp, 'Parent',fud.objecthandle,...
            'Visible','off',...
            'Userdata',cud,...
            'HorizontalAlignment','Center',...
            'Units','pixels');
      end
   end
   
   % update arrays that track cell status - 2 bits: filling in holes in arrays
   % and then extending them if necessary
   mask=false(fud.rows.number,fud.cols.number);
   mask(rowstrt:rowlim,fud.cells.colselection(1):collim)=...
      ~fud.cells.exist(rowstrt:rowlim,fud.cells.colselection(1):collim);
   
   fud.cells.exist(mask)=true;
   fud.cells.exist(rowlim+1:fud.cells.rowselection(2),fud.cells.colselection(1):collim)=true;
   fud.cells.value(mask)=NaN;
   fud.cells.value(rowlim+1:fud.cells.rowselection(2),fud.cells.colselection(1):collim)=NaN;
   fud.cells.string(mask)={''};
   fud.cells.string(rowlim+1:fud.cells.rowselection(2),fud.cells.colselection(1):collim)={''};
   fud.cells.format(mask)={fud.defaultcellformat};
   fud.cells.format(rowlim+1:fud.cells.rowselection(2),fud.cells.colselection(1):collim)={fud.defaultcellformat};
   fud.cells.visible(mask)={'on'};
   fud.cells.visible(rowlim+1:fud.cells.rowselection(2),fud.cells.colselection(1):collim)={'on'};
   fud.cells.userprops(mask)=false;
   fud.cells.userprops(rowlim+1:fud.cells.rowselection(2),fud.cells.colselection(1):collim)=false;
   fud.cells.ctype(mask)=fud.defaultcelltype;
   fud.cells.ctype(rowlim+1:fud.cells.rowselection(2),fud.cells.colselection(1):collim)=fud.defaultcelltype;
   
   n=n+length(leftr);
end

if fud.cols.fixed
   sz=size(fud.cells.flefthandles);
   if sz(1)<fud.rows.number-fud.rows.fixed
      fud.cells.flefthandles(sz(1)+1:fud.rows.number-fud.rows.fixed,1:fud.cols.fixed)=0;
   end
   if sz(2)<fud.cols.fixed
      fud.cells.flefthandles(1:fud.rows.number-fud.cols.fixed,sz(2)+1:fud.cols.fixed)=0;
   end
end
