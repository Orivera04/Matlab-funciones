function [todayday, todaymo, todayyr] = separatedate
% separatedate separates the current date into day,
% month, and year
% Format: separatedate or separatedate()

[todayday rest] = strtok(date,'-');
[todaymo todayyr] = strtok(rest,'-');
todayyr = todayyr(2:end);
end