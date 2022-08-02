function out = f_de(position, p1, p2, inv_cov);
%F_DE	Decision function of channel equalization problem.
%	out = f_de(position, p1, p2, inv_cov) return the optimal
%	decision function used in channel equalization problems.
%	Each row vector of position, p1, and p2 is a (x,y) coordinate;
%	inv_cov is the inverse of a covariance matrix.

%	Roger Jang, Aug-11-95

p1_leng  = size(p1, 1);
p2_leng  = size(p2, 1);
pos_leng = size(position, 1);
out = zeros(pos_leng, 1);

%h = waitbar(0,'Please wait...');
for i = 1:pos_leng,
	current_pos = position(i, :);

%	tmp = ones(p1_leng,1)*current_pos - p1;
%	sum1 = sum(-0.5*sum(((tmp*inv_cov).*tmp)'));

%	tmp = ones(p2_leng,1)*current_pos - p2;
%	sum2 = sum(exp(-0.5*sum(((tmp*inv_cov).*tmp)')));

	tmp1 = ones(p1_leng,1)*current_pos - p1;
	tmp2 = -tmp1*inv_cov;
	tmp3 = sum((tmp2.*tmp1)');
	sum1 = sum(exp(tmp3));

	tmp1 = ones(p2_leng,1)*current_pos - p2;
	tmp2 = -tmp1*inv_cov;
	tmp3 = sum((tmp2.*tmp1)');
	sum2 = sum(exp(tmp3));

	out(i,1)= sum1 - sum2;
	%waitbar(i/pos_leng)
end
%close(h)
