%  book_2_2.m
%  makes histogram and smoothed histogram

load singer

x = Bass_2;
bins = min(x)-1:1:max(x)+1;
h1 = hist(x,bins);
bar(bins,h1)
xlabel('Height (inches)')
ylabel('Number of Bass_2')

%  Plot with fewer bins
figure
bins2 = min(x)-1:2:max(x)+1;
h2 = hist(x,bins2);
bar(bins2,h2)
xlabel('Height (inches)')
ylabel('Number of Bass_2')

%  Compare with other bass
figure
x1 = Bass_1;
h11 = hist(x1,bins);
bar(bins,[h1(:) h11(:)],1)
xlabel('Height (inches)')
ylabel('Number of Singers')
legend({'Bass_2';'Bass_1'},2)

%  make smoothed histogram using a small kernel
figure
filterCoef = [0.25 0.5 0.25];
hf = filter(filterCoef,1,[h1 zeros(1,ceil(length(filterCoef)/2))]);
bins2 = min(x)-1:1:max(x)+length(filterCoef);
if hf(1)==0
   hf(1) = [];
   bins2(1) = [];
end
if hf(end)==0
   hf(end) = [];
   bins2(end) = [];
end
bar(bins2-1,hf)
xlabel('Height (inches)')
ylabel('Smoothed Number of Bass_2')


