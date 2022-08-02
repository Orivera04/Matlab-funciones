%%NAME
%%  etxtwrit  - write string to text-file
%%
%%SYNOPSIS
%%  etxtwrit(text,textFileName)
%%
%%PARAMETER(S)
%%  text        sting of text
%%  textFileName  name of textfile
%%
% written by stefan.mueller@fgan.de (C) 2007
function etxtwrit(text,textFileName)
  if nargin~=2
    eusage('etxtwrit(text,textFileName)');
  end
  textFile=fopen(textFileName,'wb');
  fprintf(textFile,'%s',text);
  fclose(textFile);
