%egridcl(epsFile,side,x,y,length,valueStart,valueStep,valueEnd,nMax,
%        lineLength,lineWidth,color,dash)
% written by Stefan Mueller stefan.mueller@fgan.de (C) 2003

function egridcl(epsFile,side,x,y,length,valueStart,valueStep,valueEnd,...
                 nMax,lineLength,lineWidth,color,dash)
  if (nargin~=13)
    eusage(...
   'egridcl(epsFile,side,x,y,length,valueStart,valueStep,valueEnd,nMax,lineLength,lineWidth,color,dash)')
  end

  startEndDiff=valueEnd-valueStart;  
  signOfDiff=sign(startEndDiff);
  if valueStep==0
    valueStep=signOfDiff*eticdis(signOfDiff*startEndDiff,nMax);
  end
  valueStart=valueStart+valueStep;
  startEndDiff=valueEnd-valueStart;  
  classValue=valueStart:valueStep:valueEnd; 
  classStart=classValue-valueStep/2;
  classStart=(classStart-classStart(1))/...
    (startEndDiff+valueStep);
  classEnd=classStart+classStart(2);

  if side=='s'
    startPos=x;
    xLength=length;
    yLength=0;
    moveForm=sprintf('%%1.2f %1.2f moveto\n',y);
    ticLineForm='0 %1.2f rlineto\n';
  elseif side=='n'
    startPos=x;
    xLength=length;
    yLength=0;
    moveForm=sprintf('%%1.2f %1.2f moveto\n',y);
    ticLineForm='0 -%1.2f rlineto\n';
  elseif side=='w'
    startPos=y;
    xLength=0;
    yLength=length;
    moveForm=sprintf('%1.2f %%1.2f moveto\n',x);
    ticLineForm='%1.2f 0 rlineto\n';
  elseif side=='e'
    startPos=y;
    xLength=0;
    yLength=length;
    moveForm=sprintf('%1.2f %%1.2f moveto\n',x);
    ticLineForm='-%1.2f 0 rlineto\n';
  end
  
  % start draw
  if dash >0
    fprintf(epsFile,'[%1.2f %1.2f] 0 setdash\n',dash,dash);
  end 
  fprintf(epsFile,'currentrgbcolor %1.2f %1.2f %1.2f setrgbcolor\n',...
          color(1),color(2),color(3));
  fprintf(epsFile,'newpath\n');

  %lines
  nClasses=size(classStart,2);
  for i=1:nClasses
    % grid line 
    currentPos=startPos+length*classStart(i);
    fprintf(epsFile,moveForm,currentPos);
    fprintf(epsFile,ticLineForm,lineLength);
    currentPos=startPos+length*classEnd(i);
    fprintf(epsFile,moveForm,currentPos);
    fprintf(epsFile,ticLineForm,lineLength);
  end

  fprintf(epsFile,'%1.2f setlinewidth\n',lineWidth);
  fprintf(epsFile,'stroke\n');
  fprintf(epsFile,'setrgbcolor [] 0 setdash\n');
