function chrom1=matesome(chrom,matenum)
%
% Example call: chrom1=matesome(chrom,matenum)
% Mates a proportion matenum of chromosomes chrom. 
%
% Mate 60% of chromosomes
mateind=[ ]; chrom1=chrom;
[pop bitlength]=size(chrom); ind=1:pop; 
u=floor(pop*matenum);
if floor(u/2)~=u/2,u=u-1;end;
%select percentage to mate randomly
while length(mateind)~=u
  i=round(rand*pop);
  if i==0,i=1;end;
  if ind(i)~=-1
    mateind=[mateind i]; ind(i)=-1;
  end
end
%perform single point crossover 
for i=1:2:u-1
  splitpos=floor(rand*bitlength);
  if splitpos==0, splitpos=1; end;
  i1=mateind(i); i2=mateind(i+1);
  tempgene=chrom(i1,splitpos+1:bitlength);
  chrom1(i1,splitpos+1:bitlength)=chrom(i2,splitpos+1:bitlength);
  chrom1(i2,splitpos+1:bitlength)=tempgene;
end;
