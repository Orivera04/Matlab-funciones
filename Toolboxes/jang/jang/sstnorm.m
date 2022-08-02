% display the t-norm and t-conorm (s-norm) of two fuzzy set A and B.

x = (-15:0.4:15)';
A = gbell_mf(x, [7.5, 2, -5]);
B = gbell_mf(x, [5, 1, 5]);

t_norm4 = tsc(A, B, -1);
t_norm3 = A.* B;		% p = 0
t_norm2 = tsc(A, B, 1);
t_norm1 = min(A, B);		% p = infinity

t_conorm4 = ssc(A, B, -1);
t_conorm3 = A + B - A.*B; 	% p = 0
t_conorm2 = ssc(A, B, 1);
t_conorm1 = max(A, B);		% p = infinity

t_norm_all = [ t_norm1 t_norm2 t_norm3 t_norm4];
t_conorm_all = [ t_conorm1 t_conorm2 t_conorm3 t_conorm4];

subplot(3,1,1); plot(x, A, '-', x, A, 'o', x, B, '-', x, B, '+');
title('(a) Two fuzzy sets A and B');
text(0, 0.9, 'A');
text(7.5, 0.9, 'B');
if matlabv==4,
	set(gca, 'xticklabels', []);
elseif matlabv==5,
	set(gca, 'xticklabel', []);
else
	error('Unknown MATLAB version!');
end
axis([-inf inf 0 1.2]);

subplot(3,1,2); plot(x, t_norm_all);
title('(b) T-norm of A and B');
set(gca, 'xticklabels', []);
axis([-inf inf 0 1.2]);

subplot(3,1,3); plot(x, t_conorm_all);
title('(c) T-conorm (S-norm) of A and B');
set(gca, 'xticklabels', []);
axis([-inf inf 0 1.2]);
