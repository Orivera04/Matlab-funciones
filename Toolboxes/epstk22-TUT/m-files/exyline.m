%exyline ( epsFile,x,y,xData,yData,color,dash,lineWidth)
% written by Stefan Mueller stefan.mueller@fgan.de (C) 2003

function exyline ( epsFile,x,y,xData,yData,color,dash,lineWidth)
  if (nargin~=8)
    eusage('exyline(epsFile,x,y,xData,yData,color,dash,lineWidth)');
  end
  [rows colums]=size(xData);
  if rows==1
    nData=2*colums;
    xyData=[xData; yData];
  else
    nData=2*rows;
    xyData=[xData'; yData'];
  end
  xyData=reshape(xyData,1,nData);
  dataStart=1;
  while dataStart<nData
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
    fprintf(epsFile,'0 4 plotdata length 4 sub\n');
    fprintf(epsFile,'{ dup dup dup plotdata exch get\n');
    fprintf(epsFile,'exch 1 add plotdata exch get moveto\n');
    fprintf(epsFile,'2 add plotdata exch get\n');
    fprintf(epsFile,'exch 3 add plotdata exch get lineto } for\n');
    fprintf(epsFile,'%1.2f setlinewidth\n',lineWidth);
    fprintf(epsFile,'stroke\n');
    fprintf(epsFile,'%1.2f %1.2f translate\n',-x,-y);
    fprintf(epsFile,'setrgbcolor\n');
    fprintf(epsFile,'[] 0 setdash\n');
    dataStart=dataEnd+1;
  end
