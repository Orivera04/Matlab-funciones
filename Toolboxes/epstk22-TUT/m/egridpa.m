%egridpa(epsFile,x,y,minRadius,maxRadius,angleStart,angleEnd,startValue,step,
%         endValue,maxValues,lineWidth,color,dash)
% written by stefan.mueller@fgan.de (C) 2007

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
  nShortTics=rem(startValue,deltaLabel)*nTics/deltaLabel;
  iTic=fix(nShortTics);
  ticOffset=(nShortTics-iTic)*deltaLabel/nTics;
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
      if rem(jTic,nTics)==0
        fprintf(epsFile,moveForm,currentPos);
        fprintf(epsFile,ticLineForm,currentPos);
        % value
      end
      jTic=jTic+1;
      currentTic=currentTic+1;
      currentValue=firstTicValue+currentTic*deltaTic;
    end
    fprintf(epsFile,'%1.2f setlinewidth\n',lineWidth);
    fprintf(epsFile,'stroke\n');
  end
  fprintf(epsFile,'setrgbcolor\n');
  fprintf(epsFile,'[] 0 setdash\n');
  fprintf(epsFile,'%1.2f %1.2f translate\n',-x,-y);
