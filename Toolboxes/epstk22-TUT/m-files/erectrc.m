%erect ( epsFile,x,y,width,height,lineWidth,color,dash,rotation,cornerRadius)
% written by Stefan Mueller stefan.mueller@fgan.de (C) 2003

function erectrc(epsFile,x,y,width,height,lineWidth,color,dash,rotation,cornerRadius)
  if (nargin~=10)
    eusage('erectrc(epsFile,x,y,width,height,lineWidth,color,dash,rotation,cornerRadius)');
  end
  if max(size(dash))==1
    cornerRadius=cornerRadius-lineWidth/2;
    width=width-lineWidth;
    height=height-lineWidth;
    fprintf(epsFile,'gsave\n');
    if dash>0
      fprintf(epsFile,'[%1.2f %1.2f] 0 setdash\n',dash,dash);
    end
    fprintf(epsFile,'%1.2f %1.2f %1.2f setrgbcolor\n',...
                     color(1),color(2),color(3));
    fprintf(epsFile,'%1.2f %1.2f translate\n',x,y);
    fprintf(epsFile,'%1.2f rotate\n',rotation);
    fprintf(epsFile,'%1.2f dup translate\n',lineWidth/2);
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
    if dash<0
      fprintf(epsFile,'fill\n');
    else
      fprintf(epsFile,'stroke\n');
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
