%exyploti( epsFile,x,y,xData,yData,image,colormap)
% written by stefan.mueller@fgan.de (C) 2007

function exyploti( epsFile,x,y,xData,yData,image,colormap)
  if (nargin~=7)
    eusage('exyploti(epsFile,x,y,xData,yData,image,colormap)');
  end
  [rows colums]=size(xData);
  [xData yData]=edecixy(xData,yData);
  xmin=min(xData);
  xmax=max(xData);
  ymin=min(yData);
  ymax=max(yData);
  nData=size(xData,2);
  xyData=[xData; yData];
  xyData=reshape(xyData,1,2*nData);
  array=sprintf('%1.2f ',xyData);
  fprintf(epsFile,'/plotdata[%s] def\n',array);
  fprintf(epsFile,'%1.2f %1.2f translate\n',x,y);
  fprintf(epsFile,'gsave newpath\n');
  fprintf(epsFile,'plotdata 0 get plotdata 1 get moveto\n');
  fprintf(epsFile,'2 2 plotdata length 2 sub\n');
  fprintf(epsFile,'{ dup plotdata exch get\n');
  fprintf(epsFile,'exch 1 add plotdata exch get\n');
  fprintf(epsFile,'lineto } for\n');
  fprintf(epsFile,'closepath clip\n');
  eimagexy(epsFile,image,colormap,xmin,ymin,xmax-xmin,ymax-ymin);
  fprintf(epsFile,'grestore %1.2f %1.2f translate\n',-x,-y);
