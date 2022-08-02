%%NAME
%%  ecdcover  -  write a cdcover 
%%
%%SYNOPSIS
%%  ecdcover(title[,description[,author[,version[,date[,textColor
%%          [,frontImage[,background[,logo[,content]]]]]]]]])
%%
%%PARAMETER(S)
%%  title         string of title of cd  
%%  description   string of description, default=''
%%  author        string of author, default=''
%%  version       string of version, default=''
%%  date          string of time or date, default=''
%%  textColor     color vector [r g b]  [0 0 0]=black [1 1 1]=white,
%%                default=[0 0 0]
%%  frontImage    filename of frontImage , default=''
%%  background    filename of background, default=''
%%  logo          filename  of logo, default=''
%%  content       filename(asci-file, tabs with '#')  of table of contents
%%
% written by Stefan Mueller stefan.mueller@fgan.de (C) 2003

function ecdcover(title,description,author,version,date,textColor, ...
                 frontImage,background,logo,content)
  if nargin<1 | nargin>10
    eusage('ecdcover(title[,description[,author[,version[,date[,textColor[,frontImage[,background[,logo[,content]]]]]]]])');
  end
  eglobpar;
  if nargin<10
    content='';
  end
  if nargin<9
    logo='';
  end
  if nargin<8
    background='';
  end
  if nargin<7
    frontImage='';
  end
  if nargin<6
    textColor=[0 0 0];
  end
  if nargin<5
    date='';
  end
  if nargin<4
    version='';
  end
  if nargin<3
    author='';
  end
  if nargin<2
    description='';
  end

  esavpar;
  fCoverH=119.5;
  fCoverW=119.5;
  bCoverH=117.5;
  bCoverW=150;
  bCoverPos=[(eWinWidth-bCoverW)/2 (eWinHeight-fCoverH-bCoverH)/2];
  fCoverPos=[bCoverPos(1) bCoverPos(2)+0.25+bCoverH];
  contentW=120;
  contentH=60;
  logoH=10;
  fImageH=60;
  if isempty(version)
    fImageH=fImageH-10
  end

%frontside
  %background
  if ~isempty(background)
    im=eimgread(background);
    eframe(fCoverPos(1),fCoverPos(2),fCoverW,fCoverH,0,im,-1);
  else
    eframe(fCoverPos(1),fCoverPos(2),fCoverW,fCoverH,1);
  end

  %frontImage
  if ~isempty(frontImage)
    im=eimgread(frontImage);
    [ih iw]=size(im);
    whFac=iw/ih;
    fImageW=fImageH*whFac;
    fImagePos=[fCoverPos(1)+(fCoverW-fImageW)/2 ...
               fCoverPos(2)+(fCoverH-fImageH)/3];
    eframe(fImagePos(1),fImagePos(2),fImageW,fImageH,0,im,-1);
    eframe(fImagePos(1),fImagePos(2),fImageW,fImageH,0.2);
  end

  %title
  etext(title,fCoverPos(1)+fCoverW/2,fCoverPos(2)+100,10,0,1,0,textColor);

  %description
  etext(description,fCoverPos(1)+fCoverW/2,fCoverPos(2)+90,6,0,1,0,textColor);

  %version
  etext(version,fCoverPos(1)+fCoverW/2,fCoverPos(2)+10,6,0,1,0,textColor);
  
%backside
  %background
  %background
  if ~isempty(background)
    im=eimgread(background);
    eframe(bCoverPos(1),bCoverPos(2),bCoverW,bCoverH,0,im,-1);
  else
    eframe(bCoverPos(1),bCoverPos(2),bCoverW,bCoverH,1);
  end

  %logo
  if ~isempty(logo)
    im=eimgread(logo);
    [ih iw]=size(im);
    whFac=iw/ih;
    logoW=logoH*whFac;
    logoPos=[bCoverPos(1)+(bCoverW-logoW)/2 ...
             bCoverPos(2)+10+5/2-logoH/2];
    eframe(logoPos(1),logoPos(2),logoW,logoH,0,im,-1);
  end

  %title
  etext(title,bCoverPos(1)+bCoverW/2,bCoverPos(2)+105,8,0,1,0,textColor);
  etext(title,bCoverPos(1)+4,bCoverPos(2)+bCoverH*5/6,4,0,1,90,textColor);
  etext(title,bCoverPos(1)+bCoverW-4,bCoverPos(2)+bCoverH*5/6,4,0,1,270,textColor);

  %description
  etext(description,bCoverPos(1)+bCoverW/2,bCoverPos(2)+97,5,0,1,0,textColor);
  etext(description,bCoverPos(1)+4,bCoverPos(2)+bCoverH*3/12,4,0,1,90,textColor);
  etext(description,bCoverPos(1)+bCoverW-4,bCoverPos(2)+bCoverH*3/12,4,0,1,270,textColor);

  %date
  etext(date,bCoverPos(1)+bCoverW*1/4,bCoverPos(2)+10,5,0,1,0,textColor);

  %version
  etext(version,bCoverPos(1)+4,bCoverPos(2)+bCoverH*7/12,4,0,1,90,textColor);
  etext(version,bCoverPos(1)+bCoverW-4,bCoverPos(2)+bCoverH*7/12,4,0,1,270,textColor);

  %author
  etext(author,bCoverPos(1)+bCoverW*3/4,bCoverPos(2)+10,5,0,1,0,textColor);

  % table of contents 
  if ~isempty(content)
    [textString,tl]=etxtread(content);
    cr=setstr(13);
    lf=setstr(10);
    tab='#';
    pos=findstr(textString,cr);
    textString(pos)=' ';
    pos=findstr(textString,lf);
    nLines=length(pos);
    fontSpace=contentH/nLines;
    if fontSpace>5;
      fontSize=5;
    else
      fontSize=fontSpace;
    end
    lineStart=1;
    for i=1:nLines
      tabPos=findstr(textString(lineStart:pos(i)-1),tab);
      if length(tabPos)>0
        tabPos=[tabPos+lineStart-1 pos(i)];
      else 
        tabPos=pos(i);
      end
      nRows=length(tabPos);
      tabSpace=contentW/nRows;
      textStart=lineStart;
      for k=1:nRows
        if tabPos(k)>textStart
          text=textString(textStart:(tabPos(k)-1));
          etext(text,bCoverPos(1)+(bCoverW-contentW)/2+(k-1)*tabSpace,...
                bCoverPos(2)+90-i*fontSpace,...
                fontSize,1,1,0,textColor);
        end
        textStart=tabPos(k)+1;

      end
      lineStart=pos(i)+1;
    end
  end
  
  erespar;
