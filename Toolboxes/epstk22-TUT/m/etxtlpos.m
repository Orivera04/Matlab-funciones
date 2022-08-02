%%NAME
%%  etxtlpos  - get text line positions
%%
%%SYNOPSIS
%%  [linePos,nLines]=etxtlpos(text[,lineLimit])
%%
%%PARAMETER(S)
%%  text        sting of text
%%  lineLimit   sting for splitting lines (default=eTextLimitPara)
%%  linePos     nLines x 2 Matrix of start and end positions
%%              [line1StartPos line1EndPos; line2StartPos line2EndPos ...
%%  nLines      number of lines
%%
% written by stefan.mueller@fgan.de (C) 2007
function [linePos,nLines]=etxtlpos(text,lineLimit)
  if nargin<1 | nargin >2
    eusage('[linePos,nLines]=etxtlpos(text[,lineLimit])');
  end
  eglobpar;

  if nargin <2
    if exist('eFac')
      if isempty(eFac)
        einit;
      end
    else
      einit;
    end
    lineLimit=eTextLimitPara;
  end 
  tl=length(text);
  ll=length(lineLimit);
  pos=findstr(text,lineLimit);
  nLines=length(pos);
  if nLines>0
    posStart=[1 pos(1:nLines-1)+ll];
    posEnd=pos-1;
    if pos(1)>1
      if text(pos(1)-1)==setstr(13)
        posEnd=pos-2;
      end
    end
    if pos(nLines)+ll-1<tl
      posStart=[posStart pos(nLines)+ll];
      posEnd=[posEnd tl];
      nLines=nLines+1;
    end
    linePos=[posStart' posEnd'];
  else
    nLines=1;
    linePos=[1 length(text)];
  end
