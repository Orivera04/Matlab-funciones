% Print out 26 alphabets

load alphabet.mat

blackbg;
k = 0;
for i = 1:4,
	for j = 1:7,
		k = k+1;
		subplot(4, 7, (i-1)*7+j);
		plotchar(alphabet(:, k));
		cmd = [setstr(64+k), '=reshape(alphabet(:,k), 5, 7)'';'];
		eval(cmd);
		axis square; axis equal;
		if k >= 26, break; end
	end
	if k >= 26, break; end
end
colormap(gray);
%set(gcf, 'invert', 'off');
%print -deps pchar
