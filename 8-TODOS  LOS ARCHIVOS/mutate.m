function chrom=mutate(chrom,mu)
%
% Example call: chrom=mutate(chrom,mu)
% mutates chrom at rate given by mu
% Called by optga
%
[pop bitlength]=size(chrom);
for i=1:pop
  for j=1:bitlength
    if rand<=mu
      if chrom(i,j)==1
        chrom(i,j)=0;
      else
        chrom(i,j)=1;
      end
    end
  end
end
