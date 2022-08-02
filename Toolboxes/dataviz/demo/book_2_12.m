%  book_2_12.m
%  calls boxparams, dotplot

load singer

%  calculate box plot parameters
outliers = [];
ii = 1;
[params(ii,:), outs] = boxparams(Soprano_1);
outliers = [outliers; [repmat(ii,length(outs),1) outs(:)]];
ii = ii+1;
[params(ii,:), outs] = boxparams(Soprano_2);
outliers = [outliers; [repmat(ii,length(outs),1) outs(:)]];
ii = ii+1;
[params(ii,:), outs] = boxparams(Alto_1);
outliers = [outliers; [repmat(ii,length(outs),1) outs(:)]];
ii = ii+1;
[params(ii,:), outs] = boxparams(Alto_2);
outliers = [outliers; [repmat(ii,length(outs),1) outs(:)]];
ii = ii+1;
[params(ii,:), outs] = boxparams(Tenor_1);
outliers = [outliers; [repmat(ii,length(outs),1) outs(:)]];
ii = ii+1;
[params(ii,:), outs] = boxparams(Tenor_2);
outliers = [outliers; [repmat(ii,length(outs),1) outs(:)]];
ii = ii+1;
[params(ii,:), outs] = boxparams(Bass_1);
outliers = [outliers; [repmat(ii,length(outs),1) outs(:)]];
ii = ii+1;
[params(ii,:), outs] = boxparams(Bass_2);
outliers = [outliers; [repmat(ii,length(outs),1) outs(:)]];

names = {'Soprano 1'; 'Soprano 2'; 'Alto 1'; 'Alto 2';...
   'Tenor 1'; 'Tenor 2'; 'Bass 1'; 'Bass 2'};

%  just use medians
vmedian = params(:,3);

dotplot(vmedian,names)
xlabel('Height (inches)')
title('Singer')
axlim = axis;
axlim(1) = 63;
axlim(2) = 73;
axis(axlim)

pos = get(gca,'Position');
change = 0.1*pos(3);
pos(3) = pos(3)-change;
pos(1) = pos(1)+change;
set(gca,'Position',pos)

