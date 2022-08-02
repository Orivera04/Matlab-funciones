function cont3d(vara,xx,yy,zz,nlines,alph,alphdsc,figur,axe) 
% cont3d(vara,xx,yy,zz,nlines,alph,alphdsc,figur,axe) 3d-matrix visualization.
% vara-input real 3D-array
% xx-vector [xmin xmax]
% yy-vector [ymin ymax]
% zz-vector [zmin zmax]
% nlines-number of isolines in each plane
% alph-maximum value of alpha data (could be from 0 to 1)
% alphdsc-parameter of alpha data scaling. 
%    If alphdsc='a' then alphaData of each point is proportional to absolute value of this point, 
%    if alphdsc='v' then alphaData is proportional to value of input points 
%    if alphdsc='m' then alphaData is scalar,constant for each plane,proportional to mean value of input data in each plane, 
%    if alphdsc='s' then alphaData is scalar,constant for each plane,proportional to max value of input data in each plane.
% figur-number of figure,where to draw
% axe-axe that perpendicular to interest planes.Possible values are:'x','y' or 'z' 
% Author: Eugene V.Makarov makarovv@mail.nnov.ru
%         24/07/2003

siz=size(vara);
xmin=xx(1);xmax=xx(2);xcoef=(xmax-xmin)/siz(1);
ymin=yy(1);ymax=yy(2);ycoef=(ymax-ymin)/siz(2);
zmin=zz(1);zmax=zz(2);zcoef=(zmax-zmin)/siz(3);
%choose way of alphaData scalling
alphd=double(alphdsc=='a');
alphm=double(alphdsc=='m');
alphs=double(alphdsc=='s');
if axe=='x'
    vara=permute(vara,[2 3 1]);
elseif axe=='y'
    vara=permute(vara,[1 3 2]);
end
siz=size(vara);
if axe=='z'
for fff=1:siz(3)
     vary=vara(:,:,fff);
     lims = [1 siz(1) 1 siz(2)];
[c,msg] = contours(vary',nlines); 

limit = size(c,2);i = 1;h = [];color_h = [];
while(i < limit)
  z_level = c(1,i);
  npoints = c(2,i);
  nexti = i+npoints+1;

  xdata = xmin+c(1,i+1:i+npoints)*xcoef;
  ydata = ymin+c(2,i+1:i+npoints)*ycoef;
  zdata = (z_level + 0*xdata);  % Make zdata the same size as xdata
  if alphm+alphs==1,aldata=alph*alphm*mean(mean(vary))/max(mean(mean(vara)))+alph*alphs*max(max(vary))/max(max(max(vara)));  
  else aldata=alph*alphd*abs(zdata')+(1-alphd)*alph*(zdata') ;
  end
  sizzdata=size(zdata);
  heigth=fff+zeros(sizzdata(1),sizzdata(2));
  % Create the patches 
  figure(figur)  
  cu = patch('XData',xdata,'YData',ydata, ...
               'ZData',zmin+heigth*zcoef,'CData',zdata, ... 
               'facecolor','none','edgecolor','flat',...
               'userdata',z_level,'facevertexalphadata',aldata,'edgeAlpha','flat' );hold on;
  
  h = [h; cu(:)];
  color_h = [color_h ; z_level];
  i = nexti;
end
end
elseif axe=='x'
for fff=1:siz(3)
        vary=vara(:,:,fff);
lims = [1 siz(1) 1 siz(2)];
[c,msg] = contours(vary,nlines); 

limit = size(c,2);i = 1;h = [];color_h = [];
while(i < limit)
  x_level = c(1,i);
  npoints = c(2,i);
  nexti = i+npoints+1;

  zdata = zmin+(c(1,i+1:i+npoints))*zcoef;
  ydata = ymin+c(2,i+1:i+npoints)*ycoef;
  xdata = (x_level + 0*zdata);  % Make xdata the same size as zdata
  if alphm+alphs==1,aldata=alph*alphm*mean(mean(vary))/max(mean(mean(vara)))+alph*alphs*max(max(vary))/max(max(max(vara)));  
  else aldata=alph*alphd*abs(xdata')+(1-alphd)*alph*(xdata') ;    
  end 
  sizzdata=size(xdata);
  heigth=fff+zeros(sizzdata(1),sizzdata(2));
  % Create the patches 
  figure(figur)  
  cu = patch('XData',xmin+heigth*xcoef,'YData',ydata, ...
               'ZData',zdata,'CData',xdata, ... 
               'facecolor','none','edgecolor','flat',...
               'userdata',x_level,'facevertexalphadata',aldata,'edgeAlpha','flat' );hold on;
  
  h = [h; cu(:)];
  color_h = [color_h ; x_level];
  i = nexti;
end
end
elseif axe=='y'
   for fff=1:siz(3)
   vary=vara(:,:,fff);
lims = [1 siz(1) 1 siz(2)];
[c,msg] = contours(vary',nlines); 

limit = size(c,2);i = 1;h = [];color_h = [];
while(i < limit)
  y_level = c(1,i);
  npoints = c(2,i);
  nexti = i+npoints+1;

  xdata = xmin+c(1,i+1:i+npoints)*xcoef;
  zdata = zmin+c(2,i+1:i+npoints)*zcoef;
  ydata = y_level + 0*xdata;  % Make ydata the same size as xdata
  sizzdata=size(ydata);
  heigth=fff+zeros(sizzdata(1),sizzdata(2));
  if alphm+alphs==1,aldata=alph*alphm*mean(mean(vary))/max(mean(mean(vara)))+alph*alphs*max(max(vary))/max(max(max(vara)));  
  else aldata=alph*alphd*abs(ydata')+(1-alphd)*alph*(ydata') ;    
  end 
  % Create the patches 
  figure(figur)  
  cu = patch('XData',xdata,'YData',ymin+heigth*ycoef, ...
               'ZData',zdata,'CData',ydata, ... 
               'facecolor','none','edgecolor','flat',...
               'userdata',y_level,'facevertexalphadata',aldata,'edgeAlpha','flat' );hold on;
             h = [h; cu(:)];
  color_h = [color_h ; y_level];
  i = nexti;
end
end
end
view(30,40)