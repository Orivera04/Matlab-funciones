%%NAME
%%  etxtread  - read text-file
%%
%%SYNOPSIS
%%  [text,textLength]=etxtread(textFileName)
%%
%%PARAMETER(S)
%%  textFileName  name of textfile
%%  text        sting of text
%%
% written by stefan.mueller@fgan.de (C) 2007
function [text,textLength]=etxtread(textFileName)
  if nargin>1
    eusage('[text,textLength]=etxtread(textFileName)');
  end
  eglobpar;
  textFile=fopen(textFileName,'rb');
  [text textLength]=fread(textFile,inf,'uchar');
  fclose(textFile);
  text=setstr(text');
