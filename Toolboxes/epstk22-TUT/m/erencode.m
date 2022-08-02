% newFont=erencode( epsFile ,oldFont)
% written by stefan.mueller@fgan.de (C) 2007

function newFont=erencode(epsFile,oldFont)
  if (nargin~=2)
    eusage('newFont=erencode(epsFile,oldFont)');
  end
  blaStr='                                                 ';
  oldSize=length(oldFont);
  oldFont=oldFont(find(oldFont~=' '));
  newFont=sprintf('%sG',oldFont);
  fprintf(epsFile,'(%s) (%s) ReEncode\n',oldFont,newFont);
  newFont=[newFont blaStr(1:oldSize+1-length(oldFont))];
