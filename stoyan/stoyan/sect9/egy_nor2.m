% © Fazekas Istvan 1998; program a Statisztika c. reszhez

x=unifrnd(-1,1,199,1); y=normrnd(0,1/(sqrt(3)),199,1);
z=[x y], kozep=mean(z), medi=median(z),
csonkakozep=trimmean(z,10), mertanikozep=geomean(abs(z)),
variancia=var(z), szoras=std(z),
terjedelem=range(z), interkvar=iqr(z),
m4=moment(z,4), lapultsag=kurtosis(z), ferdeseg=skewness(z),
alkvantilis=prctile(z,5), felkvantilis=prctile(z,95),
kovariancia=cov(z), korrelacio=corrcoef(z)