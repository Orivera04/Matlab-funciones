%valuePos=escalecl(epsFile,side,x,y,offset,angle,length,valueStart,valueStep,
% valueEnd,vForm,vVisible,fontSize,lineWidth,longTicLength,nValuesMax,
% space,color)
% written by stefan.mueller@fgan.de (C) 2007

function valuePos=escalecl(epsFile,side,x,y,offset,angle,length,valueStart,...
                  valueStep,valueEnd,vForm,vVisible,fontSize,...
                  lineWidth,longTicLength,nValuesMax,space,color)
  if (nargin~=18)
    eusage(...
   'valuePos=escalecl(epsFile,side,x,y,offset,angle,length,valueStart,valueStep,valueEnd,vForm,vVisible,fontSize,lineWidth,longTicLength,space,color)');
  end
  startEndDiff=valueEnd-valueStart;  
  signOfDelta=sign(startEndDiff);
  if valueStep==0
    valueStep=signOfDelta*eticdis(signOfDelta*startEndDiff,nValuesMax);
  end
  if isstr(vForm)
    valueForm=vForm;
  else
    if vForm==0  
      expo=-log10(valueStep*signOfDelta);
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
  end  

  valueStart=valueStart+valueStep;
  startEndDiff=valueEnd-valueStart;  
  classValue=valueStart:valueStep:valueEnd; 
  classStart=classValue-valueStep/2;
  classStart=(classStart-classStart(1))/...
    (startEndDiff+valueStep);
  if size(classStart,2) <2
    classEnd=classStart+1;
  else
    classEnd=classStart+classStart(2);
  end  

  if side=='s'
    startPos=0;
    xLength=length;
    yLength=0;
    valueOffset=-(offset+space);
    moveForm=sprintf('%%1.2f %1.2f moveto\n',-offset);
    ticLineForm='0 -%1.2f rlineto\n';
    moveValueForm=sprintf('0 -%1.2f rmoveto\n',space+fontSize*0.72);
    showForm='(%s) dup stringwidth pop dup 2 div sub neg 0 rmoveto show\n';
  elseif side=='n'
    startPos=0;
    xLength=length;
    yLength=0;
    valueOffset=offset+space;
    moveForm=sprintf('%%1.2f %1.2f moveto\n',offset);
    ticLineForm='0 %1.2f rlineto\n';
    moveValueForm=sprintf('0 %1.2f rmoveto\n',space);
    showForm='(%s) dup stringwidth pop dup 2 div sub neg 0 rmoveto show\n';
  elseif side=='w'
    startPos=0;
    xLength=0;
    yLength=length;
    valueOffset=-(offset+space);
    moveForm=sprintf('%1.2f %%1.2f moveto\n',-offset);
    ticLineForm='-%1.2f 0 rlineto\n';
    moveValueForm=sprintf('-%1.2f -%1.2f 0.28 mul rmoveto\n',space,fontSize);
    showForm='(%s) dup stringwidth pop neg 0 rmoveto show\n';
  elseif side=='e'
    startPos=0;
    xLength=0;
    yLength=length;
    valueOffset=offset+space;
    moveForm=sprintf('%1.2f %%1.2f moveto\n',offset);
    ticLineForm='%1.2f 0 rlineto\n';
    moveValueForm=sprintf('%1.2f -%1.2f 0.28 mul rmoveto\n',space,fontSize);
    showForm='(%s) show\n';
  end


  
  % start draw
  fprintf(epsFile,'%1.2f %1.2f translate\n',x,y);
  fprintf(epsFile,'%1.2f rotate\n',angle);
  fprintf(epsFile,'currentrgbcolor %1.2f %1.2f %1.2f setrgbcolor\n',...
          color(1),color(2),color(3)); 
  fprintf(epsFile,'newpath\n');
  fprintf(epsFile,'/Helvetica findfont %d scalefont setfont\n',fontSize);
  nClasses=size(classStart,2);
  valuePos=zeros(nClasses,1);
  for i=1:nClasses
    % long tic of start of class
    currentPos=startPos+length*classStart(i);
    fprintf(epsFile,moveForm,currentPos);
    fprintf(epsFile,ticLineForm,longTicLength);
    % long tic of end of class
    currentPos=startPos+length*classEnd(i);
    fprintf(epsFile,moveForm,currentPos);
    fprintf(epsFile,ticLineForm,longTicLength);
    % class value
    currentPos=startPos+length*(classStart(i)+classEnd(i))/2;
    valuePos(i)=currentPos;
    fprintf(epsFile,moveForm,currentPos);
    if vVisible
      fprintf(epsFile,moveValueForm);
      if abs(classValue(i))<1e-14
          classValue(i)=0;
      end
      valueStr=sprintf(valueForm,classValue(i));
      fprintf(epsFile,showForm,valueStr);
    end
  end
  valueOffset=ones(nClasses,1)*valueOffset;
  deg2rad=pi/180;
  sinAngle=sin(angle*deg2rad);
  cosAngle=cos(angle*deg2rad);
  if xLength==0
    valueDeltaX=valueOffset*cosAngle-valuePos*sinAngle;
    valueDeltaY=valueOffset*sinAngle+valuePos*cosAngle;
  else
    valueDeltaX=valuePos*cosAngle-valueOffset*sinAngle;
    valueDeltaY=valuePos*sinAngle+valueOffset*cosAngle;
  end
  valuePos=[x+valueDeltaX y+valueDeltaY];


  %axis
  fprintf(epsFile,moveForm,startPos);
  fprintf(epsFile,'%1.2f %1.2f rlineto\n',xLength,yLength);
  fprintf(epsFile,'%1.2f setlinewidth\n',lineWidth);
  fprintf(epsFile,'stroke\n');
  fprintf(epsFile,'setrgbcolor\n');      
  fprintf(epsFile,'%1.2f rotate\n',-angle);
  fprintf(epsFile,'%1.2f %1.2f translate\n',-x,-y);

