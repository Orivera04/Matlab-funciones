%  book_2_17.m
%  calls rfplot

load singer

names = {'Soprano_1'; 'Soprano_2'; 'Alto_1'; 'Alto_2';...
   'Tenor_1'; 'Tenor_2'; 'Bass_1'; 'Bass_2'};

%  accumulate residual and fit values
resid = [];
fit = [];
for ii = 1:length(names)
   eval(['temp = ',names{ii},'(:);']);
   mt = mean(temp);
   lt = length(temp);
   resid = [resid; temp-mt];
   fit = [fit; repmat(mt,lt,1)];
end

fit = fit-mean(fit);

%  plot quantiles of residual and fit
rfplot(fit,resid,'Height (inches)')
