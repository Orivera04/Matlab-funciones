%egridcl(epsFile,side,x,y,gridWidth,valueStart,valueStep,valueEnd,nMax,
%        lineLength,lineWidth,color,dash)
% written by stefan.mueller@fgan.de (C) 2007

function egridcl(epsFile,side,x,y,gridWidth,valueStart,valueStep,valueEnd,...
                 nMax,lineLength,lineWidth,color,dash)
  if (nargin~=13)
    eusage(...
   'egridcl(epsFile,side,x,y,gridWidth,valueStart,valueStep,valueEnd,nMax,lineLength,lineWidth,color,dash)')
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
    xLength=gridWidth;
    yLength=0;
    moveForm=sprintf('%%1.2f %1.2f moveto\n',y);
    ticLineForm='0 %1.2f rlineto\n';
  elseif side=='n'
    startPos=x;
    xLength=gridWidth;
    yLength=0;
    moveForm=sprintf('%%1.2f %1.2f moveto\n',y);
    ticLineForm='0 -%1.2f rlineto\n';
  elseif side=='w'
    startPos=y;
    xLength=0;
    yLength=gridWidth;
    moveForm=sprintf('%1.2f %%1.2f moveto\n',x);
    ticLineForm='%1.2f 0 rlineto\n';
  elseif side=='e'
    startPos=y;
    xLength=0;
    yLength=gridWidth;
    moveForm=sprintf('%1.2f %%1.2f moveto\n',x);
    ticLineForm='-%1.2f 0 rlineto\n';
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
  
  % start draw
  fprintf(epsFile,'currentrgbcolor %1.2f %1.2f %1.2f setrgbcolor\n',...
          color(1),color(2),color(3));

  for i=1:nDash
    if dash(1)>0
      fprintf(epsFile,'[%1.2f %1.2f] %1.2f setdash\n',...
        dashList(i,1),dashList(i,2),dashList(i,3));
    end
    fprintf(epsFile,'newpath\n');
    %lines
    nClasses=size(classStart,2);
    for j=1:nClasses
      % grid line 
      currentPos=startPos+gridWidth*classStart(j);
      fprintf(epsFile,moveForm,currentPos);
      fprintf(epsFile,ticLineForm,lineLength);
      currentPos=startPos+gridWidth*classEnd(j);
      fprintf(epsFile,moveForm,currentPos);
      fprintf(epsFile,ticLineForm,lineLength);
    end
    fprintf(epsFile,'%1.2f setlinewidth\n',lineWidth);
    fprintf(epsFile,'stroke\n');
  end
  fprintf(epsFile,'setrgbcolor\n');
  fprintf(epsFile,'[] 0 setdash\n');
