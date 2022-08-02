%erect ( epsFile , x , y , width , height , lineWidth, color, dash, rotation)
% written by Stefan Mueller stefan.mueller@fgan.de (C) 2003

function erect(epsFile,x,y,width,height,lineWidth,color,dash,rotation)
  if (nargin~=9)
    eusage('erect(epsFile,x,y,width,height,lineWidth,color,dash,rotation)');
  end
  if max(size(dash))==1
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
    fprintf(epsFile,'newpath %1.2f dup moveto\n',lineWidth/2);
    fprintf(epsFile,'%1.2f 0 rlineto\n',width);
    fprintf(epsFile,'0 %1.2f rlineto\n',height);
    fprintf(epsFile,'%1.2f 0 rlineto\n',-width);
    fprintf(epsFile,'0 %1.2f rlineto\n',-height);
    fprintf(epsFile,'closepath\n');
    fprintf(epsFile,'%1.2f setlinewidth\n',lineWidth);
    if dash<0
      fprintf(epsFile,'fill\n');
    else
      fprintf(epsFile,'stroke\n');
    end
    fprintf(epsFile,'grestore\n');
  else
    width=width-2*lineWidth;
    height=height-2*lineWidth;
    fprintf(epsFile,'gsave\n');
    fprintf(epsFile,'%1.2f %1.2f translate\n',x,y);
    fprintf(epsFile,'%1.2f rotate\n',rotation);
    eimagexy(epsFile,dash,color,lineWidth,lineWidth,...
      width,height);
    fprintf(epsFile,'grestore\n');
  end
