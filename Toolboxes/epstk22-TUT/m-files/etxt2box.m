%etxt2box(epsFile,text,x,y,width,height,lFeed,pFeed,wBreak,pBreak,alignment,font,fontSize,color,spaceN,spaceW,spaceE,spaceS,offset)
% written by Stefan Mueller stefan.mueller@fgan.de (C) 2003

function etxt2box(epsFile,text,x,y,width,height,lFeed,pFeed,wBreak,pBreak,alignment,font,fontSize,color,spaceN,spaceW,spaceE,spaceS,offset)
  if (nargin~=19)
    eusage('etxt2box(epsFile,text,x,y,width,height,lFeed,pFeed,wBreak,pBreak,alignment,font,fontSize,color,spaceN,spaceW,spaceE,spaceS,offset)');
  end
  fprintf(epsFile,'currentrgbcolor %1.2f %1.2f %1.2f setrgbcolor\n',...
          color(1),color(2),color(3));
  if length(fontSize)>2
    fprintf(epsFile,...
      '/%s findfont [%1.2f 0 %1.2f %1.2f 0 0] makefont setfont\n',...
      font,fontSize(1),fontSize(2)*tan(fontSize(3)*pi/180),fontSize(2));
  else
    fprintf(epsFile,'/%s findfont %1.2f scalefont setfont\n',font,fontSize(1));
  end

  fprintf(epsFile,'/lf %1.2f def\n',lFeed);
  fprintf(epsFile,'/pf %1.2f def\n',pFeed);
  fprintf(epsFile,'/bl ( ) def /blw bl stringwidth pop def\n');
  fprintf(epsFile,'/wb (%s) def\n',wBreak);
  fprintf(epsFile,'/pb (%s) def /pbl pb length def\n',pBreak);
  if width>0 
    fprintf(epsFile,'/lw %1.2f def\n',width-spaceW-spaceE);
    fprintf(epsFile,'/lineX %1.2f def\n',x+spaceW);
  else  
    fprintf(epsFile,'/lw %1.2f def\n',-width-spaceW-spaceE);
    fprintf(epsFile,'/lineX %1.2f def\n',x+width+spaceW);
  end
  if height>0 
    fprintf(epsFile,'/th %1.2f def\n',height-spaceN-spaceS);
    fprintf(epsFile,'/lineY %1.2f def\n',y+height-spaceN);
  else  
    fprintf(epsFile,'/th %1.2f def\n',-height-spaceN-spaceS);
    fprintf(epsFile,'/lineY %1.2f def\n',y-spaceN);
  end
  if alignment==0
    fprintf(epsFile,...
      '/pline {lineX  lw 2 div add clw 2 div sub lineY moveto show\n');
    fprintf(epsFile,'/lineY lineY lf sub def } def\n');
  elseif alignment==2
    fprintf(epsFile,...
      '/plastline { lineX lineY moveto show /lineY lineY lf sub def} def\n');
    fprintf(epsFile,'/pline {/lineText exch def\n');
    fprintf(epsFile,'/space lw clw sub def\n');
    fprintf(epsFile,'/ns 0 def /sText lineText def\n');
    fprintf(epsFile,'{sText bl search\n');
    fprintf(epsFile,'{pop pop  /sText exch def /ns ns 1 add def}\n');
    fprintf(epsFile,'{pop exit} ifelse}loop\n');
    fprintf(epsFile,'lineX lineY moveto\n');
    fprintf(epsFile,'ns 0 gt\n');
    fprintf(epsFile,'{/space space ns 1 sub div def\n');
    fprintf(epsFile,'/lX lineX def\n');
    fprintf(epsFile,'/sText lineText def\n');
    fprintf(epsFile,'{sText bl search\n');
    fprintf(epsFile,'{/nword exch def pop /sText exch def nword show\n');
    fprintf(epsFile,'/lX lX blw add space add nword stringwidth pop add def\n');
    fprintf(epsFile,'lX lineY moveto}');
    fprintf(epsFile,'{pop exit} ifelse}loop\n');
    fprintf(epsFile,'sText show\n');
    fprintf(epsFile,'/lineY lineY lf sub def }\n');
    fprintf(epsFile,'{lineText show /lineY lineY lf sub def} ifelse} def\n');
  elseif alignment==-1
    fprintf(epsFile,...
      '/pline {lineX lw add clw sub lineY moveto show\n');
    fprintf(epsFile,'/lineY lineY lf sub def } def\n');
  else
    fprintf(epsFile,...
      '/pline { lineX lineY moveto show /lineY lineY lf sub def} def\n');
  end
  fprintf(epsFile,'newpath lineX lineY moveto lw 0 rlineto 0 th neg rlineto\n');
  fprintf(epsFile,'lw neg 0 rlineto closepath clip\n');
  fprintf(epsFile,'/lineX lineX %1.2f add def\n',offset(1));
  fprintf(epsFile,'/lineY lineY lf 0.75 mul sub %1.2f add def\n',offset(2));
  fprintf(epsFile,'/text (%s) def\n',text);
  fprintf(epsFile,'/ePos text length def\n');
  fprintf(epsFile,'/rText ePos 1 add string def\n');
  fprintf(epsFile,'rText 0 text putinterval\n');
  fprintf(epsFile,'rText ePos pb putinterval\n');
  fprintf(epsFile,'{rText pb search\n');
  fprintf(epsFile,'{/pText exch def pop /rText exch def\n');
  fprintf(epsFile,'/ePos pText length def\n');
  fprintf(epsFile,'/lText ePos 1 add string def\n');
  fprintf(epsFile,'lText 0 pText putinterval /pText lText def\n');
  fprintf(epsFile,'pText ePos wb putinterval /prText pText def\n');
  fprintf(epsFile,'/clw blw neg def /sPos 0 def /cPos 0 def\n');
  fprintf(epsFile,'{prText wb search\n{/nw exch def pop /prText exch def ');
  fprintf(epsFile,'/ww nw stringwidth pop def\nclw blw add ww add lw gt\n');
  fprintf(epsFile,'{pText sPos cPos sPos sub getinterval pline ');
  fprintf(epsFile,'/sPos cPos def /clw ww def }\n');
  fprintf(epsFile,'{/clw clw blw add ww add def} ifelse\n');
  fprintf(epsFile,'/cPos cPos nw length add 1 add def\n');
  fprintf(epsFile,'pText cPos 1 sub bl putinterval}\n');
  fprintf(epsFile,'{pop exit} ifelse } loop\n');
  fprintf(epsFile,'pText sPos ePos sPos sub getinterval\n');
  if alignment==2
    fprintf(epsFile,' plastline\n');
  else 
    fprintf(epsFile,' pline\n');
  end
  fprintf(epsFile,'/lineY lineY pf sub def}\n');
  fprintf(epsFile,'{pop exit} ifelse } loop\n');
