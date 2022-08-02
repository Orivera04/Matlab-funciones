subplot(1,2,1)
x = sprand(100, 100, 0.1);
spy(x)
title('\bfsprand','fontsize', 18);
subplot(1,2,2)
x = sprandsym(100, 0.1);
spy(x)
title('\bfsprandsym','fontsize', 18);