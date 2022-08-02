%longTicPos=escalexy(epsFile,side,x,y,offset,angle,length,startValue,step,
%         endValue,vForm,vVisible,fontSize,lineWidth,shortTicLength,
%         longTicLength,maxValues,space,color)
% linear scaled axis
% written by Stefan Mueller stefan.mueller@fgan.de (C) 2003

function longTicPos=escalexy(epsFile,side,x,y,offset,angle,length,startValue,...
              step,endValue,vForm,vVisible,fontSize,lineWidth,shortTicLength,...
              longTicLength,maxValues,space,color)
  if (nargin~=19)
    eusage(...
   'longTicPos=escalexy(epsFile,side,x,y,offset,angle,length,startValue,step,endValue,vForm,vVisible,fontSize,lineWidth,shortTicLength,longTicLength,maxValues,space,color)');
  end
  if side=='s'
    startPos=0;
    xLength=length;
    yLength=0;
    longTicOffset=-(offset+longTicLength+space);
    moveForm=sprintf('%%1.2f %1.2f moveto\n',-offset);
    ticLineForm='0 %1.2f neg rlineto\n';
    moveValueForm=sprintf('0 -%1.2f rmoveto\n',space+fontSize*0.72);
    showForm='(%s) dup stringwidth pop dup 2 div sub neg 0 rmoveto show\n';
  elseif side=='n'
    startPos=0;
    xLength=length;
    yLength=0;
    longTicOffset=offset+longTicLength+space;
    moveForm=sprintf('%%1.2f %1.2f moveto\n',offset);
    ticLineForm='0 %1.2f rlineto\n';
    moveValueForm=sprintf('0 %1.2f rmoveto\n',space);
    showForm='(%s) dup stringwidth pop dup 2 div sub neg 0 rmoveto show\n';
  elseif side=='w'
    startPos=0;
    xLength=0;
    yLength=length;
    longTicOffset=-(offset+longTicLength+space);
    moveForm=sprintf('%1.2f %%1.2f moveto\n',-offset);
    ticLineForm='%1.2f neg 0 rlineto\n';
    moveValueForm=sprintf('-%1.2f -%1.2f 0.28 mul rmoveto\n',space,fontSize);
    showForm='(%s) dup stringwidth pop neg 0 rmoveto show\n';
  elseif side=='e'
    startPos=0;
    xLength=0;
    yLength=length;
    longTicOffset=offset+longTicLength+space;
    moveForm=sprintf('%1.2f %%1.2f moveto\n',offset);
    ticLineForm='%1.2f 0 rlineto\n';
    moveValueForm=sprintf('%1.2f -%1.2f 0.28 mul rmoveto\n',space,fontSize);
    showForm='(%s) show\n';
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
  if vForm==0  
    expo=-log10(deltaLabel);
    if rem(expo,1)>0
      expo=expo+1;
    end
    autoForm=fix(expo);
    if autoForm>0
      vForm=autoForm;
    end
  end
  if vForm<0  
    valueForm='%g';
  else
    valueForm=sprintf('%%1.%df',vForm);
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
  axisFac=length/startEndDiff;
  
  % start draw
  fprintf(epsFile,'%1.2f %1.2f translate\n',x,y);
  fprintf(epsFile,'%1.2f rotate\n',angle);
  fprintf(epsFile,'currentrgbcolor %1.2f %1.2f %1.2f setrgbcolor\n',...
          color(1),color(2),color(3));         
  fprintf(epsFile,'newpath\n');
  fprintf(epsFile,'/Helvetica findfont %d scalefont setfont\n',fontSize);

  %tics
  currentTic=0;
  currentValue=firstTicValue;
  longTicPos=0;
  nPos=0;
  while signOfDelta*currentValue<=signOfDelta*endValue
    currentPos=startPos+axisFac*(currentValue-startValue);
    fprintf(epsFile,moveForm,currentPos);
    if rem(iTic,5)~=0
      % short tics
      fprintf(epsFile,ticLineForm,shortTicLength);
    else
      % long tics
      longTicPos=[longTicPos;currentPos];
      nPos=nPos+1;
      fprintf(epsFile,ticLineForm,longTicLength);
      % value
      if vVisible & (offset>=0 | abs(currentValue)>1e-14)
        if abs(currentValue)<1e-14
          currentValue=0;
        end
        fprintf(epsFile,moveValueForm);
        valueStr=sprintf(valueForm,currentValue);
        fprintf(epsFile,showForm,valueStr);
      end
    end
    iTic=iTic+1;
    currentTic=currentTic+1;
    currentValue=firstTicValue+currentTic*deltaTic;
  end
  longTicPos=longTicPos(2:nPos+1);
  longTicOffset=ones(nPos,1)*longTicOffset;
  sinAngle=sin(angle*pi/180); 
  cosAngle=cos(angle*pi/180); 
  if xLength==0
    longTicDeltaX=longTicOffset*cosAngle-longTicPos*sinAngle;
    longTicDeltaY=longTicOffset*sinAngle+longTicPos*cosAngle;
  else
    longTicDeltaX=longTicPos*cosAngle-longTicOffset*sinAngle;
    longTicDeltaY=longTicPos*sinAngle+longTicOffset*cosAngle;
  end
  longTicPos=[x+longTicDeltaX y+longTicDeltaY];

  %axis
  fprintf(epsFile,moveForm,startPos);
  fprintf(epsFile,'%1.2f %1.2f rlineto\n',xLength,yLength);
  fprintf(epsFile,'%1.2f setlinewidth\n',lineWidth);
  fprintf(epsFile,'stroke\n');
  fprintf(epsFile,'setrgbcolor\n'); 
  fprintf(epsFile,'%1.2f rotate\n',-angle);
  fprintf(epsFile,'%1.2f %1.2f translate\n',-x,-y);
