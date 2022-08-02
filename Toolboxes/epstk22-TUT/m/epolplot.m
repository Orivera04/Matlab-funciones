%epolplot ( epsFile,x,y,alpha,radia,color,dash,lineWidth)
% written by stefan.mueller@fgan.de (C) 2007

function epolplot ( epsFile,x,y,alpha,radia,color,dash,lineWidth)
  if (nargin~=8)
    eusage('epolplot(epsFile,x,y,alpha,radia,color,dash,lineWidth)');
  end
  nDash=1;
  if dash(1)>0 
    if length(dash)>1
      nDash=length(dash)-1;
	dashSpace=dash(1);
	dashSum=sum(dash(2:nDash+1));
	dashL=dashSpace*nDash+dashSum;
	dashList=zeros(nDash,3);
	for i=1:nDash
        dashList(i,1)=dash(i+1);  	  
        dashList(i,2)=dashL-dash(i+1);  	  
	  dashList(i,3)=dashL-(dashSpace*(i-1)+sum(dash(2:i)));
      end
    else
      nDash=1;
      dashList=[dash(1) dash(1) 0]; 
    end
  end
  deg2rad=pi/180;
  rad2deg=180/pi;
  [alpha radia]=edecipol(alpha*deg2rad,radia);
  alpha=alpha*rad2deg;
  nData=size(alpha,2)*2;
  xradia=[alpha; radia];
  xradia=reshape(xradia,1,nData);
  dataStart=1;
  step=2;
  fprintf(epsFile,'%1.2f %1.2f translate\n',x,y);
  fprintf(epsFile,'currentrgbcolor %1.2f %1.2f %1.2f setrgbcolor\n',...
          color(1),color(2),color(3));
  while dataStart+step<nData
    dataEnd=dataStart+47999;
    if dataEnd>nData
      dataEnd=nData;
    end
    array=sprintf('%1.2f ',xradia(dataStart:dataEnd));
    fprintf(epsFile,'/plotdata[%s] def\n',array);
    for i=1:nDash
      if dash(1)>0
        fprintf(epsFile,'[%1.2f %1.2f] %1.2f setdash\n',...
          dashList(i,1),dashList(i,2),dashList(i,3));
      end
      fprintf(epsFile,'newpath\n');
      fprintf(epsFile,'plotdata 1 get plotdata 0 get\n'); 
      fprintf(epsFile,'2 copy cos mul 3 1 roll sin mul moveto\n');
      fprintf(epsFile,'2 2 plotdata length 2 sub\n');
      fprintf(epsFile,'{ dup 1 add plotdata exch get\n');
      fprintf(epsFile,'exch plotdata exch get\n');
      fprintf(epsFile,'2 copy cos mul 3 1 roll sin mul lineto } for\n');
      fprintf(epsFile,'%1.2f setlinewidth\n',lineWidth);
      fprintf(epsFile,'stroke\n');
    end
    dataStart=dataEnd-step;
  end
  fprintf(epsFile,'setrgbcolor\n');
  fprintf(epsFile,'[] 0 setdash\n');
  fprintf(epsFile,'%1.2f %1.2f translate\n',-x,-y);
