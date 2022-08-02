function [dout,ok]=gui_fixpoints(des,action,varargin);
%GUI_FIXPOINTS GUI for fixing design points
%
%  [D,OK}=GUI_FIXPOINTS(D) brings up a GUI for fixing and freeing design
%  points.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.4.2.3 $  $Date: 2004/02/09 07:06:49 $



if nargin<2
   action='create';
end

switch lower(action)
case 'create'
   scrpos=get(0,'screensize');
   xFig=xregfigure('visible','off',...
      'name','Fix Design Points',...
      'position',[scrpos(3)./2-175 scrpos(4)./2-115 350 230],...
      'resize','off',...
      'closerequestfcn',['set(gcbf,''tag'',''CLOSEGUI'');'],...
      'tag','Fixpoints');
   figh=double(xFig);
   
   % intialise listitem selector to allow user to select non-data points
   % for fixing
   Allpts = 1:npoints(des);
   isdata = getdatapoint(des);
   isfixed = getuserfixed(des);
   delobj=listitemselector(figh,...
      'itemlist',Allpts(~isdata),...
      'unselectedtitle','Free Points:',...
      'selectedtitle','Fixed Points:');
   selectitems(delobj,find(isfixed(~isdata)));
   
   cancbtn=uicontrol('style','pushbutton',...
      'parent',figh,...
      'string','Cancel',...
      'callback',['set(gcbf,''tag'',''CLOSEGUI'');'],...
      'userdata',des);
   objtxt=sprintf('%20.15f',cancbtn);
   okbtn=uicontrol('style','pushbutton',...
      'parent',figh,...
      'string','OK',...
      'callback',['gui_deletepoints(get(' objtxt ',''userdata''),''ok'');']);
   helpbtn=mv_helpbutton(figh,'xreg_desFixPoints');
   
   main=xreggridbaglayout(figh,...
      'packstatus','off',...
      'dimension',[2 4],...
      'colsizes',[-1 65 65 65],...
      'rowsizes',[-1 25],...
      'gapx',7,'gapy',10,...
      'border',[7 7 7 7],...
      'mergeblock',{[1 1],[1 4]},...
      'elements',{delobj,[],[],okbtn,[],cancbtn,[],helpbtn});
   
   xFig.LayoutManager=main;
   set(main,'packstatus','on');
   
   ud.design=des;
   ud.status=0;
   ud.delobj=delobj;
   
   set(figh,'userdata',ud,'visible','on');
   drawnow;
   set(figh,'windowstyle','modal');
   % block until ok/cancel pressed
   waitfor(figh,'tag','CLOSEGUI');
   
   ud=get(figh,'userdata'); 
   if ud.status
      %delete chosen points
      dout=ud.design;
      fixinds=ud.delobj.selecteditems;
      freeinds=ud.delobj.unselecteditems;
      dout = setuserfixed(dout, fixinds);
      dout = setuserfixed(dout, freeinds, false);
   else
      dout=des;
   end
   ok=ud.status;
   delete(figh);
   
case 'ok'
   figh=gcbf;
   ud=get(figh,'userdata');
   ud.status=1;
   set(figh,'userdata',ud);
   set(figh,'tag','CLOSEGUI');

end
