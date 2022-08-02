function chromosome=genbin(bitl,numchrom)
%
% Example call: chromosome=genbin(bitl,numchrom)
% Generates numchrom chromosomes of bitlength bitl.
% Called by optga.
%
maxchros=2^bitl;
if numchrom>=maxchros
  numchrom=maxchros;
end
chromosome=round(rand(numchrom,bitl));
