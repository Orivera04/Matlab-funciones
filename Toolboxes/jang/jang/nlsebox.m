% Steepest descent, Gauss-Newton, and Levenberg-Marquardt directions
% using BOX function
%
% Eiji Mizutani and Jyh-Shing Roger Jang.   June, 1996.
%

% Starting point 
p0 = 5; q0 = 1;
x=[0.1; 0.2; 0.3; 0.4; 0.5; 0.6; 0.7; 0.8; 0.9; 1.0];
% target values
t = exp(-x) - exp(-10.0*x);

point_n = 21;
p = linspace(-1, 6, point_n);
q = linspace(0, 11, point_n);
[pp, qq] = meshgrid(p, q);
E = zeros(point_n, point_n);

for i = 1:point_n,
	for j = 1:point_n,
		y = exp(-pp(i,j)*x)-exp(-qq(i,j)*x);
		E(i,j) = (t-y)'*(t-y); 
%%%%%%		E(i,j) = sum((t-y).*(t-y));
	end
end
subplot(2,2,1);
h = mesh(pp, qq, E);
set(h, 'facecolor', 'none');
xlabel('p'); ylabel('q'); zlabel('E(p,q)');
axis([-inf inf -inf inf -inf inf]);
set(gca, 'box', 'on');
y = exp(-x)-exp(-10*x);
E_tmp = (t-y)'*(t-y) ;
line(1, 10, E_tmp, 'linestyle', '*'); 
hold on
y = exp(-p0*x)-exp(-q0*x);
E_tmp = (t-y)'*(t-y) ;
line(p0, q0, E_tmp, 'linestyle', 'O'); 
% plot(p0, q0, 'x'); 
hold off
view([-230 30]);

subplot(2,2,2);
% contour(pp, qq, E, 500);
contour(pp, qq, E, 20);
line(1, 10, 'linestyle', '*'); 
hold on
plot(p0, q0, 'O'); 
% 
point_n = 10;
J = zeros(point_n, 2); 
sd_pos=zeros(10, 2); gn_pos=zeros(10, 2); lm_pos=zeros(10, 2); 
J = [-(-x.*exp(-p0*x))  -(x.*exp(-q0*x)) ]; 
%
% r = t - y
%       .
% J = - y
%
y = exp(-p0*x)-exp(-q0*x);
g = 2.0 * J' * ( t - y );
p_cur = [ p0; q0 ];
sd_dir = -g;
% For displaying purpose, arrow length is set to 2. 
sd_dir = 2.0 * sd_dir/norm(sd_dir);
sd_pos = [p_cur p_cur+sd_dir];
arrow(sd_pos(1, :), sd_pos(2, :), 0.2, 'g-');
text(4.5, 3.4, 'SD','fontsize', 10);

JJ = J'*J;
gn_dir = -1/2 * inv(JJ)*g;
% For displaying purpose, arrow length is set to 2. 
gn_dir = 2.0 * gn_dir / norm(gn_dir); 
gn_pos = [p_cur p_cur+gn_dir];
arrow(gn_pos(1, :), gn_pos(2, :), 0.2, 'w-');
text(1.8, 1.3, 'GN', 'fontsize', 10);

lambda = 0.07;
lm_dir = -inv(JJ +lambda*eye(size(JJ)))*g;
% For displaying purpose, arrow length is set to 2. 
lm_dir = 2.0 * lm_dir / norm(lm_dir); 
lm_pos = [p_cur p_cur+lm_dir];
arrow(lm_pos(1, :), lm_pos(2, :), 0.2, 'r-');
text(2.8, 2.9, 'LM','fontsize', 10);
xlabel('p'); ylabel('q');
axis image
hold off
