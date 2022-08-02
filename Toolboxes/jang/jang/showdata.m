% display training data

load data.trn

data_n = length(data);
min_x = min(data(:,1));
max_x = max(data(:,1));
min_y = min(data(:,2));
max_y = max(data(:,2));

positive_index = find(data(:,3) > 0);
negative_index = 1:data_n;
negative_index(positive_index) = [];
positive = data(positive_index,:);
negative = data(negative_index,:);

plot(positive(:,1), positive(:,2), 'x', negative(:,1), negative(:,2), 'o');
title('training data distribution');
xlabel('x(t)'); ylabel('x(t-1)');

hold off;
axis([-3 3 -3 3]);
axis([min_x max_x min_y max_y]);
axis('square');
