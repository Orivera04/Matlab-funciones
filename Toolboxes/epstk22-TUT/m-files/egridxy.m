%egridxy(epsFile,side,x,y,length,startValue,step,endValue,
%        maxValues,lineLength,lineWidth,color,dash)
% written by Stefan Mueller stefan.mueller@fgan.de (C) 2003

function egridxy(epsFile,side,x,y,length,startValue,step,endValue,...
                 maxValues,lineLength,lineWidth,color,dash)
  if (nargin~=13)
    eusage(...
   'egridxy(epsFile,side,x,y,length,startValue,step,endValue,maxValues,lineLength,lineWidth,color,dash)')
  end

  if side=='s'
    startPos=x;
    xLength=length;
    yLength=0;
    moveForm=sprintf('%%1.2f %1.2f moveto\n',y);
    ticLineForm='0 %1.2f rlineto\n';
  elseif side=='w'
    startPos=y;
    xLength=0;
    yLength=length;
    moveForm=sprintf('%1.2f %%1.2f moveto\n',x);
    ticLineForm='%1.2f 0 rlineto\n';
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
  %start ticNo and offset
  nShortTics=rem(startValue,deltaLabel)/deltaLabel*5*signOfDelta;
  if nShortTics<0
    nShortTics=5+nShortTics;
  end
  if rem(nShortTics,1)>0
      i=fix(nShortTics)+1;
      ticOffset=(i-nShortTics)*signOfDelta*deltaLabel/5;
  else 
    i=nShortTics; 
    ticOffset=0;
  end
  firstTicValue=startValue+ticOffset;
  currentValue=firstTicValue;
  deltaTic=signOfDelta*deltaLabel/5;
  axisFac=length/startEndDiff;
  
  % start draw
  if dash >0
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
    if rem(i,5)==0
      % grid line 
      fprintf(epsFile,moveForm,currentPos);
      fprintf(epsFile,ticLineForm,lineLength);
    end
    i=i+1;
    currentTic=currentTic+1;
    currentValue=firstTicValue+currentTic*deltaTic;
  end

  fprintf(epsFile,'%1.2f setlinewidth\n',lineWidth);
  fprintf(epsFile,'stroke\n');
  fprintf(epsFile,'setrgbcolor [] 0 setdash\n');
