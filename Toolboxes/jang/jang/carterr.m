x = 1:20;
x(7) = [];
trn_error = 1./x;
trn_error = trn_error - min(trn_error); 
chk_error = 1./x + 0.2 + 0.008*(x-12).*(x-12>0);
blackbg;
subplot(2,2,1);
plot(x, trn_error, 'yo', x, chk_error, 'm*', ...
     x, trn_error, 'g-', x, chk_error, 'g-');
xlabel('Number of Terminal Nodes');
ylabel('Error Measure');
%title('Tree Performance on Training Data (o) and Checking Data (x)');
[min_chk, ind] = min(chk_error);
ylim = get(gca, 'ylim');
tmp_y = ylim(1) + (ylim(2)-ylim(1))/3;
line([x(ind) x(ind)], [ylim(1) tmp_y], 'linestyle', ':'); 
h = text(x(ind), tmp_y, 'Optimum Size = 12');
set(h, 'horizon', 'center', 'vertical', 'bottom');
legend('Training Error', 'Checking Error');
