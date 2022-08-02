%  book_2_3.m

load singer

qqplot(Tenor_1,Bass_2)
%  make axes equal
naxis = axis;
naxis(1) = min([naxis(1) naxis(3)]);
naxis(3) = naxis(1);
naxis(2) = min([naxis(2) naxis(4)]);
naxis(4) = naxis(2);
axis(naxis)


xlabel('Tenor_1 Height')
ylabel('Bass_2 Height')