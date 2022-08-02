function kfm2(dataID)
% KFM2 Kohonen's feature map with 2-D output units.
%	KFM2 is Kohonen's feature map with 2-D outputs.
%	KFM2(1) --> data set in a square region.
%	KFM2(2) --> data set in a triangular region.
%	KFM2(3) --> data set in a circle.
%	KFM2(4) --> data set in a cross.
%	KFM2(5) --> data set in a donut-shaped region.

%	Roger Jang, 1994

if nargin == 0, dataID = 1; end

side = 10;
pattern_n = 5*side*side;    % pattern_n is the number of input patterns
iteration_n = 1000;
  
% Generate input data distribution
x = rand(pattern_n, 1) + sqrt(-1)*rand(pattern_n, 1);
  
if (dataID == 1),		% Rectangle
	ix = 1:pattern_n;
elseif (dataID == 2),		% Triangle
	ix = find((imag(x)<=2*real(x))&(imag(x)<=2-2*real(x))) ;
elseif (dataID == 3),		% Circle
	ix = find(abs(x-.5*(1+j))<= 0.5) ;
elseif (dataID == 4),		% Cross
	ix = find((imag(x)<(2/3)&imag(x)>(1/3))| ...
		(real(x)<(2/3)&real(x)>(1/3))) ;
elseif (dataID == 5),		% Donut
	ix = find((abs(x-.5*(1+j))>=0.3) & (abs(x-.5*(1+j))<= 0.5));
end
x = x(ix); pattern_n = length(x);

init_eta = 0.8;			% Initial value of eta 
final_eta = 0.1;		% Final value of eta
init_sigma = side/2;		% Initial value of sigma
final_sigma = 1;		% Final value of sigma
  
% Initial values of the weights are uniformly distributed in a square
% of size 0.1 by 0.1 centered at (0.5, 0.5):
w = (rand(side) + j*rand(side))/10 + 0.45*(1+j) ;
%w = rand(side) + j*rand(side);
  
% ====== Input data distribution
snapshotH = genfig('Snap shots of Kohonen feature map');
clf;
subplot(2,4,1); plot(x, '.'); axis square; axis([0 1 0 1]);
title('Data distribution');
title('(a)');
subplot(2,4,2); plot([w w.']); axis square; axis([0 1 0 1]);
title('Initial weights');
title('(b)');

% Initial animation objects
animationH=genfig('Animation for Kohonen feature map');
lineH = plot(nan*real([w w.']), nan*imag([w, w.']), 'erase', 'back');
axis square; axis([0 1 0 1]);
set(gca, 'xtick', [], 'ytick', []);
titleH = text(0.5, 1.05, '');
set(titleH, 'erase', 'xor', 'horizontal', 'center');
xlabelH = text(0.5, -0.05, '');
set(xlabelH, 'erase', 'xor', 'horizontal', 'center');
if matlabv==4,
	inputH = line(nan, nan, 'erase', 'back', 'linestyle', '.', ...
		'markersize', 25, 'color', 'c');
elseif matlabv==5,
	inputH = line(nan, nan, 'erase', 'back', 'marker', '.', ...
		'markersize', 25, 'color', 'c');
else
	error('Unknown MATLAB version');
end
titleH = get(gca, 'title');
xlabelH = get(gca, 'xlabel');
% Seems the following two line make texts not updated
% set(titleH, 'erasemode', 'background');
% set(xlabelH, 'erasemode', 'background');

[xx, yy] = meshgrid(1:side, 1:side);
% ====== main loop
for k = 1:iteration_n
	eta=init_eta+(k-1)*(final_eta-init_eta)/(iteration_n-1);
	sigma=init_sigma+(k-1)*(final_sigma-init_sigma)/(iteration_n-1);

	input = x(rem(k, pattern_n)+1);
	xw = input - w;

	% (IM,JM) is the coordinates of the winning unit.
	dist = abs(xw);
	min_dist = min(min(dist));
	[IM, JM] = find(dist==min_dist);

	% The neighbourhood fcn NB is centered around (IM, JM)
	TMP = xx-IM + (yy-JM)*sqrt(-1);
	NB = exp(-TMP.*conj(TMP)/sigma);
	NB = NB.';

	% update weights of the winning unit and its neighbourhood
	w = w + eta*NB.*xw; 

	% update animation objects
	tmp = [w, w.'];
	for i = 1:size(lineH),
		set(lineH(i), 'xdata', real(tmp(:, i)), ...
			'ydata', imag(tmp(:, i)));
	end
	set(inputH, 'xdata', real(input), 'ydata', imag(input));
	title_str = ['eta = ',num2str(eta),'  sigma = ',num2str(sigma)];
	count_str = ['count = ',int2str(k),'/',int2str(iteration_n)];
	set(titleH, 'string', title_str);
	set(xlabelH, 'string', count_str);
	drawnow;

	% ====== snapshots
	if k == 30,
		figure(snapshotH);
		subplot(2,4,3); plot([w w.']);
		axis square; axis([0 1 0 1]);
		title(['Wts. after ' int2str(k) ' updates']);
		title('(c)');
		drawnow;
		figure(animationH);
	elseif k == iteration_n,
		figure(snapshotH);
		subplot(2,4,4); plot([w w.']);
		axis square; axis([0 1 0 1]);
		title(['Wts. after ' int2str(k) ' updates']);
		title('(d)');
		drawnow;
	end
end
