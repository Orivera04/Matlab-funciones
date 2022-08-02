function [Column]=makecol(data,formatno);

if nargin<2
  formatno=4;
end

[NoRows, NoCols]=size(data);

Column=num2str(data(1),formatno);
for gapli=2:NoRows
  Column=strvcat(Column,num2str(data(gapli),formatno));
end

% Used with titleblock, from the shape routines.
%
% Details are to be found in Mastering Mechanics I, Douglas W. Hull,
% Prentice Hall, 1998
%
% Douglas W. Hull, 1998
% Copyright (c) 1998-99 by Prentice Hall
% Version 1.00
%
