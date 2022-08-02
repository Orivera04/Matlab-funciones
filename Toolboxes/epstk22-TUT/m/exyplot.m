%exyplot ( epsFile,x,y,xData,yData,color,dash,lineWidth)
% written by stefan.mueller@fgan.de (C) 2007

function exyplot ( epsFile,x,y,xData,yData,color,dash,lineWidth,interpol)
  if (nargin~=9)
    eusage('exyplot(epsFile,x,y,xData,yData,color,dash,lineWidth,interpol)');
  end
  [xData yData]=edecixy(xData,yData);
  xyData=[xData; yData];
  nData=size(xData,2)*2;
  xyData=reshape(xyData,1,nData);
  step=2;
  if interpol
    nData=nData-rem(nData-2,6);
    xyData=xyData(1:nData);
    step=6;
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
  dataStart=1;
  fprintf(epsFile,'%1.2f %1.2f translate\n',x,y);
  fprintf(epsFile,'currentrgbcolor %1.2f %1.2f %1.2f setrgbcolor\n',...
          color(1),color(2),color(3));
  while dataStart+step<nData
    dataEnd=dataStart+47999;
    if dataEnd>nData
      dataEnd=nData;
    end
    array=sprintf('%1.2f ',xyData(dataStart:dataEnd));
    fprintf(epsFile,'/plotdata[%s] def\n',array);
    for i=1:nDash
      if dash(1)>0
        fprintf(epsFile,'[%1.2f %1.2f] %1.2f setdash\n',...
	  dashList(i,1),dashList(i,2),dashList(i,3));
      end
      fprintf(epsFile,'newpath\n');
      fprintf(epsFile,'plotdata 0 get plotdata 1 get moveto\n');
      if (interpol)
        fprintf(epsFile,'2 6 plotdata length 6 sub\n');
        fprintf(epsFile,'{ dup plotdata exch get\n');
        fprintf(epsFile,'exch 1 add dup plotdata exch get\n');
        fprintf(epsFile,'exch 1 add dup plotdata exch get\n');
        fprintf(epsFile,'exch 1 add dup plotdata exch get\n');
        fprintf(epsFile,'exch 1 add dup plotdata exch get\n');
        fprintf(epsFile,'exch 1 add plotdata exch get\n');
        fprintf(epsFile,'curveto } for\n');
      else 
        fprintf(epsFile,'2 2 plotdata length 2 sub\n');
        fprintf(epsFile,'{ dup plotdata exch get\n');
        fprintf(epsFile,'exch 1 add plotdata exch get\n');
        fprintf(epsFile,'lineto } for\n');
      end
      fprintf(epsFile,'%1.2f setlinewidth\n',lineWidth);
      fprintf(epsFile,'stroke\n');
    end
    dataStart=dataEnd-step;
  end
  fprintf(epsFile,'setrgbcolor\n');
  fprintf(epsFile,'[] 0 setdash\n');
  fprintf(epsFile,'%1.2f %1.2f translate\n',-x,-y);
