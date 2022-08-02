subplot('position',[0  0.95 1 0.2]);
h=text(0.01,0.01, '\bf\itDeux distributions aléatoires', 'fonts', 18); axis off
subplot('position',[0.1 0.01 0.35 0.8]);
x = rand(1,10000); hist(x, 30);
title('\bfdistribution uniforme', 'fonts', 18)
subplot('position',[0.55  0.01 0.35 0.8]);
x = randn(1,10000); hist(x, 30);
title('\bfdistribution gaussienne', 'fonts', 18)
