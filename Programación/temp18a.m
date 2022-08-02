temps4 = temps;    % copy data
temps4(5,1) = nan; % insert some NaNs
temps4(29,2) = nan;
temps4(13:14,3) = nan;

lnan=isnan(temps4); % logical array identifying NaNs
temps4(lnan)=0;     % change all NaNs to zero
n=sum(~lnan);       % number of nonNaN elements per column

m2=sum(temps4)./n    % find mean for all columns

m = zeros(1,3); % preallocate memory for results

temps4 = temps;    % copy data
temps4(5,1) = nan; % insert some NaNs
temps4(29,2) = nan;
temps4(13:14,3) = nan;

for j=1:3 % go column by column
   idx = ~isnan(temps4(:,j));
   m(j)=mean(temps4(idx,j));
end
m