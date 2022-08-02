%epolplof (epsFile,x,y,alpha,radia,color)
% this function write postscript commands in  epsFile to plot data
% written by stefan.mueller@fgan.de (C) 2007

function epolplof(epsFile,x,y,alpha,radia,color)
  if (nargin~=6)
    eusage('epolplof(epsFile,x,y,alpha,radia,color)');
  end
  deg2rad=pi/180;
  rad2deg=180/pi;
  [alpha radia]=edecipol(alpha*deg2rad,radia);
  alpha=alpha*rad2deg;
  nData=size(alpha,2);
  if alpha(1)==alpha(nData) & radia(1)==radia(nData)
    figOpen=0;
  else
    figOpen=1;
  end
  xradia=[alpha; radia];
  nData=2*nData;
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
    fprintf(epsFile,'newpath\n');
    if figOpen
      fprintf(epsFile,'0 plotdata 0 get\n'); 
      fprintf(epsFile,'2 copy cos mul 3 1 roll sin mul moveto\n');
      fprintf(epsFile,'0 2 plotdata length 2 sub\n');
    else
      fprintf(epsFile,'plotdata 1 get plotdata 0 get\n'); 
      fprintf(epsFile,'2 copy cos mul 3 1 roll sin mul moveto\n');
      fprintf(epsFile,'2 2 plotdata length 2 sub\n');
    end
    fprintf(epsFile,'{ dup 1 add plotdata exch get\n');
    fprintf(epsFile,'exch plotdata exch get\n');
    fprintf(epsFile,'2 copy cos mul 3 1 roll sin mul lineto } for\n');
    if figOpen
      fprintf(epsFile,'0 plotdata plotdata length 1 sub get\n');
      fprintf(epsFile,'2 copy cos mul 3 1 roll sin mul lineto\n');
    end
    fprintf(epsFile,'closepath fill stroke\n');
    fprintf(epsFile,'%1.2f %1.2f translate\n',-x,-y);
    fprintf(epsFile,'setrgbcolor\n');
    dataStart=dataEnd+1;
  end
