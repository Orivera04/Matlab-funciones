function gr=prefsgui(gr,varargin)
% GRAPH1D/PREFSGUI   GUI for altering graph1d appearance
%    GR=PREFSGUI(GR) opens up a modal dialogue offering a range
%    of options for altering the appearance of the 1D graph object GR.
%    Options available include: General colours, optional histogram, 
%    histogram colours and histogram gridline style.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.5.4.2 $  $Date: 2004/02/09 07:18:53 $



if nargin==1
   action='create';
else
   action=varargin{1};
end


switch lower(action)
case 'create'
   gr=i_createfig(gr);

case 'usegrid'
   % need to enable/disable stuff
   figh=gcbf;
   ud=get(figh,'userdata');
   
   if get(ud.hist.usegrid,'value')
      en='on';
   else
      en='off';
   end
   
   set(ud.hist.gridstyletext,'enable',en);
   set(ud.hist.gridstyle,'enable',en);
   
case 'filltype'
   % make 2 radiobuttons mutually exclusive, change options below
   figh=gcbf;
   ud=get(figh,'userdata');
   sel=ud.hist.barcolor.radios.Selected;
   if sel==1
      str='Color:';
      vis='off';
   else
      str='Top color:';
      vis='on';
   end
   set(ud.hist.barcolor.text1,'string',str)
   set([ud.hist.barcolor.text2;ud.hist.barcolor.edit2;ud.hist.barcolor.push2],'visible',vis);
   
case 'editchcol'
   figh=gcbf;
   ud=get(figh,'userdata');
   obj=gcbo;
   changeobj=i_getfield(ud,varargin{2});
   % grab string 
   str=get(obj,'string');
   if strcmp(str,'none')
      set(changeobj,'backgroundcolor',get(0,'defaultuicontrolbackgroundcolor'));      
   else
      col=str2num(str);
      if length(col(:))~=3 | any(col>1 | col<0)
         col=get(changeobj,'backgroundcolor');
         set(obj,'string',['[' num2str(col(1)) ' ' num2str(col(2)) ' ' num2str(col(3)) ']']);
      else
         set(changeobj,'backgroundcolor',col);
      end
   end
   
case 'interactivechcol'
   figh=gcbf;
   ud=get(figh,'userdata');
   obj=gcbo;
   changeobj=i_getfield(ud,varargin{2});
   
   col=get(obj,'backgroundcolor');
   col2=uisetcolor(col);
   if ~all(col2==col)
      set(obj,'backgroundcolor',col2,'value',0);
      set(changeobj,'string',['[' num2str(col2(1),2) ' ' num2str(col2(2),2) ' ' num2str(col2(3),2) ']']);
   else
      set(obj,'value',0);
   end
   
case 'autobars'
   % need to switch number of bars to auto/or normal
   figh=gcbf;
   figcol=get(figh,'color');
   ud=get(figh,'userdata');
   auto=get(ud.hist.autobars,'value');
   if auto
      en='off';
   else
      en='on';
   end
   set(ud.hist.numbars,'enable',en);
   
case 'checknumbars'
   % check input on numbars edit field
   figh=gcbf;
   ud=get(figh,'userdata');
   n=str2double(get(ud.hist.numbars,'string'));
   if isnan(n) | n<0 | floor(n)~=n
      % bad user input.  return to previous input
      set(ud.hist.numbars,'string',get(ud.hist.numbars,'userdata'));
   else
      set(ud.hist.numbars,'userdata',num2str(n));
   end
      
case 'cancel'
   figh=gcbf;
   set(figh,'tag','cancel');
case 'ok'
   figh=gcbf;
   i_apply(figh);
   set(figh,'tag','ok');
case 'apply'
   i_apply(gcbf);
end





function gr=i_createfig(gr)

mnm=mfilename;
[pth,mnm,ext,ver]=fileparts(mnm);

scrsz=get(0,'screensize');
figh=figure('visible','off',...
   'position',[scrsz(3)/2-145 scrsz(4)/2-180 290 360],...
   'toolbar','none',...
   'menubar','none',...
   'numbertitle','off',...
   'name','1D Graph Options',...
   'units','pixels',...
   'resize','off',...
   'doublebuffer','on',...
   'color',get(0,'defaultuicontrolbackgroundcolor'));

