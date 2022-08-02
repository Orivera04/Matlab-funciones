%etextxy(epsFile,x,y,rotation,alignment,text,font,size,color)
% this function write postscript commands in  epsFile to draw a West scale
% written by Stefan Mueller stefan.mueller@fgan.de (C) 2003

function etextxy(epsFile,x,y,rotation,alignment,text,font,fontSize,color)
  if (nargin~=9)
    eusage('etextxy(epsFile,x,y,rotation,alignment,text,font,fontSize,color)');
  end
  fprintf(epsFile,'currentrgbcolor %1.2f %1.2f %1.2f setrgbcolor\n',...
          color(1),color(2),color(3));
  if x~=0
    fprintf(epsFile,'%1.2f %1.2f moveto\n',x,y);
  else
    fprintf(epsFile,'0 %1.2f rmoveto\n',y);
  end
  if length(fontSize)>2
    fprintf(epsFile,...
      '/%s findfont [%1.2f 0 %1.2f %1.2f 0 0] makefont setfont\n',...
      font,fontSize(1),fontSize(2)*tan(fontSize(3)*pi/180),fontSize(2));
  else
    fprintf(epsFile,'/%s findfont %1.2f scalefont setfont\n',font,fontSize(1));
  end
  if rotation~=0
    if (alignment==0) | (alignment==3)
      fprintf(epsFile,'(%s) stringwidth pop 2 div %1.2f 2 copy\n',text,rotation);
      fprintf(epsFile,'cos mul 3 1 roll sin mul\n');
    elseif (alignment==1) | (alignment==4)
      fprintf(epsFile,'(%s) stringwidth pop %1.2f 2 copy\n',text,rotation);
      fprintf(epsFile,'cos mul 3 1 roll sin mul\n');
    else
      fprintf(epsFile,'0 0\n');
    end
    fprintf(epsFile,'gsave %1.2f rotate\n',rotation);
  end
  if alignment==0
    fprintf(epsFile,...
      '(%s) dup stringwidth pop dup 2 div sub neg 0 rmoveto show\n',text);
  elseif alignment==3
    fprintf(epsFile,...
      '(%s) dup stringwidth pop dup 2 div sub neg %1.2f rmoveto show\n',...
      text,-fontSize(1)/4);
  elseif alignment==1
    fprintf(epsFile,...
      '(%s) show\n',text);
  elseif alignment==4
    fprintf(epsFile,...
      '(%s) 0 %1.2f rmoveto show\n',text,-fontSize(1)/4);
  elseif alignment==2
    fprintf(epsFile,...
      '(%s) dup stringwidth pop neg %1.2f rmoveto show\n',text,-fontSize(1)/4);
  else
    fprintf(epsFile,...
      '(%s) dup stringwidth pop neg 0 rmoveto show\n',text);
  end
  if rotation~=0
    fprintf(epsFile,'grestore rmoveto\n');
  end
