function em = emdata(data)
% EMDATA Error measure of a data set.  This is used in CART routine.

%	Roger Jang, 7-31-1995

% Error measure is MSE.
% Assuming the last column is the output.
%em = sum((data(:,size(data,2))-mean(data(:,size(data,2)))).^2)/...
%	size(data,1);
em = sum((data(:,size(data,2))-mean(data(:,size(data,2)))).^2);
