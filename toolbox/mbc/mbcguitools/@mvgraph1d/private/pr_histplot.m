function pr_histplot(gr)
%GRAPH1D/PRIVATE/PR_HISTPLOT
%   Private function for updating histogram of graph1d objects

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:19:18 $

%  Date: 16/9/1999

data=get(gr.line,'userdata');
if ~isempty(data)
   ud=get(gr.hist.patch,'userdata');
   xval=get(gr.factorsel,'value');
   data=data(:,xval);
   
   % decide number of bins: aim to have each one about 5 pixels wide if auto is set
   pos=get(gr.hist.axes,'position');
   if isempty(ud.numbars)
      nbins=round(pos(3)./5);
   else
      nbins=ud.numbars;
   end
   % need to construct an edges vector to pass to histc
   mnmx=get(gr.axes,'xlim');
   % The above are the limits on the data axis.  The histogram axis is a couple of
   % pixels bigger:
   
   mnmx(1)=mnmx(1)-2*(mnmx(2)-mnmx(1))./(pos(3)-4);
   mnmx(2)=mnmx(2)+2*(mnmx(2)-mnmx(1))./(pos(3)-4);
   
   interval=(mnmx(2)+10*eps-mnmx(1))./nbins;
   edges=[mnmx(1):interval:(mnmx(2)+10*eps)];
   
   N=histc(data,edges);
   N=N(1:end-1);
   
   xd=[edges(:)';edges(:)';edges(:)'];
   xd=reshape(xd,1,length(xd(:)));
   xd=xd(2:end-1)';
   yd=[zeros(1,length(N));N(:)';N(:)'];
   yd=reshape(yd,1,length(yd(:)));
   yd=[yd 0]';
   zd=zeros(length(xd),1);
   vert=[xd,yd,zd];
   
   % make each bar a separate face
   fac=[[1:3:length(xd)-3]', [2:3:length(xd)-2]',[3:3:length(xd)-1]',[4:3:length(xd)]'];
   
   cols=ud.colours;
   if length(cols(:))>3   
      colors=[repmat([cols(2,:);cols(1,:);cols(1,:)],round(length(xd)/3),1); cols(2,:)];
      shading='interp';
   else
      colors=cols;
      shading='flat';
   end
   
   set(gr.hist.axes,'xlim',mnmx,'ytickmode','auto','ylim',[0 max([1;N(:)])]);
   set(gr.hist.patch,'faces',fac,'vertices',vert,'facevertexcdata',colors,'facecolor',shading);
else
   % plot empty histogram
   set(gr.hist.patch,'faces',1,'vertices',[0 0],'facevertexcdata',[0 0 0],'facecolor','flat');
end
return

