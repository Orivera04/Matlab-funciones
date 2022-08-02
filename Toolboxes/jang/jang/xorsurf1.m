% Surface plots for 2-2-1 MLP. 

k = 1000;
w1 = [1 1; 1 1];	% weights of layer 1
b1 = [-1.5 -0.5];	% bias of layer 1
w2 = [-1; 1];		% weights of layer 2
b2 = -0.5;		% bias of layer 2

point_n = 21;
x = linspace(0, 1, point_n);
y = linspace(0, 1, point_n);
[xx, yy] = meshgrid(x, y);
input = [xx(:) yy(:)];
data_n = size(input, 1);
net1 = [input ones(data_n, 1)]*[w1; b1];
out1 = 1./(1+exp(-k*net1));	% outputs of layer 1
net2 = [out1 ones(data_n, 1)]*[w2; b2];
out2 = 1./(1+exp(-k*net2));	% outputs of layer 2

% output of node 5 in terms of node 3 and 4
net = [input ones(data_n, 1)]*[w2; b2];
out = 1./(1+exp(-k*net));

xx3 = reshape(out1(:, 1), point_n, point_n);
xx4 = reshape(out1(:, 2), point_n, point_n);
xx5 = reshape(out, point_n, point_n);
final_xx5 = reshape(out2, point_n, point_n);
v_angle = [20 70];		% viewing angle

subplot(2,2,1); mesh(xx, yy, xx3);
axis([-inf inf -inf inf -inf inf]); view(v_angle);
xlabel('x1'); ylabel('x2'); title('(a) x3');
line(0, 0, 0, 'linestyle', 'o', 'color', 'g');
line(0, 1, 1, 'linestyle', 'x', 'color', 'm');
line(1, 0, 1, 'linestyle', 'x', 'color', 'm');
line(1, 1, 0, 'linestyle', 'o', 'color', 'g');

subplot(2,2,2); mesh(xx, yy, xx4);
axis([-inf inf -inf inf -inf inf]); view(v_angle);
xlabel('x1'); ylabel('x2'); title('(b) x4');
line(0, 0, 0, 'linestyle', 'o', 'color', 'g');
line(0, 1, 1, 'linestyle', 'x', 'color', 'm');
line(1, 0, 1, 'linestyle', 'x', 'color', 'm');
line(1, 1, 0, 'linestyle', 'o', 'color', 'g');

subplot(2,2,3); mesh(xx, yy, xx5);
axis([-inf inf -inf inf -inf inf]); view(v_angle);
xlabel('x3'); ylabel('x4'); title('(c) x5');
line(0, 0, 0, 'linestyle', 'o', 'color', 'g');
line(0+0.02, 1+0.02, 1, 'linestyle', 'x', 'color', 'm');
line(0-0.02, 1-0.02, 1, 'linestyle', 'x', 'color', 'm');
line(1, 1, 0, 'linestyle', 'o', 'color', 'g');

subplot(2,2,4); mesh(xx, yy, final_xx5);
axis([-inf inf -inf inf -inf inf]); view(v_angle);
xlabel('x1'); ylabel('x2'); title('(d) x5');
line(0, 0, 0, 'linestyle', 'o', 'color', 'g');
line(0, 1, 1, 'linestyle', 'x', 'color', 'm');
line(1, 0, 1, 'linestyle', 'x', 'color', 'm');
line(1, 1, 0, 'linestyle', 'o', 'color', 'g');

set(findobj(gcf, 'type', 'axes'), 'box', 'on');
set(findobj(gcf, 'type', 'line'), 'linewidth', 2, 'markersize', 10);

% The following command is used to make the surface transparent.
% However, if it's used, "print -deps figure" will give a color PS file.
% To have a BW PS file, you should do "colormap(0*ones(64,3))" before
% issuing the print command. 
set(findobj(gcf, 'type', 'surface'), 'facecolor', 'none');
