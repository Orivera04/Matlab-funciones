%erect ( epsFile,x,y,width,height,lineWidth,color,dash,rotation,cornerRadius)
% written by stefan.mueller@fgan.de (C) 2007

function erectrc(epsFile,x,y,width,height,lineWidth,color,dash,rotation,cornerRadius)
  if (nargin~=10)
    eusage('erectrc(epsFile,x,y,width,height,lineWidth,color,dash,rotation,cornerRadius)');
  end
  eglobpar
  if size(dash,1)==1
    dash=dash*eFac;
    cornerRadius=cornerRadius-lineWidth/2;
    width=width-lineWidth;
    height=height-lineWidth;
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
    fprintf(epsFile,'gsave\n');
    fprintf(epsFile,'%1.2f %1.2f %1.2f setrgbcolor\n',...
                     color(1),color(2),color(3));
    fprintf(epsFile,'%1.2f %1.2f translate\n',x,y);
    fprintf(epsFile,'%1.2f rotate\n',rotation);
    fprintf(epsFile,'%1.2f dup translate\n',lineWidth/2);
    for i=1:nDash
      if dash(1)>0
        fprintf(epsFile,'[%1.2f %1.2f] %1.2f setdash\n',...
	  dashList(i,1),dashList(i,2),dashList(i,3));
      end
      fprintf(epsFile,'newpath\n');
      fprintf(epsFile,'%1.2f %1.2f moveto\n',...
        width-cornerRadius+lineWidth/2,0);
      fprintf(epsFile,'%1.2f 0 %1.2f %1.2f %1.2f arcto\n',...
        width,width,height-cornerRadius,cornerRadius);
      fprintf(epsFile,'%1.2f %1.2f %1.2f %1.2f %1.2f arcto\n',...
        width,height,cornerRadius,height,cornerRadius);
      fprintf(epsFile,'0 %1.2f 0 %1.2f %1.2f arcto\n',...
        height,cornerRadius,cornerRadius);
      fprintf(epsFile,'0 0 %1.2f 0 %1.2f arcto\n',...
        cornerRadius,cornerRadius);
      fprintf(epsFile,'closepath\n');
      fprintf(epsFile,'%1.2f setlinewidth\n',lineWidth);
      if dash(1)<0
        fprintf(epsFile,'fill\n');
      else
        fprintf(epsFile,'stroke\n');
      end
    end
    fprintf(epsFile,'grestore\n');
  else
    cornerRadius=cornerRadius-lineWidth;
    width=width-2*lineWidth;
    height=height-2*lineWidth;
    fprintf(epsFile,'gsave\n');
    fprintf(epsFile,'%1.2f %1.2f translate\n',x,y);
    fprintf(epsFile,'%1.2f rotate\n',rotation);
    fprintf(epsFile,'%1.2f dup translate\n',lineWidth);
    fprintf(epsFile,'newpath\n');
    fprintf(epsFile,'%1.2f dup %1.2f add exch moveto\n',...
      lineWidth,width-cornerRadius);
    fprintf(epsFile,'%1.2f 0 moveto\n',width-cornerRadius);
    fprintf(epsFile,'%1.2f 0 %1.2f %1.2f %1.2f arcto\n',...
      width,width,height-cornerRadius,cornerRadius);
    fprintf(epsFile,'%1.2f %1.2f %1.2f %1.2f %1.2f arcto\n',...
      width,height,cornerRadius,height,cornerRadius);
    fprintf(epsFile,'0 %1.2f 0 %1.2f %1.2f arcto\n',...
      height,cornerRadius,cornerRadius);
    fprintf(epsFile,'0 0 %1.2f 0 %1.2f arcto\n',...
      cornerRadius,cornerRadius);
    fprintf(epsFile,'closepath clip\n');
    eimagexy(epsFile,dash,color,0,0,width,height);
    fprintf(epsFile,'grestore\n');
  end