[lyt,objh] = i_createlyt(figh,gr);

% ok and cancel buttons
cbstr = [mnm '(get(' sprintf('%20.15f',objh) ',''userdata''),'];
okbtn = uicontrol('style','pushbutton',...
   'parent',figh,...
   'position',[0 0 65 25],...
   'string','OK',...
   'callback',[cbstr '''ok'',gcbf);']);
cancbtn = uicontrol('style','pushbutton',...
   'parent',figh,...
   'position',[0 0 65 25],...
   'string','Cancel',...
   'callback',[cbstr '''cancel'',gcbf);']);
applybtn = uicontrol('style','pushbutton',...
   'parent',figh,...
   'position',[0 0 65 25],...
   'string','Apply',...
   'callback',[cbstr '''apply'',gcbf);']);

flw=xregflowlayout(figh,'packstatus','on','orientation','right/center',...
   'elements',{applybtn,cancbtn,okbtn},'gap',7,'border',[0 0 -7 0]);
main=xregborderlayout(figh,'center',lyt,'south',flw,'innerborder',[10 45 10 10],...
   'container',figh,'packstatus','on');

set(figh,'visible','on',...
   'closerequestfcn',[cbstr '''cancel'',gcbf);']);
drawnow;
set(figh,'windowstyle','modal');
waitfor(figh,'tag');

% output is simply the input object
delete(figh);
return




function [lyt,objh]=i_createlyt(figh,gr)
mnm=mfilename;
[pth,mnm,ext,ver]=fileparts(mnm);

% general options


txt(1)=uicontrol('style','text',...
   'parent',figh,...
   'position',[0 0 100 15],...
   'string','Axes color:',...
   'horizontalalignment','left',...
   'userdata',gr);

objh=txt(1);
objht=sprintf('%20.15f',objh);
cbstr = [mnm '(get(' objht ',''userdata''),'];

ud.axcol=get(gr.axes,'xcolor');
ud.gen.axcol.edit=uicontrol('style','edit',...
   'parent',figh,...
   'backgroundcolor',[1 1 1],...
   'string',['[' num2str(ud.axcol(1)) ' ' num2str(ud.axcol(2)) ' ' num2str(ud.axcol(3)) ']'],...
   'position',[0 0 75 20],...
   'callback',[cbstr '''editchcol'',''gen.axcol.push'');']);
ud.gen.axcol.push=uicontrol('style','togglebutton',...
   'value',0,...
   'position',[0 0 30 20],...
   'backgroundcolor',ud.axcol,...
   'callback',[cbstr '''interactivechcol'',''gen.axcol.edit'');'],...
   'parent',figh);

txt(2)=uicontrol('style','text',...
   'parent',figh,...
   'position',[0 0 100 15],...
   'string','Plot color:',...
   'horizontalalignment','left');
ud.lncol=get(gr.line,'markerfacecolor');
ud.gen.lncol.edit=uicontrol('style','edit',...
   'parent',figh,...
   'backgroundcolor','w',...
   'string',['[' num2str(ud.lncol(1)) ' ' num2str(ud.lncol(2)) ' ' num2str(ud.lncol(3)) ']'],...
   'position',[0 0 75 20],...
   'callback',[cbstr '''editchcol'',''gen.lncol.push'');']);
ud.gen.lncol.push=uicontrol('style','togglebutton',...
   'value',0,...
   'position',[0 0 30 20],...
   'backgroundcolor',ud.lncol,...
   'callback',[cbstr '''interactivechcol'',''gen.lncol.edit'');'],...
   'parent',figh);

% set up layouts for general frame
flw2=xregflowlayout(figh,'orientation','left/center','gap',5,...
   'elements',{txt(1) ud.gen.axcol.edit ud.gen.axcol.push});
flw3=xregflowlayout(figh,'orientation','left/center','gap',5,...
   'elements',{txt(2) ud.gen.lncol.edit ud.gen.lncol.push});
grd=xreggridlayout(figh,'correctalg','on','dimension',[2 1],'elements',{flw2 flw3});
frm1=xregframetitlelayout(figh,'title','General','center',grd,'innerborder',[10 10 10 10]);


% histogram options
ud.hist.usehist=uicontrol('style','checkbox',...
   'parent',figh,...
   'string','Show degeneracy histogram',...
   'position',[0 0 200 20],...
   'value',get(gr.hist.axes,'userdata'));

txt(1)=uicontrol('style','text',...
   'parent',figh,...
   'position',[0 0 80 15],...
   'string','Number of bars:',...
   'horizontalalignment','left');
ptchud = get(gr.hist.patch,'userdata');
numbars = ptchud.numbars;
if isempty(numbars)
   auto=1;
   str='50';
else
   auto=0;
   str=num2str(numbars);
end
ud.hist.numbars=uicontrol('style','edit',...
   'parent',figh,...
   'position',[0 0 50 20],...
   'string',str,...
   'userdata',str,...
   'backgroundcolor','w',...
   'callback',[cbstr '''checknumbars'');']);
ud.hist.autobars=uicontrol('style','togglebutton',...
   'parent',figh,...
   'position',[0 0 40 20],...
   'string','Auto',...
   'value',auto,...
   'callback',[cbstr '''autobars'');']);
if auto
   set(ud.hist.numbars,'enable','off');
end   

div1=xregGui.dividerline(figh);

if strcmp(get(gr.hist.axes,'ygrid'),'on')
   val=1;
else
   val=0;
end
ud.hist.usegrid=uicontrol('style','checkbox',...
   'parent',figh,...
   'string','Show gridlines',...
   'position',[0 0 200 20],...
   'value',val,...
   'callback',[cbstr '''usegrid'');']);
if val
   en='on';
else
   en='off';
end
ud.hist.gridstyletext=uicontrol('style','text',...
   'horizontalalignment','left',...
   'parent',figh,...
   'string','Gridline style:',...
   'position',[0 0 80 15],...
   'enable',en);
val=zeros(2,2);
st=get(gr.hist.axes,'gridlinestyle');
switch lower(st)
case '-'
   val(1)=1;
case ':'
   val(2)=1;
case '--'
   val(3)=1;
case '-.'
   val(4)=1;
otherwise
   val(1)=1;
end
ud.hist.gridstyle=xregGui.rbgroup(figh,'nx',2,'ny',2,'string',{'solid','dashed';'dotted','dash-dot'},...
   'value',val,'position',[0 0 120 40]);

div2=xregGui.dividerline(figh);

txt(2)=uicontrol('style','text',...
   'parent',figh,...
   'horizontalalignment','left',...
   'string','Bar colors:',...
   'position',[0 0 70 15]);

ud.barcol = ptchud.colours;
val=zeros(1,2);
if size(ud.barcol,1)==1
   val(1)=1;
   vis='off';
   str='Color:';
   ud.barcol=[ud.barcol;0 0 0];
else
   val(2)=1;
   vis='on';
   str='Top color:';
end
ud.hist.barcolor.radios=xregGui.rbgroup(figh,'nx',2,'ny',1,'value',val,'string',{'Solid','Gradient'},...
   'callback',[cbstr '''filltype'');'],...
   'position',[0 0 120 20]);

ud.hist.barcolor.text1=uicontrol('style','text',...
   'parent',figh,...
   'horizontalalignment','left',...
   'string',str,...
   'position',[0 0 70 15]);
ud.hist.barcolor.text2=uicontrol('style','text',...
   'parent',figh,...
   'horizontalalignment','left',...
   'string','Bottom color:',...
   'position',[0 0 70 15],...
   'visible',vis);
ud.hist.barcolor.edit1=uicontrol('style','edit',...
   'parent',figh,...
   'backgroundcolor',[1 1 1],...
   'string',['[' num2str(ud.barcol(1,1)) ' ' num2str(ud.barcol(1,2)) ' ' num2str(ud.barcol(1,3)) ']'],...
   'position',[0 0 75 20],...
   'callback',[cbstr '''editchcol'',''hist.barcolor.push1'');']);
ud.hist.barcolor.edit2=uicontrol('style','edit',...
   'parent',figh,...
   'backgroundcolor',[1 1 1],...
   'string',['[' num2str(ud.barcol(2,1)) ' ' num2str(ud.barcol(2,2)) ' ' num2str(ud.barcol(2,3)) ']'],...
   'position',[0 0 75 20],...
   'callback',[cbstr '''editchcol'',''hist.barcolor.push2'');'],...
   'visible',vis);
ud.hist.barcolor.push1=uicontrol('style','toggle',...
   'value',0,...
   'position',[0 0 30 20],...
   'backgroundcolor',ud.barcol(1,:),...
   'callback',[cbstr '''interactivechcol'',''hist.barcolor.edit1'');'],...
   'parent',figh);
ud.hist.barcolor.push2=uicontrol('style','toggle',...
   'value',0,...
   'position',[0 0 30 20],...
   'backgroundcolor',ud.barcol(2,:),...
   'callback',[cbstr '''interactivechcol'',''hist.barcolor.edit2'');'],...
   'parent',figh,...
   'visible',vis);

flw1=xregflowlayout(figh,'orientation','left/center','gap',5,...
   'elements',{txt(1) ud.hist.numbars ud.hist.autobars});
flw2=xregflowlayout(figh,'orientation','left/top','gap',5,...
   'elements',{ud.hist.gridstyletext ud.hist.gridstyle});
flw3=xregflowlayout(figh,'orientation','left/center','gap',5,...
   'elements',{txt(2) ud.hist.barcolor.radios});
flw4=xregflowlayout(figh,'orientation','left/center','gap',5,...
   'elements',{ud.hist.barcolor.text1 ud.hist.barcolor.edit1 ud.hist.barcolor.push1});
flw5=xregflowlayout(figh,'orientation','left/center','gap',5,...
   'elements',{ud.hist.barcolor.text2 ud.hist.barcolor.edit2 ud.hist.barcolor.push2});
grd=xreggridlayout(figh,'correctalg','on','dimension',[9 1],...
   'rowratios',[1 1 .33 1 1.7 .33 1 1 1],...
   'elements',{ud.hist.usehist flw1 div1 ud.hist.usegrid flw2 div2 flw3 flw4 flw5});
frm2=xregframetitlelayout(figh,'title','Histogram',...
   'center',grd,'innerborder',[10 10 10 10]);

lyt=xreggridlayout(figh,'correctalg','on','dimension',[2 1],...
   'rowsizes',[70 -1],'elements',{frm1 frm2},'gap',5);

ud.graph=gr;
set(figh,'userdata',ud);

return




function i_apply(figh)

ud=get(figh,'userdata');
gr=ud.graph;

% update object
vis=get(gr.axes,'visible');
set(gr,'visible','off');
col=get(ud.gen.axcol.push,'backgroundcolor');
set([gr.axes;gr.hist.axes],{'xcolor','ycolor','zcolor'},{col,col,col});
set(get(gr.hist.axes,'title'),'color',col);
set(gr.factortext,'foregroundcolor',col);
set(gr.line,'markerfacecolor',get(ud.gen.lncol.push,'backgroundcolor'));

if get(ud.hist.usehist,'value')
   hist='on';
else
   hist='off';
end
set(gr,'histogram',hist);

if get(ud.hist.autobars,'value')
   nbars='auto';
else
   nbars=str2num(get(ud.hist.numbars,'string'));
end
set(gr,'histogrambars',nbars);     

if get(ud.hist.usegrid,'value')
   grid='on';
else
   grid='off';
end
grids={'-',':','--','-.'};
val=get(ud.hist.gridstyle,'selected');
set(gr.hist.axes,'ygrid',grid,'gridlinestyle',grids{val});

val=get(ud.hist.barcolor.radios,'selected');
if val==1
   % solid
   col=get(ud.hist.barcolor.push1,'backgroundcolor');
else
   % gradient
   col=get([ud.hist.barcolor.push1;ud.hist.barcolor.push2],'backgroundcolor');
   col=cat(1,col{:});
end 
set(gr,'histogramcolor',col);

set(gr,'visible',vis);

return


%========================================================================
% i_getfield......replacement for external getfield
%========================================================================

function [out]=i_getfield(base,ext)
% parse ext for .'s
dots=findstr(ext,'.');
% set up subsrefs structs
if isempty(dots)
   s=struct('type','.','subs',ext);
else
   dots=[1 dots+1 length(ext)+2];
   for n=1:(length(dots)-1)
      sbs(n)={ext(dots(n):(dots(n+1)-2))};
   end
   s=struct('type',repmat({'.'},1,length(dots)-1),'subs',sbs);
end
out=subsref(base,s);
return









