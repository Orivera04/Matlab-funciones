v = [ [1002 1925 2500 3307]; [1312 2625 2460 3702] ]'; 
a =  2001:2004;
colormap(gray); 
subplot(1, 3, 1); barh(a, v, 0.2, 'grouped'); 
subplot(1, 3, 2); barh(a, v, 'stacked');
subplot(1, 3, 3); bar(a, v, 'grouped');
print -deps2 ex_bar.eps
subplot(1, 2, 1); bar3(a, v, 'grouped','r'); 
subplot(1, 2, 2); bar3(a, v, 'stacked');
print -deps2 ex_bar3.eps