%%NAME
%%  eimgmix  - mix two images 
%%
%%SYNOPSIS
%%  mixedImage=eimgmix(image1,image2[,fraction[,offset]])
%%
%%PARAMETER(S)
%%  image1      first RGB-image-matrix 
%%  image2      second RGB-image-matrix 
%%  fraction    scalar, mixing fraction of image2, (0<=fraction<=1)
%%              or vector 1x3, mixing fractions of RGB-Channels
%%              or matrix with size of image2, mixing fraction for each pixel
%%              default:fraction=0.5 
%%  offset      vector [x y], position of NW-Corner of image2, default [0 0]
%%  mixedImage  mixed RGB-image-matrix 
%% 
% written by stefan.mueller@fgan.de (C) 2007
function mixedImage= eimgmix(image1,image2,fraction,offset)
  if (nargin<2)
    eusage('mixedImage = eimgmix(image1,image2[,fraction[,offset]])');
  end
  if (nargin<3)
    fraction=50;
  end
  if (nargin<4)
    offset=[0 0];
  end
  [h1 w1]=size(image1);
  [h2 w2]=size(image2);
  if (offset(1)>=w1) || (offset(1)<0) ||...
     (offset(2)>=h1) || (offset(2)<0)
    error('wrong offset');
  end
  [hf wf]=size(fraction);
  if hf+wf==2
    rf=ones(h2*w2,1)*fraction;gf=rf;bf=rf;
  elseif (hf==1) && (wf==3)
    rf=ones(h2*w2,1);
    gf=rf*fraction(2);
    bf=rf*fraction(3);
    rf=rf*fraction(1);
  elseif (hf==h2) && (wf==w2)
    rf=reshape(fraction,h2*w2,1);
    gf=rf;
    bf=rf;
  else
    error('wrong fraction');
  end
  image1=reshape(image1,h1*w1,1);
  image2=reshape(image2,h2*w2,1);
  if offset(2)+h2>h1;mh2=h1;else mh2=offset(2)+h2;end
  if offset(1)+w2>w1;mw2=w1;else mw2=offset(1)+w2;end
  mask=zeros(h1,w1);
  mask(1+offset(2):mh2,1+offset(1):mw2)=1;
  mask=reshape(mask,h1*w1,1);
  pos1=find(mask);
  mask=zeros(h2,w2);
  mask(1:(mh2-offset(2)),1:(mw2-offset(1)))=1;
  mask=reshape(mask,h2*w2,1);
  pos2=find(mask);
  [r1 g1 b1]=ergbsplitt(image1(pos1));
  [r2 g2 b2]=ergbsplitt(image2(pos2));
  r1=r1.*(1-rf(pos2))+r2.*rf(pos2); 
  g1=g1.*(1-gf(pos2))+g2.*gf(pos2); 
  b1=b1.*(1-bf(pos2))+b2.*bf(pos2); 
  mixedImage=bitshift(fix(r1*255),16)+bitshift(fix(g1*255),8)+fix(b1*255);
  image1(pos1)=mixedImage;
  mixedImage=reshape(image1,h1,w1);
