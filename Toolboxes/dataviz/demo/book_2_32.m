%  book_2_32.m
%  calls rfplot

load fusion

%  apply log transform
NV = log2(NV);
VV = log2(VV);

%  calculate fit and residual for both cases
fitted = [repmat(mean(NV),length(NV),1); repmat(mean(VV),length(VV),1)];
residual = [NV-mean(NV); VV-mean(VV)];

rfplot(fitted,residual)