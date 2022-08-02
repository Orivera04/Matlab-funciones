%  alt_4_2.m

load rubber

data = [Hardness TensileStrength AbrasionLoss];
label = {'Hardness' 'Tensile Strength' 'Abrasion Loss'};
x = Hardness;
y = TensileStrength;
z = AbrasionLoss;

%  make color map index
nc = 20;
offset = 1;
c = AbrasionLoss-min(AbrasionLoss);
c = round((nc-1-2*offset)*c/max(c)+1+offset);

scatter(x,y,6,c,'filled')
xlabel('Hardness')
ylabel('TensileStrength')
title('Rubber')
box on
colormap(hot(nc))
mymap = colormap;
colormap(flipud(mymap))
hg = colorbar;

%  put meaningful labels on colorbar
[cu,ii,jj] = unique(c);
au = AbrasionLoss(ii);
barTick = get(hg,'YTick');
barLabel = round(interp1(cu,au,barTick));
set(hg,'YTickLabel',barLabel)

brighten(-0.5)