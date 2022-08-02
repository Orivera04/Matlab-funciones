function className = getclassname(h)
%GETCLASSNAME Get the name of the class from object

%   Copyright 2002-2003 The MathWorks, Inc.
%   $Revision: 1.1.6.2 $
%   $Date: 2004/04/19 01:16:39 $

% get targetprefs.className
fullName = h.class;
dotIndex = findstr(fullName, '.');
% get className part
className = fullName((dotIndex+1):end);