%epolplos ( epsFile,x,y,alpha,radia,dash,color)
% written by stefan.mueller@fgan.de (C) 2007

function epolplos ( epsFile,x,y,alpha,radia,dash,color)
  if (nargin~=7)
    eusage('epolplos(epsFile,x,y,alpha,radia,dash,color)');
  end
  deg2rad=pi/180;
  rad2deg=180/pi;
  [alpha radia]=edecipol(alpha*deg2rad,radia);
  alpha=alpha*rad2deg;
  nData=size(alpha,2)*2;
  xradia=[alpha; radia];
  xradia=reshape(xradia,1,nData);
  dataStart=1;
  while dataStart<nData
    dataEnd=dataStart+47999;
    if dataEnd>nData
      dataEnd=nData;
    end
    array=sprintf('%1.2f ',xradia(dataStart:dataEnd));
    fprintf(epsFile,'/plotdata[%s] def\n',array);
    fprintf(epsFile,'currentrgbcolor %1.2f %1.2f %1.2f setrgbcolor\n',...
            color(1),color(2),color(3));
    fprintf(epsFile,'%1.2f %1.2f translate\n',x,y);
    fprintf(epsFile,'0 2 plotdata length 2 sub\n');
    fprintf(epsFile,'{ dup 1 add plotdata exch get\n');
    fprintf(epsFile,'exch plotdata exch get\n');
    fprintf(epsFile,'dup rotate exch dup 0 translate %s\n',dash);
    fprintf(epsFile,'neg 0 translate neg rotate} for\n');
    fprintf(epsFile,'%1.2f %1.2f translate\n',-x,-y);
    fprintf(epsFile,'setrgbcolor\n');
    dataStart=dataEnd+1;
  end
