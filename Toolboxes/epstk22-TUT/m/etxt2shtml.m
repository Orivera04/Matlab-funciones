%%NAME
%%  etxt2shtml  - encode text to secret html-file 
%%
%%SYNOPSIS
%%  checksum=etxt2shtml(text,htmlFilename,key[,title[,legend[,mineTye[,cipher]]]])
%%
%%PARAMETER(S)
%%  text           vector of unsigned char 
%%                 or string
%%                 or filename of text-file
%%  htmlFilename   string of html-filename
%%  key            vector of unsigned char
%%                 or string
%%  title          title of encoded file
%%  legend         legend under lock
%%  mineType       default='text/html'
%%  cipher         cipher id, default=0
%%                 0=QUISCI
%%                 1=RC4
%%  checksum       checksum of cipher
% written by stefan.mueller@fgan.de (C) 2006

function checksum=etxt2shtml(text,htmlFile,key,title,legend,mineType,cipher)
  if nargin<3 | nargin >7
    eusage('checksum=etxt2shtml(text,htmlFilename,key[,title[,legend[,mineType[,cipher]]]])');
  end
  if nargin<7
    cipher=0;
  end
  if nargin<6
    mineType='text/html';
  end
  if nargin<5
    legend='Move the mouse pointer over the lock'
  end
  if nargin<4
    title='Encoded Text'
  end
  if length(key)<16
    diff=16-length(key);
    message=sprintf('Warning: Your key is unsafe. Use %d character more !',diff); 
    disp(message);
  end
  textL=length(text);
  if textL<80
    if exist(text)==2
      txtFileName=text;
      [text textL]=etxtread(txtFileName);
    end
  end
  if nargout>0
    message=0;
  else
    message=1;
  end
  eglobpar;
  if exist('eFac')
    if isempty(eFac)
      einit;
    end
  else
    einit;
  end
  cPath=ePath;
  text=text+0;
  identNo=num2str(sum(text));
  key=[setstr(key) identNo];
  if cipher==0
    [text checksum]=equisci(text,key);
    decoderFileName=[cPath 'quisci.inc'];
  elseif cipher==1
    [text checksum]=erc4(text,key);
    decoderFileName=[cPath 'rc4.inc'];
  else
    [text checksum]=equisci(text,key);
    decoderFileName=[cPath 'quisci.inc'];
  end
  % read decoder
  decoderFile=fopen(decoderFileName,'rb');
  [decodeFunction n]=fread(decoderFile,inf,'uchar');
  fclose(decoderFile);
  % read template
  templateFileName=[cPath 'shtmltxt.inc'];
  templateFile=fopen(templateFileName,'rb');
  [htmlTemplate n]=fread(templateFile,inf,'uchar');
  fclose(templateFile);
  
  % write shtml
  fid=fopen(htmlFile,'wb');
  fprintf(fid,'<!-- Created by eimg2shtml, a function of EpsTk,\n');
  fprintf(fid,'     written by stefan.mueller@fgan.de 2006     -->\n');
  fprintf(fid,'<script language=''JavaScript'' type=''text/javascript''>\n');
  fprintf(fid,'<!--\n// text data\n');
  fprintf(fid,'var myTextChecksum = %d;\n',checksum);
  fprintf(fid,'var myMineType = ''%s'';\n',mineType);
  fprintf(fid,'var myIdentNo = ''%s'';\n',identNo);
  fprintf(fid,'var myTitle = ''%s'';\n',title);
  fprintf(fid,'var myLegend = ''%s'';\n',legend);
  fprintf(fid,'var myArray = [\n');
  fprintf(fid,'%d,',text(1:textL-1));
  fprintf(fid,'%d\n',text(textL));
  fprintf(fid,'];\n');
  fwrite(fid,decodeFunction,'uchar');
  fwrite(fid,htmlTemplate,'uchar');
  if message
    message=sprintf('%s is written',htmlFile); 
    disp(message);
  end
  fclose(fid);
  eglobpar
  eFileName=htmlFile;
