%eclippol (epsFile,x,y,minRadius,maxRadius,angleStart,angleEnd)
% written by Stefan Mueller stefan.mueller@fgan.de (C) 2003

function eclippol(epsFile,x,y,minRadius,maxRadius,angleStart,angleEnd)
  if nargin~=7 & nargin~=1
    eusage('eclippol(epsFile,x,y,minRadius,maxRadius,angleStart,angleEnd)');
  end
  if nargin~=1
    moveForm='%1.2f %1.2f 2 copy cos mul 3 1 roll sin mul moveto\n';
    arcForm='0 0 %1.2f %1.2f %1.2f arc\n';
    arcnForm='0 0 %1.2f %1.2f %1.2f arcn\n';
    fprintf(epsFile,'gsave %1.2f %1.2f 2 copy translate newpath\n',x,y);
    fprintf(epsFile,moveForm,minRadius,angleStart);
    fprintf(epsFile,arcForm,maxRadius,angleStart,angleEnd);
    fprintf(epsFile,arcnForm,minRadius,angleEnd,angleStart);
    fprintf(epsFile,'closepath clip neg exch neg exch translate\n');
  else
    fprintf(epsFile,'grestore\n');
  end
