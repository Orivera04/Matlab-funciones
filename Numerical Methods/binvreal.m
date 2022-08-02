function rval=binvreal(chrom,a,b)
% Converts binary string chrom to real value in range a to b.
%
% Example call rval=binvreal(chrom,a,b)
% Normally called from optga.
[pop bitlength]=size(chrom);
maxchrom=2^bitlength-1;
realel=chrom.*((2*ones(1,bitlength)).^fliplr([0:bitlength-1]));
tot=sum(realel);
rval=a+tot*(b-a)/maxchrom;
