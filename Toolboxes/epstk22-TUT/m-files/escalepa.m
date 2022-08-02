%longTicAngle=escalepa(epsFile,x,y,minRadius,maxRadius,angle1,angle2,...
%         startValue,step,endValue,vForm,vVisible,fontSize,lineWidth,...
%         shortTicLength,longTicLength,maxValues,space,color)
% written by Stefan Mueller stefan.mueller@fgan.de (C) 2003

function longTicAngle=escalepa(epsFile,x,y,minRadius,maxRadius,angle1,angle2,...
	  startValue,step,endValue,vForm,vVisible,fontSize,lineWidth,...
          shortTicLength,longTicLength,maxValues,space,color)
  if (nargin~=19)
    eusage(...
   'longTicAngle=escalepa(epsFile,x,y,minRadius,maxRadius,angle1,angle2,startValue,step,endValue,vForm,vVisible,fontSize,lineWidth,shortTicLength,longTicLength,maxValues,space,color)');
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
  if rem(deltaLabel,3)==0
    nTics=3;
  else
    nTics=5;
  end
  %start ticNo and offset
  nShortTics=rem(startValue,deltaLabel)/deltaLabel*nTics*signOfDelta;
  if nShortTics<0
    nShortTics=5+nShortTics;
  end
  if rem(nShortTics,1)>0
      i=fix(nShortTics)+1;
      ticOffset=(i-nShortTics)*signOfDelta*deltaLabel/nTics;
  else 
    i=nShortTics; 
    ticOffset=0;
  end
  firstTicValue=startValue+ticOffset;
  currentValue=firstTicValue;
  deltaTic=signOfDelta*deltaLabel/nTics;
  angleDiff=angle2-angle1;
  axisFac=angleDiff/startEndDiff;
  startPos=angle1;
  if angleDiff==360
   endValue=endValue-deltaTic;
  end
  
  moveForm=sprintf('%1.2f %%1.2f 2 copy cos mul 3 1 roll sin mul moveto\n',...
                  maxRadius);
  ticLineForm='%1.2f %1.2f 2 copy cos mul 3 1 roll sin mul rlineto\n';
  moveValueForm=sprintf(...
                  '%1.2f %%1.2f 2 copy cos mul 3 1 roll sin mul rmoveto\n',...
                  space+10);
  moveFontSizeForm=sprintf('0 %1.2f neg rmoveto\n',fontSize*0.28);
  showForm='(%s) dup stringwidth pop dup 2 div sub neg 0 rmoveto show\n';

  % start draw
  fprintf(epsFile,'%1.2f %1.2f translate\n',x,y);
  fprintf(epsFile,'currentrgbcolor %1.2f %1.2f %1.2f setrgbcolor\n',...
          color(1),color(2),color(3));         
  fprintf(epsFile,'newpath\n');
  fprintf(epsFile,'/Helvetica findfont %d scalefont setfont\n',fontSize);

  %tics
  currentTic=0;
  currentValue=firstTicValue;
  longTicAngle=0;
  nPos=0;
  while signOfDelta*currentValue<=signOfDelta*endValue
    currentPos=startPos+axisFac*(currentValue-startValue);
    fprintf(epsFile,moveForm,currentPos);
    if rem(i,nTics)~=0
      % short tics
      fprintf(epsFile,ticLineForm,shortTicLength,currentPos);
    else
      % long tics
      longTicAngle=[longTicAngle;currentPos];
      nPos=nPos+1;
      fprintf(epsFile,ticLineForm,longTicLength,currentPos);
      % value
      if vVisible
        fprintf(epsFile,moveValueForm,currentPos);
        fprintf(epsFile,moveFontSizeForm);
        if abs(currentValue)<1e-14
          currentValue=0;
        end
        valueStr=sprintf(valueForm,currentValue);
        fprintf(epsFile,showForm,valueStr);
      end
    end
    i=i+1;
    currentTic=currentTic+1;
    currentValue=firstTicValue+currentTic*deltaTic;
  end
  longTicAngle=longTicAngle(2:nPos+1);

  %axis
  fprintf(epsFile,'%1.2f %1.2f 2 copy cos mul 3 1 roll sin mul moveto\n',...
                   maxRadius,startPos);
  fprintf(epsFile,'0 0 %1.2f %1.2f %1.2f arc\n',maxRadius,angle1,angle2);
  fprintf(epsFile,'%1.2f %1.2f 2 copy cos mul 3 1 roll sin mul moveto\n',...
                   minRadius,startPos);
  fprintf(epsFile,'0 0 %1.2f %1.2f %1.2f arc\n',minRadius,angle1,angle2);
  fprintf(epsFile,'%1.2f setlinewidth\n',lineWidth);
  fprintf(epsFile,'stroke\n');
  fprintf(epsFile,'setrgbcolor\n');  
  fprintf(epsFile,'%1.2f %1.2f translate\n',-x,-y);
