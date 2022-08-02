%exyplotf ( epsFile,x,y,xData,yData,color)
% written by stefan.mueller@fgan.de (C) 2007

function exyplotf ( epsFile,x,y,xData,yData,color,interpol)
  if (nargin~=7)
    eusage('exyplotf(epsFile,x,y,xData,yData,color,interpol)');
  end
  [xData yData]=edecixy(xData,yData);
  nData=size(xData,2);
  if xData(1)==xData(nData) & yData(1)==yData(nData)
    figOpen=0;
  else
    figOpen=1;
  end
  xyData=[xData; yData];
  nData=2*nData;
  xyData=reshape(xyData,1,nData);
  if interpol 
     nData=nData-rem(nData-2,6);
     xyData=xyData(1:nData);
  end
  array=sprintf('%1.2f ',xyData);
  fprintf(epsFile,'/plotdata[%s] def\n',array);
  fprintf(epsFile,'currentrgbcolor %1.2f %1.2f %1.2f setrgbcolor\n',...
          color(1),color(2),color(3));
  fprintf(epsFile,'%1.2f %1.2f translate\n',x,y);
  fprintf(epsFile,'newpath\n');
  if interpol 
    if figOpen
     fprintf(epsFile,'plotdata 0 get dup 0 moveto\n');
     fprintf(epsFile,'plotdata 1 get lineto\n');
     fprintf(epsFile,'2 6 plotdata length 6 sub\n');
   else
     fprintf(epsFile,'plotdata 0 get plotdata 1 get moveto\n');
     fprintf(epsFile,'2 6 plotdata length 6 sub\n');
   end
    fprintf(epsFile,'{ dup plotdata exch get\n');
    fprintf(epsFile,'exch 1 add dup plotdata exch get\n');
    fprintf(epsFile,'exch 1 add dup plotdata exch get\n');
    fprintf(epsFile,'exch 1 add dup plotdata exch get\n');
    fprintf(epsFile,'exch 1 add dup plotdata exch get\n');
    fprintf(epsFile,'exch 1 add plotdata exch get\n');
    fprintf(epsFile,'curveto } for\n');
  else
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
  end
  if figOpen
    fprintf(epsFile,'plotdata plotdata length 2 sub get 0 lineto\n');
  end
  fprintf(epsFile,'closepath\n');
  fprintf(epsFile,'fill\n');
  fprintf(epsFile,'%1.2f %1.2f translate\n',-x,-y);
  fprintf(epsFile,'setrgbcolor\n');
