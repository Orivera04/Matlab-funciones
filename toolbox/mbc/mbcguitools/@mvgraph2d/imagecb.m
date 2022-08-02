function imagecb(gr,action)
%IMAGECB Callback function for graph2d object
%  IMAGECB is called when the graph2d image is clicked on.
%  It displays an axis with info on the point clicked

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.4.2.2 $  $Date: 2004/02/09 07:19:05 $

%grab point clicked on
switch lower(action)
case 'create'
   pnt=get(gr.axes,'currentpoint');
   xval=round(pnt(1,1));
   yval=round(pnt(1,2));
   % ask for a new set of yellow axes in right place
   [ax,txt]=infoaxes('new',gr);
   
   ud = gr.DataPointer.info;
   data = ud.data;
   % Generate the text string.
   factors=ud.factors;
   if length(factors)
      if iscell(factors{1,1})
         xfactor=factors{:,1};
      elseif length(factors)>1 & iscell(factors{2})
         xfactor=factors{:,1};
      else
         xfactor=factors(:,1);
      end
   else
      xfactor={};
   end
   if size(factors,2)>1
      if iscell(factors{1,2})
         yfactor=factors{:,2};
      else
         yfactor={};
      end
   else
      yfactor={};
   end
   
   if length(xfactor)<xval
      xfactor=['col ' sprintf('%d', xval)];
   else
      xfactor=xfactor{xval};
   end
   
   if length(yfactor)<yval
      yfactor=['row ' sprintf('%d', yval)];
   else
      yfactor=yfactor{yval};
   end
   str=['(' xfactor ', ' yfactor '):' sprintf('\n')];
   str=[str 'Value=' num2str(data(yval,xval))];
   set(txt,'string',str);
   % check box is right size
   ex=get(txt,'extent');
   pos=get(ax,'position');
   if ex(3)>1
      % stretch in xdir
      pos(3)=pos(3)*(ex(3)+.1);
   end
   if ex(4)>1
      % stretch in ydir
      pos(4)=pos(4)*(ex(4)+.1);
   end
   % check object is within gr boundary
   gr_pos = ud.position;
   if (pos(1)+pos(3))>(gr_pos(1)+gr_pos(3));
      pos(1)=pos(1)-(pos(1)+pos(3)-gr_pos(1)-gr_pos(3));
   end
   
   set(ax,'position',pos,'visible','on');
   
   oldfn=get(get(gr.axes,'parent'),'windowbuttonupfcn');
   set(ax,'userdata',oldfn);
   set(get(gr.axes,'parent'),'windowbuttonupfcn',{@i_destroy,gr});
end


function i_destroy(src,evt,gr)
ax=infoaxes('current');
fn=get(ax,'userdata');
if ~isempty(fn)
    set(get(gr.axes,'parent'),'windowbuttonupfcn',fn);
else
    set(get(gr.axes,'parent'),'windowbuttonupfcn','');
end
infoaxes('destroy');