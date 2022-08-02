%%NAME
%%  eimgleg  - draw image legend of area
%%
%%SYNOPSIS
%%  eimgleg(x,y,width,height,map,scale,orientation)
%%
%%PARAMETER(S)
%%  x                  sw-x position of area
%%  y                  sw-y position of area
%%  width              width of area
%%  height             height of area
%%  map                map of legend
%%  scale              scale vector of legend [start step end]
%%                     special cases of scale vector are:
%%                     if start=0 and end=0 then autorange=on 
%%                     if step=0 then autoscale=on
%%  orientation        side of the area where the legend appears 
%%                     character 's'(south),'n'(north),'w'(west) or 'e'(east) 
%%
%%GLOBAL PARAMETER(S)
%%  eImageLegendScaleType
%%  eImageLegendVisible
%%  eImageLegendPos
%%  eImageLegendHeight
%%  eImageLegendWidth
%%  eImageLegendLabelDistance
%%  eImageLegendValueFormat
%%  eImageLegendLabelText
%%  eAxesColor
%%  eAxesTicLongLength
%%  eAxesTicShortLength
%%  eAxesTicLongMaxN
%%  eAxesValueSpace
%%  eAxesValueFontSize
%%  eAxesLabelFontSize
%%  eAxesLabelTextFont
%%  eAxesLineWidth
%%
% written by stefan.mueller@fgan.de (C) 2007

function eimgleg(x,y,width,height,map,scale,orientation)
  if (nargin~=7)
    eusage('eimgleg(x,y,width,height,map,scale,orientation');
  end
  eglobpar;

  if eImageLegendVisible
    if eImageLegendWidth==0
      if orientation=='s' | ...
         orientation=='n'
        xl=width;
        yl=eImageLegendHeight;
        scaleLength=xl;
      else
        yl=height;
        xl=eImageLegendHeight;
        scaleLength=yl;
      end
    else 
      if orientation=='s' | ...
         orientation=='n'
        xl=eImageLegendWidth;
        yl=eImageLegendHeight;
        scaleLength=xl;
      else
        xl=eImageLegendHeight;
        yl=eImageLegendWidth;
        scaleLength=yl;
      end
    end
    scaleSpace=eAxesTicLongLength+eAxesValueSpace+eAxesValueFontSize;
    if orientation=='s'
     colorImage=(1:length(map));
     legendPosX=x+eImageLegendPos(1);
     legendPosY=y+eImageLegendPos(2);
     scalePosX=legendPosX;
     scalePosY=legendPosY;
     textPosX=scalePosX+scaleLength/2;
     textPosY=scalePosY-scaleSpace-eAxesLabelFontSize*0.72-...
              eImageLegendLabelDistance;
     textAngle=0;
    elseif orientation=='n'
     colorImage=(1:length(map));
     legendPosX=x+eImageLegendPos(1);
     legendPosY=y+height-eImageLegendPos(2);
     scalePosX=legendPosX;
     scalePosY=legendPosY+yl;
     textPosX=scalePosX+scaleLength/2;
     textPosY=scalePosY+scaleSpace+yl+eAxesLabelFontSize*0.72+...
              eImageLegendLabelDistance;
     textAngle=0;
    elseif orientation=='e'
     colorImage=(length(map):-1:1)';
     legendPosX=x+width-eImageLegendPos(2);
     legendPosY=y+eImageLegendPos(1);
     scalePosX=legendPosX+xl;
     scalePosY=legendPosY;
     textPosX=scalePosX+scaleSpace+xl+eAxesLabelFontSize*0.72+...
              eImageLegendLabelDistance;
     textPosY=scalePosY+scaleLength/2;
     textAngle=90;
    elseif orientation=='w'
     colorImage=(length(map):-1:1)';
     legendPosX=x+eImageLegendPos(2)-xl;
     legendPosY=y-eImageLegendPos(1);
     scalePosX=legendPosX;
     scalePosY=legendPosY;
     textPosX=scalePosX-scaleSpace-eAxesLabelFontSize*0.72-...
              eImageLegendLabelDistance;
     textPosY=scalePosY+scaleLength/2;
     textAngle=90;
    end
    eimagexy(eFile,colorImage,map,...
             legendPosX*eFac,legendPosY*eFac,xl*eFac,yl*eFac);
    erect(eFile,legendPosX*eFac,legendPosY*eFac,...
          xl*eFac,yl*eFac,eAxesLineWidth*eFac,[0 0 0],0,0);
    if eImageLegendScaleType==0
      eImageLegendValuePos=escalexy(eFile,orientation,...
               scalePosX*eFac,scalePosY*eFac,0,0,...
               scaleLength*eFac,...
               scale(1),...
               scale(2),...
               scale(3),...
               eImageLegendValueFormat,...
               eImageLegendValueVisible,...
               eAxesValueFontSize*eFac,...
               eAxesLineWidth*eFac,...
               eAxesTicShortLength*eFac,...
               eAxesTicLongLength*eFac,...
               eAxesTicLongMaxN,...
               eAxesValueSpace*eFac,...
               eAxesColor);
      eImageLegendValuePos=eImageLegendValuePos/eFac;
    elseif eImageLegendScaleType==1
      eImageLegendValuePos=escalecl(eFile,orientation,...
               scalePosX*eFac,scalePosY*eFac,0,0,...
               scaleLength*eFac,...
               scale(1),...
               scale(2),...
               scale(3),...
               eImageLegendValueFormat,...
               eImageLegendValueVisible,...
               eAxesValueFontSize*eFac,...
               eAxesLineWidth*eFac,...
               eAxesTicLongLength*eFac,...
               eAxesTicLongMaxN,...
               eAxesValueSpace*eFac,...
               eAxesColor);
      eImageLegendValuePos=eImageLegendValuePos/eFac;
    elseif eImageLegendScaleType==2
      eImageLegendValuePos=escalelog(eFile,orientation,...
               scalePosX*eFac,scalePosY*eFac,0,0,...
               scaleLength*eFac,...
               scale(1),...
               scale(2),...
               scale(3),...
               eImageLegendValueFormat,...
               eImageLegendValueVisible,...
               eAxesValueFontSize*eFac,...
               eAxesLineWidth*eFac,...
               eAxesTicShortLength*eFac,...
               eAxesTicLongLength*eFac,...
               eAxesTicLongMaxN,...
               eAxesValueSpace*eFac,...
               eAxesColor);
      eImageLegendValuePos=eImageLegendValuePos/eFac;
    end
    if strcmp(eImageLegendLabelText,'')~=1
      etext(eImageLegendLabelText,...
             textPosX,...
             textPosY,...
             eAxesLabelFontSize,0,eAxesLabelTextFont,textAngle,eAxesColor);  
    end
  end    
