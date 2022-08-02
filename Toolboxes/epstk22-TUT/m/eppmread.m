%%NAME
%%  eppmread  - read PPM-file 
%%
%%SYNOPSIS
%%  [image,colormap]=eppmread(filename)
%%
%%PARAMETER(S)
%%  filename    name of PPM-file
%%  image       image matrix 
%%              if colormap used then
%%                image is filled with indices of colormap  
%%              else
%%                image is filled with RGB values
%%                (value=R*2^16+G*2^8+B and R,G,B are integer of 0:255)
%%                that's a very fast way
%%  colormap    color table
%% 
% written by stefan.mueller@fgan.de (C) 2007
function [image,colormap]= eppmread (filename)
  if (nargin >1)
    eusage('[image,colormap] = eppmread(filename)');
  end
  eglobpar;
  if exist('ePath')
    if isempty(ePath)
      einit;
    end
  else
      einit;
  end
  if nargin<1
    filename=[ePath 'default.ppm'];
  end

  % read img-file
  imgFile=fopen(filename ,'rb');
  line= fgetl(imgFile);
  if      strcmp(line,'P3'); bindata=0; 
  elseif  strcmp(line,'P6'); bindata=1; 
  else
   bindata=3;
  end
  if  bindata<3
    line= fgetl(imgFile);
    skip=1;
    while skip
      if length(line)==0;line= fgetl(imgFile);
      elseif line(1)=='#';line= fgetl(imgFile);
      else skip=0;
      end
    end
    imgSize= sscanf( line,'%d %d');
    maxValue= sscanf( fgetl(imgFile),'%d'); 
    if bindata; [data n]= fread(imgFile,imgSize(1)*imgSize(2)*3,'uchar');
    else        [data n]= fscanf(imgFile,'%d',imgSize(1)*imgSize(2)*3);
    end
    fclose(imgFile);
     
    if nargout==2
      % generate colormap
      data=reshape(data,3,size(data,1)/3)';
      id=bitshift(data(:,1),16)+bitshift(data(:,2),8)+data(:,3);
      [cmap index]=sort(id);
      change=diff(cmap);
      dIndex=[1;find(change)+1];
      colorId=cmap(dIndex);
      colormap=data(index(dIndex),:)/maxValue;
    
      % generate image 
      dIndex=[dIndex;size(cmap,1)+1];
      for i=1:size(colorId,1)
        data(index(dIndex(i):dIndex(i+1)-1),1)=i;
      end 
      image=reshape(data(:,1),imgSize(1),imgSize(2))'; 
    else
      % generate image without colormap
      data=reshape(data,3,size(data,1)/3)*255/maxValue;
      data=bitshift(data(1,:),16)+bitshift(data(2,:),8)+data(3,:);
      image=reshape(data,imgSize(1),imgSize(2))'; 
    end
  else
    disp(['error in eppmread:' filename ' does not appear to be a ppm-file']);
  end
