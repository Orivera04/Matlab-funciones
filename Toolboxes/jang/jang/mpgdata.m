% input_index is defined after running mpgpick2.m

% ====== get training and checking data
input_n = length(input_index);
t_data = data(1:2:size(data,1), [input_index size(data,2)]);
c_data = data(2:2:size(data,1), [input_index size(data,2)]);

% plot of training data
blackbg;
plot(t_data(:,1), t_data(:, 2), 'yo', c_data(:,1), c_data(:, 2), 'rx');
axis([-inf inf -inf inf]);
xlabel(deblank(input_name(input_index(1), :)));
ylabel(deblank(input_name(input_index(2), :)));
title('Trainind (o) and Test (x) Data');
