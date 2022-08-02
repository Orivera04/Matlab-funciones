function h = gpf()
%GPF    Get handle of the figure that is next to the top of the stack.
%	H = GPF returns the next-to-the-top figure (penultimate
%	figure) in the root's figure stack.
%
%	If there is only one figure open, GPF will return its
%	handle. If there are currently no figures open, GPF will 
%	will open a figure and return its handle.

%	Copyright (c) 1984-94 by the MathWorks, Inc.

hList = get(0,'Children');

if length(hList) > 1,
    h = hList(2);
else
    h=gcf;
end
