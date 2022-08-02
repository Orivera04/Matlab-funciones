function [value]=ispos(x)
%ISPOS True for positive numbers.
%   ISPOS returns 1 for positive numbers.

%   Details are to be found in Mastering Mechanics I, Douglas W. Hull,
%   Prentice Hall, 1998

%   Douglas W. Hull, 1998
%   Copyright (c) 1998-99 by Prentice Hall
%   Version 1.00

value=1==sign(x);
