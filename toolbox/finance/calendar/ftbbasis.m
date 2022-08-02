function ftbbasis()
%
%BASIS refers to the basis or day-count convention for a bond. Basis is
%normally written as a fraction where the numerator prescribes the
%method for determining the number of days between two dates, and the
%denominator prescribes the number of days in the year. For example, the
%numerator of "ACTUAL/ACTUAL" means that when determining the number of days
%between two dates, one must count the actual number of days. The denominator
%means that the actual number of days in the given year should be used in any
%calculations (i.e. either 365 or 366 days depending on whether the given
%year is a leap year). Possible values include:
%     1) Basis = 0 - actual/actual (default for most functions)
%     2) Basis = 1 - 30/360
%     3) Basis = 2 - actual/360
%     4) Basis = 3 - actual/365


disp(' ');
disp('Type "help ftbbasis" for an explanation of BASIS');
disp(' ');

%Author(s): C. Bassignani, 03-11-98
%   Copyright 1995-2002 The MathWorks, Inc. 
%$Revision: 1.6 $   $Date: 2002/04/14 21:50:39 $

