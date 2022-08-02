%eclip (epsFile,x,y,width,height)
% written by stefan.mueller@fgan.de (C) 2007

function eclip (epsFile,x,y,width,height)
  if nargin~=5
    eusage('eclip(epsFile,x,y,width,height)');
  end
  if width~=0
    fprintf(epsFile,'gsave newpath %1.2f %1.2f moveto\n',x,y);
    fprintf(epsFile,'%1.2f %1.2f lineto\n',x+width,y);
    fprintf(epsFile,'%1.2f %1.2f lineto\n',x+width,y+height);
    fprintf(epsFile,'%1.2f %1.2f lineto closepath clip\n',...
            x,y+height);
  else
    fprintf(epsFile,'grestore\n');
  end
