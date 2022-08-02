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
% written by stefan.mueller stefan.mueller@fgan.de (C) 2003
function etxtwrit(text,textFileName)
  if nargin~=2
    eusage('etxtwrit(text,textFileName)');
  end
  textFile=fopen(textFileName,'w');
  fprintf(textFile,'%s',text);
  fclose(textFile);
