%egridpr(epsFile,x,y,minRadius,maxRadius,angleStart,angleEnd,...
%        startValue,step,endValue,maxValues,lineWidth,color,dash)
% written by Stefan Mueller stefan.mueller@fgan.de (C) 2003

function egridpr(epsFile,x,y,minRadius,maxRadius,angleStart,angleEnd,...
                 startValue,step,endValue,maxValues,lineWidth,color,dash)
  if (nargin~=14)
    eusage(...
   'egridpr(epsFile,x,y,minRadius,maxRadius,angleStart,angleEnd,startValue,step,endValue,maxValues,lineWidth,color,dash)');
  end
  
  %scale
  length=maxRadius-minRadius;
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
  nShortTics=rem(startValue,deltaLabel)*5.0/deltaLabel;
  i=fix(nShortTics);
  ticOffset=(nShortTics-i)*deltaLabel/5;
  ticOffset=sign(ticOffset)*ticOffset;
  firstTicValue=startValue+signOfDelta*ticOffset;
  currentValue=firstTicValue;
  deltaTic=signOfDelta*deltaLabel/5;
  axisFac=length/startEndDiff;
  
  % start draw
  fprintf(epsFile,'%1.2f %1.2f translate\n',x,y);
  fprintf(epsFile,'%1.2f rotate\n',angleStart);
  if dash >0
    fprintf(epsFile,'[%1.2f %1.2f] 0 setdash\n',dash,dash);
  end 
  fprintf(epsFile,'currentrgbcolor %1.2f %1.2f %1.2f setrgbcolor\n',...
          color(1),color(2),color(3));
  fprintf(epsFile,'newpath\n');

  %lines
  startPos=minRadius;
  moveForm='0 %1.2f moveto\n';
  currentTic=0;
  currentValue=firstTicValue;
  while signOfDelta*currentValue<=signOfDelta*endValue
    currentPos=startPos+axisFac*(currentValue-startValue);
    if rem(i,5)==0
      % grid line 
      fprintf(epsFile,'%1.2f 0 moveto\n',currentPos);
      fprintf(epsFile,'0 0 %1.2f 0 %1.2f arc\n',currentPos,angleEnd-angleStart);
    end
    i=i+1;
    currentTic=currentTic+1;
    currentValue=firstTicValue+currentTic*deltaTic;
  end

  fprintf(epsFile,'%1.2f setlinewidth\n',lineWidth);
  fprintf(epsFile,'stroke\n');
  fprintf(epsFile,'setrgbcolor [] 0 setdash\n');
  fprintf(epsFile,'%1.2f rotate\n',-angleStart);
  fprintf(epsFile,'%1.2f %1.2f translate\n',-x,-y);
