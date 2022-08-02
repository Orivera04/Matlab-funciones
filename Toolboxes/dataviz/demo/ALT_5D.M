%  alt_5d.m

load iris

jit = 0.03;

size = PetalLength.*PetalWidth;
elongation = PetalLength./PetalWidth;

index = Variety==1;
size1 = size(index);
elongation1 = elongation(index);
index = Variety==2;
size2 = size(index);
elongation2 = elongation(index);
index = Variety==3;
size3 = size(index);
elongation3 = elongation(index);


hg = plot((size1),jitter(log2(elongation1),jit),'x',...
   (size2),jitter(log2(elongation2),jit),'o',...
   (size3),jitter(log2(elongation3),jit),'+');
xlabel('Size ( cm)')
ylabel('Jittered Elongation (log2 ratio)')
title('Iris')
legend(hg,char(VarietyName),3)

