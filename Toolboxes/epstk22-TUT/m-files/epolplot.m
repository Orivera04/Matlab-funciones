%epolplot ( epsFile,x,y,alpha,radia,color,dash,lineWidth)
% written by Stefan Mueller stefan.mueller@fgan.de (C) 2003

function epolplot ( epsFile,x,y,alpha,radia,color,dash,lineWidth)
  if (nargin~=8)
    eusage('epolplot(epsFile,x,y,alpha,radia,color,dash,lineWidth)');
  end
  [rows colums]=size(alpha);
  if rows==1
    nData=2*colums;
    xradia=[alpha; radia];
  else
    nData=2*rows;
    xradia=[alpha'; radia'];
  end 
  xradia=reshape(xradia,1,nData);
  dataStart=1;
  while dataStart+2<nData
    dataEnd=dataStart+49999;
    if dataEnd>nData
      dataEnd=nData;
    end
    array=sprintf('%1.2f ',xradia(dataStart:dataEnd));
    fprintf(epsFile,'/plotdata[%s] def\n',array);
    if dash>0
      fprintf(epsFile,'[%1.2f %1.2f] 0 setdash\n',dash,dash);
    end
    fprintf(epsFile,'currentrgbcolor %1.2f %1.2f %1.2f setrgbcolor\n',...
            color(1),color(2),color(3));
    fprintf(epsFile,'%1.2f %1.2f translate\n',x,y);
    fprintf(epsFile,'newpath\n');
    fprintf(epsFile,'plotdata 1 get plotdata 0 get\n'); 
    fprintf(epsFile,'2 copy cos mul 3 1 roll sin mul moveto\n');
    fprintf(epsFile,'2 2 plotdata length 2 sub\n');
    fprintf(epsFile,'{ dup 1 add plotdata exch get\n');
    fprintf(epsFile,'exch plotdata exch get\n');
    fprintf(epsFile,'2 copy cos mul 3 1 roll sin mul lineto } for\n');
    fprintf(epsFile,'%1.2f setlinewidth\n',lineWidth);
    fprintf(epsFile,'stroke\n');
    fprintf(epsFile,'%1.2f %1.2f translate\n',-x,-y);
    fprintf(epsFile,'setrgbcolor\n');
    fprintf(epsFile,'[] 0 setdash\n');
    dataStart=dataEnd-1;
  end
