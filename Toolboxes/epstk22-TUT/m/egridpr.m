%egridpr(epsFile,x,y,minRadius,maxRadius,angleStart,angleEnd,...
%        startValue,step,endValue,maxValues,lineWidth,color,dash)
% written by stefan.mueller@fgan.de (C) 2007

function egridpr(epsFile,x,y,minRadius,maxRadius,angleStart,angleEnd,...
                 startValue,step,endValue,maxValues,lineWidth,color,dash)
  if (nargin~=14)
    eusage(...
   'egridpr(epsFile,x,y,minRadius,maxRadius,angleStart,angleEnd,startValue,step,endValue,maxValues,lineWidth,color,dash)');
  end
  
  %scale
  lineLength=maxRadius-minRadius;
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
  iTic=fix(nShortTics);
  ticOffset=(nShortTics-iTic)*deltaLabel/5;
  ticOffset=sign(ticOffset)*ticOffset;
  firstTicValue=startValue+signOfDelta*ticOffset;
  currentValue=firstTicValue;
  deltaTic=signOfDelta*deltaLabel/5;
  axisFac=lineLength/startEndDiff;
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
  fprintf(epsFile,'%1.2f %1.2f translate\n',x,y);
  fprintf(epsFile,'%1.2f rotate\n',angleStart);
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
    startPos=minRadius;
    currentTic=0;
    currentValue=firstTicValue;
    while signOfDelta*currentValue<=signOfDelta*endValue
      currentPos=startPos+axisFac*(currentValue-startValue);
      if rem(jTic,5)==0
        % grid line 
        fprintf(epsFile,'%1.2f 0 moveto\n',currentPos);
        fprintf(epsFile,'0 0 %1.2f 0 %1.2f arc\n',currentPos,angleEnd-angleStart);
      end
      jTic=jTic+1;
      currentTic=currentTic+1;
      currentValue=firstTicValue+currentTic*deltaTic;
    end
    fprintf(epsFile,'%1.2f setlinewidth\n',lineWidth);
    fprintf(epsFile,'stroke\n');
  end
  fprintf(epsFile,'setrgbcolor [] 0 setdash\n');
  fprintf(epsFile,'%1.2f rotate\n',-angleStart);
  fprintf(epsFile,'%1.2f %1.2f translate\n',-x,-y);
