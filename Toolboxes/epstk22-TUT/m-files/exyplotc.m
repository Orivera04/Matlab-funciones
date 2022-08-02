%exyplotc ( epsFile,x,y,xData,yData,color,dash,lineWidth)
% written by Stefan Mueller stefan.mueller@fgan.de (C) 2003

function exyplotc(epsFile,x,y,xData,yData,color,dash,lineWidth)
  if (nargin~=8)
    eusage('exyplotc(epsFile,x,y,xData,yData,color,dash,lineWidth)');
  end
  [rows colums]=size(xData);
  if rows==1
    nData=colums;
    xyData=[xData; yData];
  else
    nData=rows;
    xyData=[xData'; yData'];
  end
  xyData=reshape(xyData,1,2*nData);
  nCurveData=nData-rem(nData-1,3);
  nData=2*nCurveData;
  dataStart=1;
  while dataStart+2<nData
    dataEnd=dataStart+49999;
    if dataEnd>nData
      dataEnd=nData;
    end
    array=sprintf('%1.2f ',xyData(dataStart:dataEnd));
    fprintf(epsFile,'/plotdata[%s] def\n',array);
    if dash>0
      fprintf(epsFile,'[%1.2f %1.2f] 0 setdash\n',dash,dash);
    end
    fprintf(epsFile,'currentrgbcolor %1.2f %1.2f %1.2f setrgbcolor\n',...
            color(1),color(2),color(3));
    fprintf(epsFile,'%1.2f %1.2f translate\n',x,y);
    fprintf(epsFile,'newpath\n');
    fprintf(epsFile,'plotdata 0 get plotdata 1 get moveto\n');
    fprintf(epsFile,'2 6 plotdata length 2 sub\n');
    fprintf(epsFile,'{ dup plotdata exch get\n');
    fprintf(epsFile,'exch 1 add dup plotdata exch get\n');
    fprintf(epsFile,'exch 1 add dup plotdata exch get\n');
    fprintf(epsFile,'exch 1 add dup plotdata exch get\n');
    fprintf(epsFile,'exch 1 add dup plotdata exch get\n');
    fprintf(epsFile,'exch 1 add plotdata exch get\n');
    fprintf(epsFile,'curveto } for\n');
    fprintf(epsFile,'%1.2f setlinewidth\n',lineWidth);
    if dash<0 
      fprintf(epsFile,'closepath fill\n');
    else
      fprintf(epsFile,'stroke\n');
    end
    fprintf(epsFile,'%1.2f %1.2f translate\n',-x,-y);
    fprintf(epsFile,'setrgbcolor\n');
    fprintf(epsFile,'[] 0 setdash\n');
    dataStart=dataEnd-1;
  end
