%%NAME
%%  equisci  - encode/decode  vector with QUISCI-cipher
%%
%%SYNOPSIS
%%  [code,checksum]=equisci(code,key)
%%
%%PARAMETER(S)
%%  code        vector for encoding/decoding
%%  key         key 
%%  checksum    for testing keys
%% 
% written by stefan.mueller@fgan.de (C) 2006
function [code,checksum]=equisci(code,key)
  if (nargin<2)
    eusage('[code,checksum] = equisci(code,key)');
  end
  % init
  s=0:255;
  keyL=length(key);
  key=key+0;
  for i=0:255
    s(i+1)=bitxor(key(rem(i,keyL)+1),i);
  end

  %checksum
  checksum=0;
  t=keyL;
  for i=0:255
    t=bitxor(t,s(i+1));
    checksum=checksum+t;
  end
  checksum=checksum-bitshift(bitshift(checksum,-8),8);

  %loop
  i=s(256);j=0;x=0;
  for k=1:length(code) 
    t=i+s(j+1);
    i=t-bitshift(bitshift(t,-8),8);
    if i==0
      i=bitxor(255,s(j+1));
      s(j+1)=x;
      code(k)=bitxor(code(k),i);
    else
      x=bitxor(i,s(j+1));
      s(j+1)=i;j=i;
      code(k)=bitxor(code(k),x);
    end
  end
