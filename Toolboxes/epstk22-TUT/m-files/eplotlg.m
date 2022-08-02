%eplotlg ( epsFile,x,y,color,dash,lineWidth,textFont,textSize,textColor)
% this function write postscript commands in  epsFile
% written by Stefan Mueller stefan.mueller@fgan.de (C) 2003

function eplotlg ( epsFile,x,y,color,dash,lineWidth,text,textFont,textSize,textColor)
  if (nargin~=10)
    eusage('eplotlg(epsFile,x,y,color,dash,lineWidth,text,textFont,textSize,textColor)');
  end
  textH=textSize*0.75;
  lineLength=3*textH;

  % print text
  etextxy(epsFile,x+lineLength+textH,y,0,1,text,textFont,textSize,textColor);

  % draw line
  if isstr(dash)
    fprintf(epsFile,'currentrgbcolor %1.2f %1.2f %1.2f setrgbcolor\n',...
            color(1),color(2),color(3));
    fprintf(epsFile,'%1.2f %1.2f 2 copy translate 0 0 moveto\n',...
            x+lineLength/2,y+textH/3);
    fprintf(epsFile,'%s neg exch neg exch translate\n',dash);
    fprintf(epsFile,'setrgbcolor\n');
  elseif max(size(dash))==1
    if dash>=0
      y=y+textSize/4;
      exyline(epsFile,0,0,[x;x+lineLength],[y;y],color,dash,lineWidth);
    else
      erect(epsFile,x,y,lineLength,textH,0,color,dash,0)
      erect(epsFile,x,y,lineLength,textH,0,textColor,0,0)
    end
  else
    erect(epsFile,x,y,lineLength,textH,0,color,dash,0)
    erect(epsFile,x,y,lineLength,textH,0,textColor,0,0)
  end 
