function  [c,sel]=constraintgui(c,action,index,m)
%CONSTRAINTGUI  Graphically edit a constraint
%
%  [C,SEL]=CONSTRAINTGUI(C,'create',INDEX,M)
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.7.2.2 $  $Date: 2004/02/09 07:01:43 $


% Creation routine

fig=xregfigure('name','Constraint Editor',...
   'visible','off',...
   'closerequestfcn','set(gcbf,''visible'',''off'',''tag'',''cancel'');');
xregcenterfigure(fig,[600 360]);
fig.minimumsize=[590 260];
opts=getconstrainttypes(c);    % return list of constraint options
nf=length(c.Factors);

if nargin>3
   ud.model=m;
else
   ud.model=xregmodel('nfactors',length(c.Factors));
end

ptr=[];
for n=1:length(opts)
   obj=feval(opts{n},length(c.Factors),'model',ud.model);
   rng=nfactorsallowed(obj);
   if nf>=rng(1) & nf<=rng(2)
      ptr=[ptr xregGui.RunTimePointer(obj)];
   end
end
ud.objects=ptr;
ud.created=zeros(1,length(ptr));
infoptr=xregGui.RunTimePointer;

str={};
for n=1:length(ptr)
   str(n)={typename(ptr(n).info)};
end

startobj=c.Constraints{index};
% find the current one 
ind=find(strcmp(str,typename(startobj)));
ud.objects(ind).info=startobj;
ud.showing=0;
ud.thisobj=c;
ud.Factors=c.Factors;

tptxt=uicontrol('parent',fig,...
   'style','text',...
   'HorizontalAlignment','left',...
   'string','Constraint type:');
ud.tppop=uicontrol('parent',fig,...
   'style','popup',...
   'BackGroundColor','w',...
   'string',str,...
   'callback',{@i_typeselect,infoptr},...
   'value',ind);
ud.descriptxt=axestext(fig,'verticalalignment','top');
ud.descripim=xregGui.axesimage('parent',fig);

okbut=uicontrol('parent',fig,...
   'style','push',...
   'string','OK',...
   'callback','set(gcbf,''tag'',''ok'');');
cancbut=uicontrol('parent',fig,...
   'style','push',...
   'string','Cancel',...
   'callback','set(gcbf,''visible'',''off'',''tag'',''cancel'');');
helpbtn=mv_helpbutton(fig,'xreg_desConEditor');

grd=xreggridbaglayout(fig,'dimension',[1 4],...
   'colsizes',[-1 65 65 65],...
   'gapx',7,...
   'elements',{[],okbut,cancbut,helpbtn},...
   'packstatus','off');
grd2=xreggridbaglayout(fig,'dimension',[5 5],...
   'rowsizes',[10 3 15 2 10],...
   'colsizes',[85 -1 20 330 40],...
   'mergeblock',{[2 4],[2 2]},...
   'mergeblock',{[1 5],[4 4]},...
   'mergeblock',{[1 5],[5 5]},...
   'elements',{[],[],tptxt,[],[],...
      [],ud.tppop,[],[],[],...
      [],[],[],[],[],...
      ud.descriptxt,[],[],[],[],...
      ud.descripim});
frmtop=xregframetitlelayout(fig,'title','Available constraints',...
   'center',grd2);
ud.crd=xregcardlayout(fig,'numcards',length(ud.objects));
frmmid=xregframetitlelayout(fig,'title','Constraint options',...
   'center',ud.crd);

lyt=xreggridlayout(fig,'correctalg','on',...
   'dimension',[3 1],...
   'rowsizes',[66 -1 25],'gapy',10,...
   'border',[7 7 7 7],...
   'elements',{frmtop,frmmid,grd});

infoptr.info=ud;

fig.LayoutManager=lyt;
set(lyt,'packstatus','on');

% trigger creation of first options layout
i_typeselect(ud.tppop,[],infoptr);

set(fig,'visible','on');
drawnow;
set(fig,'windowstyle','modal');
goforclose=0;
while ~goforclose
   set(fig,'tag','');
   waitfor(fig,'tag');
   % code blocks and waits here
   tg=get(fig,'tag');
   if strcmp(tg,'ok')
      ud=infoptr.info;
      val=ud.showing;
      % call finalise on this object
      lyt=getcard(ud.crd,val);
      [ok,msg]=propertypage(ud.objects(val).info,'finalise',lyt{1});
      if ok
         c.Constraints{index}=ud.objects(val).info;
         goforclose=1;
         sel=index;
      else
         % reshow figure?
         for n=1:length(msg)
            h=errordlg(msg{n},'Constraint error','modal');
            drawnow;
            waitfor(h);
         end
      end  
   else
      goforclose=1;  %cancel
      sel=0;
   end
end
delete(fig);
return


function i_typeselect(src,evt,ptr)
ud=ptr.info;
val=get(src,'value');
if val~=ud.showing
   fig=get(src,'parent');
   set(fig,'pointer','watch');
   set(ud.descriptxt,'string',texdescription(ud.objects(val).info));
   set(ud.descripim,'image',imread(largeicon(ud.objects(val).info),'bmp'));
   drawnow;
   if ~ud.created(val)
      % create and attach layout
      lyt=propertypage(ud.objects(val).info,'create',fig,ud.objects(val),ud.model,ud.Factors);
      attach(ud.crd,lyt,val);
      set(ud.crd,'packstatus','on');
      ud.created(val)=1;
   end
   set(ud.crd,'currentcard',val);
   ud.showing=val;
   ptr.info=ud;
   set(fig,'pointer','arrow');
end

return



