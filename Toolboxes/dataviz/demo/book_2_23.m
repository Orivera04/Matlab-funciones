%  book_2_23.m
%  calls boxparams, boxplotter

load fusion

%  get boxplot parameters
outliers = [];
ii = 1;
[params(ii,:), outs] = boxparams(VV);
outliers = [outliers; [repmat(ii,length(outs),1) outs(:)]];
ii = ii+1;
[params(ii,:), outs] = boxparams(NV);
outliers = [outliers; [repmat(ii,length(outs),1) outs(:)]];

names = {'VV'; 'NV'};

%  make boxplot
boxplotter(params,outliers,names)
xlabel('Time (seconds)')
title('Fusion')
