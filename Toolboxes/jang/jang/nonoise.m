% plot for noise-free situation
% Roger Jang, Aug-10-1995

% ============ plot 1: minimum phase
order1 = 2;			% order of the equalizer
order2 = 3;			% order of the channel
delay = 0;			% delay of the equalizer
case_n = 2^(order1+order2-1);	% number of possible input combination

% The first column of s is s(t), the second is s(t-1), etc
s = zeros(case_n, order1+order2-1);
for i=1:case_n,
	s(i, :) = dec2othe(i-1, 2, size(s, 2));
end
s = 2*s - 1; % Elements in s is either 1 or -1.

% Channel characteristics
x1 = s(:,1)+0.8*s(:,2)+0.5*s(:,3);
x2 = s(:,2)+0.8*s(:,3)+0.5*s(:,4);

index1 = find(s(:,1+delay) > 0);
index2 = find(s(:,1+delay) < 0);

x_min = -3; x_max = 3;
y_min = -3; y_max = 3;

blackbg;
subplot(2,2,1);
plot(x1(index1), x2(index1), 'o', x1(index2), x2(index2), 'x');
line([-2.2 2.2], [-3 3], 'color', 'c', 'linestyle', ':');
xlabel('x(t)'); ylabel('x(t-1)');
title('(a) Minimum Phase Channel');
axis([x_min x_max y_min y_max]);
axis square;

% ============ plot 2: nonminimum phase
order1 = 2;			% order of the equalizer
order2 = 2;			% order of the channel
delay = 0;			% delay of the equalizer
case_n = 2^(order1+order2-1);	% number of possible input combination

% The first column of s is s(t), the second is s(t-1), etc
s = zeros(case_n, order1+order2-1);
for i=1:case_n,
	s(i, :) = dec2othe(i-1, 2, size(s, 2));
end
s = 2*s - 1; % Elements in s is either 1 or -1.

% Channel characteristics
x1 = 0.5*s(:,1)+s(:,2);
x2 = 0.5*s(:,2)+s(:,3);

index1 = find(s(:,1+delay) > 0);
index2 = find(s(:,1+delay) < 0);

x_min = -3; x_max = 3;
y_min = -3; y_max = 3;

subplot(2,2,2);
plot(x1(index1), x2(index1), 'o', x1(index2), x2(index2), 'x');
xlabel('x(t)'); ylabel('x(t-1)');
title('(b) Nonminimum Phase Channel');
axis([x_min x_max y_min y_max]);
axis square;

% prepare for snapshot
%prepshot;
