% display checking data

load output4.dat
output = output4;

min_x = min(output(:,1));
max_x = max(output(:,1));
min_y = min(output(:,2));
max_y = max(output(:,2));

positive_index = find(output(:,3) >= output(:,4));
negative_index = find(output(:,3) <  output(:,4));
positive = output(positive_index,:);
negative = output(negative_index,:);

axis([min_x max_x min_y max_y]);
axis([-3 3 -3 3]);
axis('square');
clf;
plot(positive(:,1), positive(:,2), '+');
hold on
%plot(negative(:,1), negative(:,2), 'o');
title('NFC''s decision region');
xlabel('x(t)');
ylabel('x(t-1)');

% the following plot noise-free (x(t), x(t-1)) pairs.
% (cut and paste from optimal_result.m.)

order = 2;
lag = 0;
case_n = 2^(order+1);

s = zeros(case_n, order+1);

for i=1:case_n,
	tmp = dec2othe(i-1, 2);
	if length(tmp)==0
		tmp = 0;
	end
	s(i,order+2-length(tmp):order+1) = tmp;
end

s = 2*s - 1; % Elements in s is either 1 or -1.

% Channel characteristics
x1 = channel(s(:,1), s(:, 2));
x2 = channel(s(:,2), s(:, 3));

% lag
index1 = find(s(:,1+lag) > 0);
index2 = find(s(:,1+lag) < 0);

plot(x1(index1), x2(index1), '*');
plot(x1(index2), x2(index2), 'o');
hold off
