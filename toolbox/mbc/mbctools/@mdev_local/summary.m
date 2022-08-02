function S= summary(mdev)
%SUMMARY

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 08:05:11 $

s= statistics(mdev);

if  ~isempty(s)
   S= num2str(s','%3.4g');
   S= num2cell(str2num(S));
else
   S= {'NaN','NaN','NaN' 'NaN','NaN' 'NaN'};
end