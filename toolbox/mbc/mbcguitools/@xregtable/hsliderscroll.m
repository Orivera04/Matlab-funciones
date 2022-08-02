function hsliderscroll(hnd,varargin)
%TABLE/HSLIDERSCROLL   Callback function
%   Callback function to implement horizontal scrolling for
%   table object

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.3.2.2 $  $Date: 2004/02/09 07:32:33 $


% Scroll's all cells horizontally.  This isn't strictly necessary but
% if you only move visible cells then the table will screw up very fast!


% If this callback is activated we can assume the slider is visible!
hshandle=hnd.hslider.handle;
hslud=get(hshandle,'UserData');
fhandle=hnd.frame.handle;
global fud
if nargin==1 | varargin{1}==0
   fud=get(fhandle,'UserData');
   set(fhandle,'UserData',[]);
end

try
   % Try construct for safety in case of sliding failure
   vshandle=hnd.vslider.handle;
   vslud=get(vshandle,'UserData');
   
   vslval=round(abs(get(vshandle,'Value')));
   hslval=round(get(hshandle,'Value'));
   zerocol=hslud.steps(hslval,1);
   
   slpos=get(hshandle,'Position');
   zerocolpix=slpos(1);
   
   if fud.rows.fixed
      pos=fud.cells.positions;
      
      deltax=zerocolpix-pos(1,1,zerocol);
      
      pos=pos(1:fud.rows.fixed,:,fud.cols.fixed+1:end);
      
      % alter x-data by deltax
      pos(:,1,:)=pos(:,1,:)+deltax;
      
      % put new data back into fud while its still valid!
      fud.cells.positions(1:fud.rows.fixed,:,fud.cols.fixed+1:end)=pos;
      
      % find text objects
      txts=(fud.cells.ctype(1:fud.rows.fixed,fud.cols.fixed+1:end)==1);
      maskpos=false(size(txts));
      maskpos(:,hslud.steps(hslval,1)-fud.cols.fixed:hslud.steps(hslval,2)-fud.cols.fixed)=true;
      maskex=fud.cells.exist(1:fud.rows.fixed,fud.cols.fixed+1:end);
      poscell={};
      
      if ~isempty(find(~txts))
         poscell=num2cell(pos,2);
         poscell=squeeze(poscell);
         poscell=poscell(~txts & maskpos & maskex);
      end
      
      if ~isempty(find(txts))
         % alter pos data for text objects
         pos(:,1,:)=pos(:,1,:)+0.5.*pos(:,3,:);
         pos(:,2,:)=pos(:,2,:)+0.6.*pos(:,4,:);
         pos(:,3:4,:)=[];
         
         poscell2=num2cell(pos,2);
         poscell2=squeeze(poscell2);
         poscell=[poscell; poscell2(txts & maskpos & maskex)];
      end
      
      % Now decide which cells need to be visible
      windw=false(size(fud.cells.ftophandles));
      windw(:,hslud.steps(hslval,1)-fud.cols.fixed:hslud.steps(hslval,2)-fud.cols.fixed)=true;
      vis=cell(size(windw));
      vis(:)={'off'};
      
      % Only make some visible if the table is on
      if ~strcmp(fud.visible,'off')
         cutvis=fud.cells.visible(1:fud.rows.fixed,fud.cols.fixed+1:end);
         vis(windw)=cutvis(windw);
      end
      % cut out visibilities on non-existent cells
      vis=vis(fud.cells.exist(1:fud.rows.fixed,fud.cols.fixed+1:end));
      
      %Get handles and set data
      hndls=fud.cells.ftophandles;
      
      set(hndls(maskex),{'Visible'},vis(:));
      
      hndls2=hndls(txts & maskpos & maskex);
      hndls=hndls(~txts & maskpos & maskex);
      
      hndls=[hndls(:);hndls2(:)];
      set(hndls(:),{'Position'},poscell(:));
      
      % end fixed cell scroll..............................
   end
   
   % Begin main scroll area scroll.........................
   set(hshandle,'Value',hslval);
   if fud.cols.fixed<fud.rows.number
      % cop out of doing any extra work!
      fud.cells.rowselection=[1 fud.rows.number];
      fud.cells.colselection=[1 fud.cols.number];
      hnd=redraw(hnd,[0 0 0 0 1 0 0 1 0 0],1);
      fud.cells.rowselection=[fud.zeroindex(1) fud.rows.number];
      fud.cells.colselection=[fud.zeroindex(2) fud.cols.number];
   end
   
   % Begin diagonal scroll if required........................
   if nargin==1
      if get(hnd.dslider.handle,'value')
         minmax=get(hnd.vslider.handle,{'Min','Max'});
         if -hslval > minmax{2} 
            hslval=minmax{2};
         elseif -hslval < minmax{1}
            hslval=minmax{1};
         end
         set(hnd.vslider.handle,'value',-hslval)
         vsliderscroll(hnd,2);
      end
   end
   
   if nargin==1 | varargin{1}==0
      set(fhandle,'Userdata',fud);
      clear global fud
   end
catch
   set(fhandle,'Userdata',fud);
   error(lasterr);
end

return