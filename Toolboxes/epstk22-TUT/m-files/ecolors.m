%%NAME
%%  ecolors - get a colormap defined in einit.m 
%%
%%SYNOPSIS
%%  colorMap=ecolors([mapNo [,nColors]])
%%
%%PARAMETER(S)
%%  colorMap  matrix of nColors x 3 Values between 0 and 1
%%  mapNo     map number in the definition matrix eColorMaps (default=0)
%%  nColors   number of colors (default=64)
%% 
%%GLOBAL PARAMETER(S)
%%  eColorMaps
% written by Joerg Heckenbach and Stefan Mueller

function colorMap=ecolors(mapNo,nColors)
  if nargin > 2
    eusage('colorMap=ecolors([mapNo [,nColors]])');
  end
  eglobpar;
  if nargin < 2
    nColors=64;
  end   
  if nargin < 1
    mapNo=0;
  end
  mapDef=eColorMaps(find(eColorMaps(:,1)==mapNo),2:4);
  if size(mapDef,1)==0
    gray=0:1/(nColors-1):1;
    colorMap=[gray' gray' gray'];
  else
    nColors=min(max(nColors, size(mapDef,1)),256);
    colorMap=zeros(nColors,3);
    N=(size(colorMap,1)-1)/(size(mapDef,1)-1);
    colorMap(1,:)=mapDef(1,:);
    for n=2:size(colorMap,1)
       nN=fix((n-1)/N)+1;      %Nummer des aktuellen N-Blocks
       nn=fix(rem(n-1,N));  %Position innerhalb eines N-Blocks
       if nn==0
          colorMap(n,:)=mapDef(nN,:);
       else
          colorMap(n,:)=(mapDef(nN+1,:)-mapDef(nN,:))/N*nn+mapDef(nN,:);
       end
    end
  end
