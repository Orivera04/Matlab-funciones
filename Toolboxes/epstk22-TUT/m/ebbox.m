%%NAME
%%  ebbox  -  get and set bounding box
%%
%%SYNOPSIS
%%  currentBBox=ebbox([newBBox[,epsFileName]])
%%
%%PARAMETER(S)
%%  newBBox        default: -1 =  read old  box coordinates of file
%%                 if a scalar then newBBox is min. distance (in eUserUnits)
%%                   between objects and then new calculated bounding box 
%%                 if a vector 1x4 then newBBox are the new
%%                   bounding box coordinates  [x0 y0 x1 y1] in 1/72 inchs
%%  epsFileName    name of eps-file
%%                 default: 'eFileName' 
%%  currentBBox    current Bounding Box of eps-file
%%
%%GLOBAL PARAMETER(S)
%%  eFileName
% written by stefan.mueller@fgan.de (C) 2007

function currentBBox=ebbox(newBBox,epsFileName)
  if nargin>4
    eusage('currentBBox=ebbox([newBBox[,epsFileName]])');
  end
  eglobpar;
  if exist('eFac')
    if isempty(eFac)
      einit;
    end
  else
    einit;
  end
  if nargin<1
    newBBox=-1; 
  end
  if nargin<2
    epsFileName=eFileName;
  end
  headsize=500;
  % read file
  epsFile=fopen(epsFileName,'rb');
  [data n]=fread(epsFile,inf,'uchar');
  fclose(epsFile);
  % get head
  head=setstr(data(1:headsize)');
  pos=findstr(head,'BoundingBox:');
  currentBBox=sscanf(head(pos(1)+12:pos(1)+40),'%f',4)';
  if newBBox>=0
    if size(newBBox,2)~=4
      % autoresize
      resolution=72;
      mapName=ebitmap(3,resolution,'bbox.ppm.tmp',epsFileName);
      img=eimgread(mapName);
      delete(mapName);
      imgH=size(img,1);
      xpos=find(min(img)<16777215);
      xn=size(xpos,2);
      ypos=find(min(img')<16777215);
      yn=size(ypos,2);
      frameSize=newBBox(1)*eFac;
      newBBox=[xpos(1) imgH-ypos(yn)+1 xpos(xn) imgH-ypos(1)+1]-1;
      newBBox=newBBox*72/resolution;
      newBBox(1)=newBBox(1)+currentBBox(1)-frameSize;
      newBBox(2)=newBBox(2)+currentBBox(2)-frameSize;
      newBBox(3)=newBBox(3)+currentBBox(1)+frameSize;
      newBBox(4)=newBBox(4)+currentBBox(2)+frameSize;
      newBBox=fix(newBBox);
    end
    % set new BBox
    endpos=findstr(head(pos(1)+12:pos(1)+80),'%');
    endpos=endpos+pos(1)+10;
    epsFile=fopen(epsFileName,'wb');
    fwrite(epsFile,data(1:pos(1)-1),'uchar');
    fprintf(epsFile,'BoundingBox: %d %d %d %d',...
      newBBox(1),newBBox(2),newBBox(3),newBBox(4));
    fwrite(epsFile,data(endpos(1):n),'uchar');
    fclose(epsFile);
    currentBBox=newBBox;
  end
