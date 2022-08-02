%%NAME
%%  ejpglist  - generate photoprints of a JPEG-filelist
%%
%%SYNOPSIS
%%  ejpglist([listFileName[,maxPhotoSize[,fitPhoto[,outputFileName]]]])
%%
%%PARAMETER(S)
%%  listFileName         textfile of JPEG-filenames 
%%                         one name per line
%%                       default=current directory
%%  maxPhotoSize         vector [width heigth] of photos
%%                       default=[90 120] (90mmx120mm)
%%  fitPhoto             switch, 0=off 1=fit photos to maxPhotoSize,default=0
%%  outputFileName       Praefix of eps-outputfile
%%                       default='photos' ->photos01.jpg,photos02.jpg, ...
%%
% written by stefan.mueller stefan.mueller@fgan.de (C) 2003
function ejpglist(listFileName,maxPhotoSize,fitPhoto,outputFileName)
  if nargin>4
    eusage('ejpglist(listFileName[,maxPhotoSize[,fitPhoto[,outputFileName]]])');
  end
  if nargin<4
    outputFileName='jpglist';
  end
  if nargin<3
    fitPhoto=0;
  end
  if nargin<2
    maxPhotoSize=[90 120]; 
  end
  if nargin<1
    listFileName='.';
  end
  eglobpar;
  einit;
  textDis=2;
  textSize=4;
  rows1=fix(eWinHeight/maxPhotoSize(1)); 
  cols1=fix(eWinWidth/maxPhotoSize(2)); 
  rows2=fix(eWinHeight/maxPhotoSize(2)); 
  cols2=fix(eWinWidth/maxPhotoSize(1)); 
  if rows1*cols1>rows2*cols2
   rows=rows1;
   cols=cols1;
   imgH=maxPhotoSize(1);
   imgW=maxPhotoSize(2);
  else
   rows=rows2;
   cols=cols2;
   imgH=maxPhotoSize(2);
   imgW=maxPhotoSize(1);
  end
  imgFac=imgH/imgW;
  nPerPage=rows*cols;
  offsetX=(eWinWidth-cols*imgW)/2;
  offsetY=(eWinHeight-rows*imgH);
  [tabX tabY]=etabdef(rows,cols,offsetX,offsetY,cols*imgW,rows*imgH);
  ttabH=(ePageHeight-eWinHeight)/2+offsetY;
  if ttabH/cols>5
    ttabH=5*cols;
  end
  [ttabX ttabY]=etabdef(rows,cols,offsetX,offsetY-ttabH,cols*imgW,ttabH);

  % list of images
  list=etxtread(listFileName);
  [lpos n]=etxtlpos(list);
  lpos=flipud(lpos);
  nPages=ceil(n/nPerPage);
  outtext=sprintf('Writing %d eps-file(s) with %d images ...',...
                   nPages,n);
  disp(outtext);
  page=0;
  while n>0
    page=page+1;
    cRows=ceil(n/cols);
    if cRows<rows 
      rows=cRows;
      offsetX=(eWinWidth-cols*imgW)/2;
      offsetY=(eWinHeight-rows*imgH);
      [tabX tabY]=etabdef(rows,cols,offsetX,offsetY,cols*imgW,rows*imgH);
      ttabH=(ePageHeight-eWinHeight)/2+offsetY;
      if ttabH/cRows>5
        ttabH=5*cRows;
      end
      [ttabX ttabY]=etabdef(rows,cols,offsetX,offsetY-ttabH,cols*imgW,ttabH);
    end
    if nPages>1
      epsFileName=sprintf('%s%d%d.eps',outputFileName,...
        floor(page/10),rem(page,10));
    else
      epsFileName=sprintf('%s.eps',outputFileName);
    end
    eopen(epsFileName);
    eglobpar;
    for i=1:rows  
      for j=1:cols  
        if n>0
          % outputfile
          imgFileName=list(lpos(n,1):lpos(n,2));
          [image head]=ejpgread(imgFileName);
          jpgH=head(2);jpgW=head(3);
          outtext=sprintf('%s with %dx%d Pixel loaded',...
            imgFileName,jpgH,jpgW);
          disp(outtext);
          % rotation
          if abs(jpgH/jpgW-imgFac)>abs(jpgW/jpgH-imgFac)
            rotationAngle=90;
            imgR=jpgW/jpgH;
          else
            rotationAngle=0;
            imgR=jpgH/jpgW;
          end
          if fitPhoto
            photoW=imgW;
            photoH=imgH;
          else
            if imgH/imgW<imgR
              photoH=imgH;
              photoW=imgH/imgR;
            else
              photoW=imgW;
              photoH=imgW*imgR;
            end
          end
          if rotationAngle>0
            x=tabX(j,1)+photoW;
            eframe(x,tabY(i,1),photoH,photoW,0,image,head,rotationAngle);
          else
            x=tabX(j,1);
            eframe(x,tabY(i,1),photoW,photoH,0,image,head);
          end
          slPos=findstr(imgFileName,'/');
          slPosL=length(slPos);
          if slPosL>0
            iFileName=imgFileName(slPos(slPosL)+1:length(imgFileName)); 
          else
            iFileName=imgFileName;
          end
          etabtext(ttabX,ttabY,i,j,iFileName,0);
          n=n-1;
        end
      end
    end
    eclose
  end
