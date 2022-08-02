%%NAME
%%  eshadow  - make shadow image matrix
%%
%%SYNOPSIS
%%  x=eshadow(matrix,nColors,colorMap,lumen,image)
%%
%%PARAMETER(S)
%%  matrix             matrix for image 
%%  nColors            number of colors 
%%  colorMap           (nColors*nBrightnessLevels) x 3 Matrix 
%%  lumen              light direction, [x,y,z] vector
%%  image              cover image 
%%  x                  shadow image matrix
%%
% written by stefan.mueller@fgan.de (C) 2007

function x=eshadow(matrix,nColors,colorMap,lumen,image)
  if nargin == 5
    x=image;
  elseif nargin == 4 
    x=matrix;
  else
    eusage('x=eshadow(matrix,nColors,colorMap,lumen[,image])');
  end
  nMapItems=size(colorMap,1);
  nBrightnessLevels=nMapItems/nColors;

  darkAngle=-0.5;
  brightnessConst=nBrightnessLevels/(1-darkAngle)*1.001;

  [rows colums]=size(matrix);  
  neightbourE=[matrix(:,2:colums) matrix(:,colums)];
  neightbourS=[matrix(2:rows,:);matrix(rows,:)];
  neightbourE=neightbourE-matrix;
  neightbourS=matrix-neightbourS;
  square=neightbourE.*neightbourE+neightbourS.*neightbourS;
  sumAmount= sum(sum(sqrt(square)));
  averageAmount=sumAmount/rows/colums; 
  neightbourE=neightbourE/averageAmount;
  neightbourS=neightbourS/averageAmount;
  square=neightbourE.*neightbourE+neightbourS.*neightbourS;
  lumen=lumen/norm(lumen)*sqrt(2);
  brightness=fix(brightnessConst*...
    ((-neightbourE*lumen(1)+(-neightbourS)*lumen(2)+lumen(3))./...
    sqrt(2*(square+1))-darkAngle));
  brightness=reshape(brightness,rows*colums,1);
  search=find(brightness<1);
  if length(search)>0
    brightness(search)=ones(length(search),1);
  end
  brightness=reshape(brightness,rows,colums);

  maxValue=max(max(x));
  minValue=min(min(x));
  if (maxValue==minValue)
    x=ones(size(x,1),size(x,2));
  else
    x=fix((x-minValue)/(maxValue-minValue)*(nColors-1))+1; 
  end
  x=x+(brightness-1)*nColors;
  x=x(1:rows-1,1:colums-1);
