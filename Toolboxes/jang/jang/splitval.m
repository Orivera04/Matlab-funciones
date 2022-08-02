function out = splitval(trn_data, col)
% Find possible split values of a column of a data set. Used in CART.

%	Roger Jang, 7-31-1995

uniq_value = uniq(sort(trn_data(:, col)));
out = uniq_value(1:length(uniq_value)-1) + 0.5*diff(uniq_value);
