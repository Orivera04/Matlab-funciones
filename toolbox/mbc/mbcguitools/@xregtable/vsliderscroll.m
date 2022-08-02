function vsliderscroll(hnd,varargin);
%TABLE/VSLIDERSCROLL   Callback function
%   Callback function to implement vslider scrolling for
%   table object

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.3.2.2 $  $Date: 2004/02/09 07:33:55 $


% Scroll's all cells vertically.  This isn't strictly necessary but
% if you only move visible cells then the table will easily screw up very fast!

% If this callback is activated we can assume the slider is visible!

vshandle=hnd.vslider.handle;
vslud=get(vshandle,'UserData');
fhandle=hnd.frame.handle;
global fud
if nargin==1 | varargin{1}==0
   fud=get(fhandle,'UserData');
   set(fhandle,'UserData',[]);
end

try
   % Try construct for safety in case sliding fails
   hshandle=hnd.hslider.handle;
   hslud=get(hshandle,'UserData');
   
   vslval=round(abs(get(vshandle,'Value')));
   hslval=round(get(hshandle,'Value'));
   zerorow=vslud.steps(vslval,1);
   
   slpos=get(vshandle,'Position');
   zerorowpix=slpos(2)+slpos(4)-fud.rows.size;
   
   if fud.cols.fixed
      pos=fud.cells.positions;
      
      deltay=zerorowpix-pos(zerorow,2,1);
      
      pos=pos(fud.rows.fixed+1:end,:,1:fud.cols.fixed);
      
      % alter y-data by deltay
      pos(:,2,:)=pos(:,2,:)+deltay;
      
      % put new data back into fud while its still valid!
      fud.cells.positions(fud.rows.fixed+1:end,:,1:fud.cols.fixed)=pos;
      
      % find text objects
      txts=(fud.cells.ctype(fud.rows.fixed+1:end,1:fud.cols.fixed)==1);
      maskpos=false(size(txts));
      maskpos(vslud.steps(vslval,1)-fud.rows.fixed:vslud.steps(vslval,2)-fud.rows.fixed,:)=true;
      maskex=fud.cells.exist(fud.rows.fixed+1:end,1:fud.cols.fixed);
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
      windw=false(size(fud.cells.flefthandles));
      windw(vslud.steps(vslval,1)-fud.rows.fixed:vslud.steps(vslval,2)-fud.rows.fixed,:)=true;
      vis=cell(size(windw));
      vis(:)={'off'};
      
      % Only make some visible if the table is on
      if ~strcmp(fud.visible,'off')
         cutvis=fud.cells.visible(fud.rows.fixed+1:end,1:fud.cols.fixed);
         vis(windw)=cutvis(windw);
      end
      % cut out visibilities on non-existent cells
      vis=vis(fud.cells.exist(fud.rows.fixed+1:end,1:fud.cols.fixed));
      
      %Get handles and set data
      
      hndls=fud.cells.flefthandles;
      
      set(hndls(fud.cells.exist(fud.rows.fixed+1:end,1:fud.cols.fixed)),{'Visible'},vis(:));
      
      hndls2=hndls(txts & maskpos & maskex);
      hndls=hndls(~txts & maskpos & maskex);
      hndls=[hndls(:);hndls2(:)];
      set(hndls(:),{'Position'},poscell(:));
      
      % end fixed cell scroll..............................
   end
   set(vshandle,'Value',-vslval);
   % Begin main scroll area scroll.........................
   if fud.cols.fixed<fud.rows.number
      % ensure *full* row and col selection
      fud.cells.rowselection=[1 fud.rows.number];
      fud.cells.colselection=[1 fud.cols.number];
      hnd=redraw(hnd,[0 0 0 0 1 0 0 1 0 0],1);
      fud.cells.rowselection=[fud.zeroindex(1) fud.rows.number];
      fud.cells.colselection=[fud.zeroindex(2) fud.cols.number];
   end
   
   % Begin diagonal scroll if required........................
   if nargin==1
      if get(hnd.dslider.handle,'value')
         minmax=get(hnd.hslider.handle,{'Min','Max'});
         if vslval > minmax{2} 
            vslval=minmax{2};
         elseif vslval < minmax{1}
            vslval=minmax{1};
         end
         set(hnd.hslider.handle,'value',vslval)
         hsliderscroll(hnd,2);
      end
   end
   if nargin==1 | varargin{1}==0
      set(fhandle,'Userdata',fud);
      clear global fud
   end
catch
   set(fhandle,'UserData',fud);
   error(lasterr);
end


return