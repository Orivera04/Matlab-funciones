function S= summary(mdev)
%SUMMARY

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 08:11:01 $

if ~isa(mdev.Statistics,'pointer') & ~isempty(mdev.Statistics)
   S= str2mat(sprintf('%2d',mdev.Statistics(1)),...
      sprintf('%2d',mdev.Statistics(2)),...
      sprintf('%3.2g',mdev.Statistics(3)),...
      sprintf('%3.4g',mdev.Statistics(4)),...
      sprintf('%3.4g',mdev.Statistics(5)));
   S= num2cell(str2num(S));
else
   S= {'NaN','NaN','NaN' 'NaN'};
end