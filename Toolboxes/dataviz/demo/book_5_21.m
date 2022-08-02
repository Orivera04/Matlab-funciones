%  book_5_21.m

load iris

%  jitter amount
jit = 0.05;

%  make combined parameters
size = PetalLength.*PetalWidth;
elongation = PetalLength./PetalWidth;

%  separate the varieties
index = Variety==1;
size1 = size(index);
elongation1 = elongation(index);
index = Variety==2;
size2 = size(index);
elongation2 = elongation(index);
index = Variety==3;
size3 = size(index);
elongation3 = elongation(index);

%  plot with symbol and color
hg = plot(log2(size1),jitter(log2(elongation1),jit),'x',...
   log2(size2),jitter(log2(elongation2),jit),'o',...
   log2(size3),jitter(log2(elongation3),jit),'+');
xlabel('Size (log_2 cm)')
ylabel('Jittered Elongation (log_2 ratio)')
title('Iris')
legend(hg,char(VarietyName),3)

%  plot divisions between clusters
hold on
plot([0.9 0.9],[1 4],'--k',[3 3],[1 4],'--k')
hold off

