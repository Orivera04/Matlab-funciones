%%NAME
%%  etxtlpos  - get text line positions
%%
%%SYNOPSIS
%%  [linePos,nLines]=etxtlpos(text)
%%
%%PARAMETER(S)
%%  text        sting of text
%%  linePos     nLines x 2 Matrix of start and end positions
%%              [line1StartPos line1EndPos; line2StartPos line2EndPos ...
%%  nLines      number of lines
%%
% written by stefan.mueller stefan.mueller@fgan.de (C) 2003
function [linePos,nLines]=etxtlpos(text)
  if nargin~=1
    eusage('[linePos,nLines]=etxtlpos(text)');
  end
  eglobpar;
  tl=length(text);
  pos=findstr(text,eTextLimitPara);
  nLines=length(pos);
  if nLines>0
    posStart=[1 pos(1:nLines-1)+1];
    posEnd=pos-1;
    if pos(1)>1
      if text(pos(1)-1)==setstr(13)
        posEnd=pos-2;
      end
    end
    if pos(nLines)<tl
      posStart=[posStart pos(nLines)+1];
      posEnd=[posEnd tl];
      nLines=nLines+1;
    end
    linePos=[posStart' posEnd'];
  else
    nLines=1;
    linePos=[1 length(text)];
  end
