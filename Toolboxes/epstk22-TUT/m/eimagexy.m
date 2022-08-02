% eimagexy(epsFile,image,colorMap,x,y,width,height)
% write postscript commands in  epsFile to create an image
% written by stefan.mueller@fgan.de (C) 2007

function eimagexy(epsFile,image,colorMap,x,y,width,height)
  if (nargin~=7)
    eusage('eimagexy(epsFile,image,colorMap,x,y,width,height)');
  end
  if isstr(image)
    [image,head]=ejpgread(image);
    n=head(1);rows=head(2);cols=head(3);rgb=head(4); 
    if rgb
      decodeText='/Decode [0 1 0 1 0 1]\n/DataSource currentfile\n';
    else
      decodeText='/Decode [0 1]\n/DataSource currentfile\n';
    end
    filterText='/ASCII85Decode filter\n/DCTDecode filter\n>>\nimage\n';
  elseif colorMap(1,1)>1
    n=colorMap(1);rows=colorMap(2);cols=colorMap(3);rgb=colorMap(4); 
    if rgb
      decodeText='/Decode [0 1 0 1 0 1]\n/DataSource currentfile\n';
    else
      decodeText='/Decode [0 1]\n/DataSource currentfile\n';
    end
    filterText='/ASCII85Decode filter\n/DCTDecode filter\n>>\nimage\n';
  elseif colorMap(1,1)<=1
    [rows cols]=size(image);
    if colorMap(1,1)<0
      image=reshape(image',rows*cols,1);
      bImg=rem(image,256);
      image=fix(image/256);
      gImg=rem(image,256);
      rImg=fix(image/256);
      image=[rImg';gImg';bImg'];
    else
      colorMap=fix(colorMap*255);
      image=reshape(image',rows*cols,1);
      image=[colorMap(image,1)';colorMap(image,2)';colorMap(image,3)'];
    end
    n=rows*cols*3;
    image=reshape(image,n,1);
    decodeText='/Decode [0 1 0 1 0 1]\n/DataSource currentfile\n';
    filterText='/ASCII85Decode filter\n>>\nimage\n';
  end

  a85code=evec2a85(image);
  fprintf(epsFile,'gsave\n');
  fprintf(epsFile,'%1.2f %1.2f translate\n',x,y);
  fprintf(epsFile,'%1.2f %1.2f scale\n',width,height);
  fprintf(epsFile,'/DeviceRGB setcolorspace\n<<\n');
  fprintf(epsFile,'/ImageType 1\n/Width %d /Height %d\n',cols,rows);
  fprintf(epsFile,'/BitsPerComponent 8\n/ImageMatrix ');
  fprintf(epsFile,'[%d 0 0 -%d 0 %d]\n',cols,rows,rows);
  decodefilter=[decodeText filterText];
  fprintf(epsFile,decodefilter);
  fwrite(epsFile,a85code,'uchar');
  fprintf(epsFile,'~>\ngrestore\n');
