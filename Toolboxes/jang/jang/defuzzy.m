function out = defuzzy(x, mf, option)
%DEFUZZY Defuzzification of MF.
%	DEFUZZY(x, mf, option) returns a representative value of mf
%	using different defuzzification strategies:
%		option = 1 ---> center of area
%		option = 2 ---> bisecter of area
%		option = 3 ---> mean of max

%	Copyright by Jyh-Shing Roger Jang, 6-2-93.
%	(Tested on Matlab version 3.5e, DEC 5000)

x = x(:);
mf = mf(:);
data_n = length(x);

if option == 1,
	out = sum(mf.*x)/sum(mf);
elseif option == 2,
	total_area = sum(mf);
	tmp = 0;
	for k=1:data_n,
		tmp = tmp + mf(k);
		if tmp > total_area/2,
			break;
		end
	end
	out = (x(k) + x(k-1))/2;
elseif option == 3,
	index = find(mf == max(mf));
	out = mean(x(index));
else
	error('Unknown defuzzification option!');
end
