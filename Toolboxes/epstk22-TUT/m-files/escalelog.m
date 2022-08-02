%longTicPos=escalelog(epsFile,side,x,y,offset,angle,length,startValue,step,
%         endValue,vForm,vVisible,fontSize,lineWidth,shortTicLength,
%         longTicLength,maxValues,space,color)
% log scaled axis
% written by Stefan Mueller stefan.mueller@fgan.de (C) 2003

function longTicPos=escalelog(epsFile,side,x,y,offset,angle,length,...
          startValue,step,endValue,vForm,vVisible,fontSize,lineWidth,...
          shortTicLength,longTicLength,maxValues,space,color)
  if (nargin~=19)
    usage(...
   'longTicPos=escalelog(epsFile,side,x,y,offset,angle,length,startValue,step,endValue,vForm,vVisible,fontSize,lineWidth,shortTicLength,longTicLength,maxValues,space,color)');
  end

  startPos=0;
  if side=='s'
    xLength=length;
    yLength=0;
    longTicOffset=-(offset+longTicLength+space);
    moveForm=sprintf('%%1.2f %1.2f moveto\n',-offset);
    ticLineForm='0 %1.2f neg rlineto\n';
    moveValueForm=sprintf('0 -%1.2f rmoveto\n',space+fontSize*0.72);
    showForm='(%s) dup stringwidth pop dup 2 div sub neg 0 rmoveto show\n';
    showFormE='dup 2 div sub neg 0 rmoveto (%s) show\n';
  elseif side=='n'
    xLength=length;
    yLength=0;
    longTicOffset=offset+longTicLength+space;
    moveForm=sprintf('%%1.2f %1.2f moveto\n',offset);
    ticLineForm='0 %1.2f rlineto\n';
    moveValueForm=sprintf('0 %1.2f rmoveto\n',space);
    showForm='(%s) dup stringwidth pop dup 2 div sub neg 0 rmoveto show\n';
    showFormE='dup 2 div sub neg 0 rmoveto (%s) show\n';
  elseif side=='w'
    xLength=0;
    yLength=length;
    longTicOffset=-(offset+longTicLength+space);
    moveForm=sprintf('%1.2f %%1.2f moveto\n',-offset);
    ticLineForm='%1.2f neg 0 rlineto\n';
    moveValueForm=sprintf('-%1.2f -%1.2f 0.28 mul rmoveto\n',space,fontSize);
    showForm='(%s) dup stringwidth pop neg 0 rmoveto show\n';
    showFormE='neg 0 rmoveto (%s) show\n';
  elseif side=='e'
    xLength=0;
    yLength=length;
    longTicOffset=offset+longTicLength+space;
    moveForm=sprintf('%1.2f %%1.2f moveto\n',offset);
    ticLineForm='%1.2f 0 rlineto\n';
    moveValueForm=sprintf('%1.2f -%1.2f 0.28 mul rmoveto\n',space,fontSize);
    showForm='(%s) show\n';
    showFormE='(%s) show\n';
  end
  startEndDiff=endValue-startValue;

  signOfDelta=sign(startEndDiff);
  if (step==0)
    deltaLabel=eticdis(signOfDelta*startEndDiff,maxValues);
  else
    deltaLabel=abs(step);
  end
  if deltaLabel>1
    shortTicLength=0;
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
    iTic=fix(nShortTics)+1;
    ticOffset=(iTic-nShortTics)*signOfDelta*deltaLabel/9;
  else 
    iTic=nShortTics; 
    ticOffset=0;
  end
  firstTicValue=startValue+ticOffset;
  currentValue=firstTicValue;
  deltaTic=signOfDelta*deltaLabel/9;
  axisFac=length/startEndDiff;
  shortTicD=log10([2 3 4 5 6 7 8 9]);

  % start draw
  fprintf(epsFile,'%1.2f %1.2f translate\n',x,y);
  fprintf(epsFile,'%1.2f rotate\n',angle);
  fprintf(epsFile,'currentrgbcolor %1.2f %1.2f %1.2f setrgbcolor\n',...
          color(1),color(2),color(3));         
  fprintf(epsFile,'newpath\n');
  if vForm>=0
    digitForm=sprintf('%%0.%df',vForm);
  end

  %tics
  currentTic=0;
  currentValue=firstTicValue;
  longTicPos=0;
  nPos=0;
  while signOfDelta*currentValue<=signOfDelta*endValue
    rest=rem(iTic,9);
    if rest~=0
      % short tics
      interValue=currentValue+deltaTic*(9*shortTicD(rest)-rest);
      if signOfDelta*interValue<=signOfDelta*endValue
        currentPos=startPos+axisFac*(interValue-startValue);
        fprintf(epsFile,moveForm,currentPos);
        fprintf(epsFile,ticLineForm,shortTicLength);
      end
    else
      % long tics
      currentPos=startPos+axisFac*(currentValue-startValue);
      longTicPos=[longTicPos;currentPos];
      nPos=nPos+1;
      fprintf(epsFile,moveForm,currentPos);
      fprintf(epsFile,ticLineForm,longTicLength);
      % value
      if vVisible & (offset>=0 | abs(currentValue)>1e-14)
        fprintf(epsFile,moveValueForm);
        if abs(currentValue)>vForm
          valueForm=sprintf('%1.0f',currentValue);
          fprintf(epsFile,'/Helvetica findfont %d scalefont setfont\n',...
                  fontSize*0.7);
          fprintf(epsFile,'(%s) stringwidth pop\n',valueForm);
          fprintf(epsFile,'/Helvetica findfont %d scalefont setfont\n',...
                  fontSize);
          fprintf(epsFile,'(10) stringwidth pop add\n');
          fprintf(epsFile,showFormE,'10');
          fprintf(epsFile,'/Helvetica findfont %d scalefont setfont\n',...
                  fontSize*0.7);
          fprintf(epsFile,'0 %1.2f rmoveto\n',fontSize*0.6);
          fprintf(epsFile,'(%s) show\n',valueForm);
        else
          valueForm=sprintf(digitForm,10^currentValue);
          pos=find(valueForm~='0');
          lpos=size(pos,2);
          pos=pos(lpos);
          if pos<size(valueForm,2)
            if  valueForm(pos)=='.'
              pos=pos-1;
            end
            valueForm=valueForm(1:pos);
          end
          fprintf(epsFile,'/Helvetica findfont %d scalefont setfont\n',...
                  fontSize);
          fprintf(epsFile,'(%s) stringwidth pop\n',valueForm);
          fprintf(epsFile,showForm,valueForm);
        end
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
