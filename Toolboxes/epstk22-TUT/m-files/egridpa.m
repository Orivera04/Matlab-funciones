%egridpa(epsFile,x,y,minRadius,maxRadius,angleStart,angleEnd,startValue,step,
%         endValue,maxValues,lineWidth,color,dash)
% written by Stefan Mueller stefan.mueller@fgan.de (C) 2003

function egridpa(epsFile,x,y,minRadius,maxRadius,angleStart,angleEnd,...
                 startValue,step,endValue,maxValues,lineWidth,color,dash)
  if (nargin~=14)
    eusage(...
   'egridpd(epsFile,x,y,minRadius,maxRadius,angleStart,angleEnd,startValue,step,endValue,maxValues,lineWidth,color,dash)');
  end

  startEndDiff=endValue-startValue;
  if step==0
    %autoscale
    signOfDelta=sign(startEndDiff);
    deltaLabel=eticdis(signOfDelta*startEndDiff,maxValues);
  else
    %fixscale
    signOfDelta=sign(step);
    deltaLabel=signOfDelta*step;
  end
  if rem(deltaLabel,3)==0
    nTics=3;
  else
    nTics=5;
  end
  nShortTics=rem(startValue,deltaLabel)*nTics/deltaLabel;
  i=fix(nShortTics);
  ticOffset=(nShortTics-i)*deltaLabel/nTics;
  ticOffset=sign(ticOffset)*ticOffset;
  firstTicValue=startValue+signOfDelta*ticOffset;
  currentValue=firstTicValue;
  deltaTic=signOfDelta*deltaLabel/nTics;
  axisFac=(angleEnd-angleStart)/startEndDiff;
  
  startPos=angleStart;
  moveForm=sprintf('%1.2f %%1.2f 2 copy cos mul 3 1 roll sin mul moveto\n',...
                  minRadius);
  ticLineForm=sprintf(...
         '%1.2f %%1.2f 2 copy cos mul 3 1 roll sin mul rlineto\n',...
         maxRadius-minRadius);

  % start draw
  fprintf(epsFile,'%1.2f %1.2f translate\n',x,y);
  if dash>0
    fprintf(epsFile,'[%1.2f %1.2f] 0 setdash\n',dash,dash);
  end
  fprintf(epsFile,'currentrgbcolor %1.2f %1.2f %1.2f setrgbcolor\n',...
          color(1),color(2),color(3));
  fprintf(epsFile,'newpath\n');

  %lines
  currentTic=0;
  currentValue=firstTicValue;
  while signOfDelta*currentValue<=signOfDelta*endValue
    currentPos=startPos+axisFac*(currentValue-startValue);
    if rem(i,nTics)==0
      fprintf(epsFile,moveForm,currentPos);
      fprintf(epsFile,ticLineForm,currentPos);
      % value
    end
    i=i+1;
    currentTic=currentTic+1;
    currentValue=firstTicValue+currentTic*deltaTic;
  end
  fprintf(epsFile,'stroke\n');
  fprintf(epsFile,'setrgbcolor [] 0 setdash\n');
  fprintf(epsFile,'%1.2f %1.2f translate\n',-x,-y);
