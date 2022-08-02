%egridlog(epsFile,side,x,y,length,startValue,step,endValue,
%        maxValues,lineLength,lineWidth,color,dash)
% written by Stefan Mueller stefan.mueller@fgan.de (C) 2003

function egridlog(epsFile,side,x,y,length,startValue,step,endValue,...
                 maxValues,lineLength,lineWidth,color,dash)
  if (nargin~=13)
    eusage(...
   'egridlog(epsFile,side,x,y,length,startValue,step,endValue,maxValues,lineLength,lineWidth,color,dash)')
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
  signOfDelta=sign(startEndDiff);
  if (step==0)
    deltaLabel=eticdis(signOfDelta*startEndDiff,maxValues);
  else
    deltaLabel=abs(step);
  end
  if deltaLabel>1
    startValue=endValue;
  end
  if deltaLabel<1
    deltaLabel=1;
  end


  %start ticNo and offset
  nShortTics=rem(startValue,deltaLabel)/deltaLabel*9*signOfDelta;
  if nShortTics<0
    nShortTics=9+nShortTics;
  end
  if rem(nShortTics,1)>0
      i=fix(nShortTics)+1;
      ticOffset=(i-nShortTics)*signOfDelta*deltaLabel/9;
  else 
    i=nShortTics; 
    ticOffset=0;
  end
  firstTicValue=startValue+ticOffset;
  currentValue=firstTicValue;
  deltaTic=signOfDelta*deltaLabel/9;
  axisFac=length/startEndDiff;
  shortTicD=log10([2 3 4 5 6 7 8 9]);
  shortTicD=[0 shortTicD];
  
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
    rest=rem(i,9);
    interValue=currentValue+deltaTic*(9*shortTicD(rest+1)-rest);
    % grid line 
    if signOfDelta*interValue<=signOfDelta*endValue
      currentPos=startPos+axisFac*(interValue-startValue);
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
