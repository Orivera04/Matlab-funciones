%exyplots( epsFile,x,y,xData,yData,dash,color)
% written by stefan.mueller@fgan.de (C) 2007

function exyplots( epsFile,x,y,xData,yData,xScale,yScale,angle,dash,color)
  if (nargin~=10)
    eusage('exyplots(epsFile,x,y,xData,yData,xScale,yScale,angle,dash,color)');
  end
  [rows colums]=size(xData);
  if rows==1
    nData=colums;
    xyData=[xData; yData; xScale; yScale; angle];
  else
    nData=rows;
    xyData=[xData'; yData'; xScale'; yScale'; angle'];
  end
  xyData=reshape(xyData,1,5*nData);
  array=sprintf('%1.2f ',xyData);
  fprintf(epsFile,'/pdata[%s] def\n',array);
  fprintf(epsFile,'currentrgbcolor %1.2f %1.2f %1.2f setrgbcolor\n',...
          color(1),color(2),color(3));
  fprintf(epsFile,'%1.2f %1.2f translate\n',x,y);
  fprintf(epsFile,'0 5 pdata length 5 sub\n');
  fprintf(epsFile,'{ gsave dup dup dup dup pdata exch get\n');
  fprintf(epsFile,'exch 1 add pdata exch get translate\n');
  fprintf(epsFile,'4 add pdata exch get rotate\n');
  fprintf(epsFile,'2 add pdata exch get exch 3 add pdata exch get scale\n');
  fprintf(epsFile,' %s grestore }for\n',dash);
  fprintf(epsFile,'%1.2f %1.2f translate\n',-x,-y);
  fprintf(epsFile,'setrgbcolor\n');
