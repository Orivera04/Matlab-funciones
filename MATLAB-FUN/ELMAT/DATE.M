function y = date()
%DATE	Calendar.
%	S = DATE returns a string containing the date in dd-mmm-yy format.

%	Copyright (c) 1984-94 by The MathWorks, Inc.

t = clock;
base = t(1) - rem(t(1),100);
months = ['Jan';'Feb';'Mar';'Apr';'May';'Jun';
          'Jul';'Aug';'Sep';'Oct';'Nov';'Dec'];
y = [int2str(t(3)),'-',months(t(2),:),'-',int2str(t(1)-base)];
