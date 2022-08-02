%  alt_2_13.m

load singer


names = {'Soprano_1'; 'Soprano_2'; 'Alto_1'; 'Alto_2';...
   'Tenor_1'; 'Tenor_2'; 'Bass_1'; 'Bass_2'};

for ii = 1:length(names)
   eval(['temp = ',names{ii},'(:);']);
   mt(ii) = mean(temp);
   st(ii) = std(temp);
end

plot(mt,st,'o')
xlabel('Height (inches)')
ylabel('Standard Deviation (inches)')
title('Singer')