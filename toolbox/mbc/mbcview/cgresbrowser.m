function cgresbrowser(varargin)
% bring up a figure to browse through resouce bitmaps

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.3.2.2 $  $Date: 2004/02/09 08:39:40 $


filtersizes=[];
D=cgrespath;
maxht=0;
maxwid=0;
for n=1:2:nargin
   switch varargin{n}
   case 'filterbysize'
      filtersizes=varargin{n+1};
      maxwid=filtersizes(2);
      maxht=filtersizes(1);
   case 'basedir'
      D=varargin{n+1};
   end
      
end


fig=xregfigure('visible','off',...
   'name','CAGE resource browser');
Ncols=10;
files=dir(fullfile(D,'*.bmp'));

nmedit=uicontrol('parent',fig,'style','edit','horizontalalignment','left');
nmtxt=uicontrol('parent',fig,'style','text','string','Filename:');

keep=ones(1,length(files));
% find maximum height/width
for n=1:length(files)
   im=imread([D '\' files(n).name]);
   sz=size(im);
   sz=sz(1:2);
   if ~isempty(filtersizes)
      if any(sz~=filtersizes)
         keep(n)=0;
      end
   else
      if sz(1)>50
         sz=round(50*sz/sz(1));
      end
      if sz(2)>50
         sz=round(50*sz/sz(2));
      end
      
      if sz(1)>maxht
         maxht=sz(1);
      end
      if sz(2)>maxwid
         maxwid=sz(2);
      end
   end
end

files=files(keep~=0);

Nrows=ceil(length(files)./Ncols);
els=cell(1,length(files));
cbfn=@i_imclick;

% create images with border if necessary
for n=1:length(files)
   im=imread([D '\' files(n).name]);
   sz=size(im);
   iobj=xregGui.axesimage('parent',fig,'image',im,'buttondownfcn',{cbfn,files(n).name,nmedit});
   if sz(1)<maxht | sz(2)<maxwid
      brdx=(maxwid-sz(2))./2;
      brdy=(maxht-sz(1))./2;
      iobj=xreglayerlayout(double(fig),'elements',{iobj},'border',[floor(brdx) floor(brdy) ceil(brdx) ceil(brdy)]);
   end
   els(n)={iobj};
end

g=xreggridlayout(double(fig),'hscroll','on','vscroll','on','gap',0,'dimension',[Nrows Ncols],...
   'elements',els,'packstatus','off','rowsizes',repmat(maxht,1,Nrows),'colsizes',repmat(maxwid,1,Ncols));
g=xregpanellayout(double(fig),'center',g,'innerborder',[0 0 0 0]);
lyt=xreggridbaglayout(double(fig),'dimension',[2 2],'rowsizes',[-1 20],'colsizes',[100 -1],...
   'gapy',10,...
   'mergeblock',{[1 1],[1 2]},'elements',{g,nmtxt,[],nmedit},...
   'border',[0 10 0 0]);

fig.LayoutManager=lyt;
set(lyt,'packstatus','on');
set(fig,'visible','on');
   
   
   

function i_imclick(srocj,evt,name,edtH)
set(edtH,'string',name);






