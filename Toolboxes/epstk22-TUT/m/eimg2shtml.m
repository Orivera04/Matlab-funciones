%%NAME
%%  eimg2shtml  - encode image to secret html-file 
%%
%%SYNOPSIS
%%  checksum=eimg2shtml(imgFilename,htmlFilename,key,title,legend)
%%
%%PARAMETER(S)
%%  imgFilename    string of image-filename (jpeg-file or png-file)
%%  htmlFilename   string of html-filename
%%  key            vector of unsigned char
%%                 or string
%%  title          title of image
%%  legend         legend under image
%%  checksum       checksum of cipher
% written by stefan.mueller@fgan.de (C) 2006

function checksum=eimg2shtml(imgFilename,htmlFilename,key,title,legend)
  if nargin<3
    eusage('checksum=eimg2shtml(imgFilename,htmlFilename,key[,title[,legend]])');
  end
  if nargin<4
    title='Encoded Image';
  end
  if nargin<5
    legend='Move the mouse pointer over the lock';
  end
  if nargout>0
    message=0;
  else
    message=1;
  end
  if length(key)<16
    diff=16-length(key);
    message=sprintf('Warning: Your key is unsafe. Use %d character more !',diff); 
    disp(message);
  end
  eglobpar;
  if exist('eFac')
    if isempty(eFac)
      einit;
    end
  else
    einit;
  end
  % read includes
  [decodeFunction n]=etxtread([ePath 'quisci.inc']);
  [htmlTemplate n]=etxtread([ePath 'shtmlimg.inc']);
  % read image
  fid=fopen(imgFilename,'rb');
  [imgString n]=fread(fid,inf,'uchar');
  fclose(fid);
  imgString=imgString+0;
  b64=evec2b64(imgString);
  % key
  identNo=num2str(sum(b64));
  key=[setstr(key) identNo];
  % encode image
  [code checksum]=equisci(b64,key);
  codeL=length(code);
  % write array
  fid=fopen(htmlFilename,'wb');
  fprintf(fid,'<!-- Created by eimg2shtml, a function of EpsTk,\n');
  fprintf(fid,'     written by stefan.mueller@fgan.de 2006     -->\n');
  fprintf(fid,'<script language=''JavaScript'' type=''text/javascript''>\n');
  fprintf(fid,'<!--\n// image data\n');
  fprintf(fid,'var myImageChecksum = %d;\n',checksum);
  fprintf(fid,'var myIdentNo = ''%s'';\n',identNo);
  fprintf(fid,'var myTitle = "%s"\n',title);
  fprintf(fid,'var myText = "%s"\n',legend);
  fprintf(fid,'var myArray = [\n');
  fprintf(fid,'%d,',code(1:codeL-1));
  fprintf(fid,'%d\n',code(codeL));
  fprintf(fid,'];\n');
  fwrite(fid,decodeFunction,'uchar');
  fwrite(fid,htmlTemplate,'uchar');
  fclose(fid);

  if message
    message=sprintf('%s is written',htmlFilename); 
    disp(message);
  end
  eglobpar
  eFileName=htmlFilename;
