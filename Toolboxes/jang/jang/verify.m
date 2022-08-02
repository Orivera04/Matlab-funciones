t = (0:300)';
u = 2*rand(size(t))-1;
desired_y = 0.6*sin(2*pi*t/250)+0.2*sin(2*pi*t/50);
%desired_y = 0.8*cos(2*pi*3*t/100);
y = ones(length(t), 1);
y(1) = 0.0;	% this is not important

for i = 1:length(t)-1;
	% Assuming we DO know desired_y(i+1);
	u(i) = evalfis([y(i) desired_y(i+1)], trn_out_fismat);
	y(i+1) = plant(y(i), u(i));
end

%subplot(221); plot(t, u, '-', t, u, 'go');
subplot(221); plot(t, u);
xlabel('Time'); ylabel('u(k)');
axis([-inf inf -inf inf]);

subplot(221); plot(t, desired_y, '--', t, y, '-');
xlabel('Time'); ylabel('actual and desired y(k)');
axis([-inf inf -inf inf]);
limit = axis;
legend('desired', 'actual');

%subplot(222); plot(t, desired_y-y, '-', t, desired_y-y, 'go');
subplot(222); plot(t, desired_y-y);
xlabel('Time'); ylabel('error');
axis(limit);

%surfview(trn_out_fismat);
