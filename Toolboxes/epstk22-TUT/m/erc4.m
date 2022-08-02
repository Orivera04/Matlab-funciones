%%NAME
%%  erc4  - encode/decode  vector with RC4-cipher
%%
%%SYNOPSIS
%%  [code,checksum]=erc4(code,key)
%%
%%PARAMETER(S)
%%  code        vector for encoding/decoding
%%  key         key 
%%  checksum    for testing keys
%% 
% written by stefan.mueller@fgan.de (C) 2006
function [code,checksum]=erc4(code,key)
  if (nargin<2)
    eusage('[code,checksum] = erc4(code,key)');
  end
  s=0:255;
  j=0;
  keyL=length(key);
  for i=0:255
    t=j+s(i+1)+key(rem(i,keyL)+1);
    j=t-bitshift(bitshift(t,-8),8);
    t=s(i+1);s(i+1)=s(j+1);s(j+1)=t;
  end
  checksum=0;
  t=keyL;
  for i=0:255
    t=bitxor(t,s(i+1));
    checksum=checksum+t;
  end
  checksum=checksum-bitshift(bitshift(checksum,-8),8);
  i=0;j=0;
  length(code)
  for k=1:length(code) 
    t=i+1;
    i=t-bitshift(bitshift(t,-8),8);
    t=j+s(i+1);
    j=t-bitshift(bitshift(t,-8),8);
    t=s(i+1);s(i+1)=s(j+1);s(j+1)=t;
    t=s(i+1)+s(j+1);
    t=t-bitshift(bitshift(t,-8),8);
    code(k)=bitxor(code(k),s(t+1));
  end
