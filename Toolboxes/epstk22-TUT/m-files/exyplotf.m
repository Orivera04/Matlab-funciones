%exyplotf ( epsFile,x,y,xData,yData,color)
% written by Stefan Mueller stefan.mueller@fgan.de (C) 2003

function exyplotf ( epsFile,x,y,xData,yData,color)
  if (nargin~=6)
    eusage('exyplotf(epsFile,x,y,xData,yData,color)');
  end
  [rows colums]=size(xData);
  if rows==1
    nData=colums;
    xyData=[xData; yData];
  else
    nData=rows;
    xyData=[xData'; yData'];
  end
  if xData(1)==xData(nData) & yData(1)==yData(nData)
    figOpen=0;
  else
    figOpen=1;
  end
  nData=2*nData;
  xyData=reshape(xyData,1,nData);
  array=sprintf('%1.2f ',xyData);
  fprintf(epsFile,'/plotdata[%s] def\n',array);
  fprintf(epsFile,'currentrgbcolor %1.2f %1.2f %1.2f setrgbcolor\n',...
          color(1),color(2),color(3));
  fprintf(epsFile,'%1.2f %1.2f translate\n',x,y);
  fprintf(epsFile,'newpath\n');
  if figOpen
    fprintf(epsFile,'plotdata 0 get 0 moveto\n');
    fprintf(epsFile,'0 2 plotdata length 2 sub\n');
  else
    fprintf(epsFile,'plotdata 0 get plotdata 1 get moveto\n');
    fprintf(epsFile,'2 2 plotdata length 2 sub\n');
  end
  fprintf(epsFile,'{ dup plotdata exch get\n');
  fprintf(epsFile,'exch 1 add plotdata exch get\n');
  fprintf(epsFile,'lineto } for\n');
  if figOpen
    fprintf(epsFile,'plotdata plotdata length 2 sub get 0 lineto\n');
  end
  fprintf(epsFile,'closepath\n');
  fprintf(epsFile,'fill\n');
  fprintf(epsFile,'stroke\n');
  fprintf(epsFile,'%1.2f %1.2f translate\n',-x,-y);
  fprintf(epsFile,'setrgbcolor\n');
