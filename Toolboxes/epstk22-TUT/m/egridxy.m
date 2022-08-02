%egridxy(epsFile,side,x,y,gridWidth,startValue,step,endValue,
%        maxValues,lineLength,lineWidth,color,dash)
% written by stefan.mueller@fgan.de (C) 2007

function egridxy(epsFile,side,x,y,gridWidth,startValue,step,endValue,...
                 maxValues,lineLength,lineWidth,color,dash)
  if (nargin~=13)
    eusage(...
   'egridxy(epsFile,side,x,y,gridWidth,startValue,step,endValue,maxValues,lineLength,lineWidth,color,dash)')
  end
  if side=='s'
    startPos=x;
    moveForm=sprintf('%%1.2f %1.2f moveto\n',y);
    ticLineForm='0 %1.2f rlineto\n';
  elseif side=='w'
    startPos=y;
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
      iTic=fix(nShortTics)+1;
      ticOffset=(iTic-nShortTics)*signOfDelta*deltaLabel/5;
  else 
    iTic=nShortTics; 
    ticOffset=0;
  end
  firstTicValue=startValue+ticOffset;
  currentValue=firstTicValue;
  deltaTic=signOfDelta*deltaLabel/5;
  axisFac=gridWidth/startEndDiff;
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
  %lines
  for i=1:nDash
    jTic=iTic;
    if dash(1)>0
      fprintf(epsFile,'[%1.2f %1.2f] %1.2f setdash\n',...
        dashList(i,1),dashList(i,2),dashList(i,3));
    end
    fprintf(epsFile,'newpath\n');
    currentTic=0;
    currentValue=firstTicValue;
    while signOfDelta*currentValue<=signOfDelta*endValue
      currentPos=startPos+axisFac*(currentValue-startValue);
      if rem(jTic,5)==0
        % grid line 
        fprintf(epsFile,moveForm,currentPos);
        fprintf(epsFile,ticLineForm,lineLength);
      end
      jTic=jTic+1;
      currentTic=currentTic+1;
      currentValue=firstTicValue+currentTic*deltaTic;
    end
    fprintf(epsFile,'%1.2f setlinewidth\n',lineWidth);
    fprintf(epsFile,'stroke\n');
  end
  fprintf(epsFile,'[] 0 setdash\n');
  fprintf(epsFile,'setrgbcolor\n');
