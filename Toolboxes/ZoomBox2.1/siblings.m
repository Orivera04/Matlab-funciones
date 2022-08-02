function hSiblings = siblings(hChild, type);
%SIBLINGS - returns handles of children of parent of input.
%
%   SIBLINGS(hChild) gives all the children of the parent of hChild
%   SIBLINGS(hChild, TYPE) gives all the siblings of hChild that are
%      of type TYPE, where TYPE is a string.
%
%   Example:
%
%   close all
%   clc
% 
%   fig1  = figure(1)
%   hold on
%   line1 = plot([0 1],[0 1],'r')
%   line2 = plot([1 2],[0 1],'b')
%   line3 = plot([2 3],[0 1],'g')
%   hText1 = text(0.5,0.5,'First');
%   hText2 = text(1.5,0.5,'Second');
% 
%   fig2  = figure(2)
%   line4 = plot([0 1],[0 1], 'y')
% 
%   % There are lots of siblings to the line
%   siblings(line1)
%   % The line's line siblings are fewer 
%   siblings(line1,'line')
%   % The three lines all have the same set of siblings
%   siblings(line2,'line')
%   % The line in the other figure is an only child
%   siblings(line4, 'line')
%   % The two figures are brothers
%   siblings(fig1)
%   % This is useful for mass updates
%   set(siblings(line1),'color','m')

%   Version 1.1 Removal of typos
%               better example 
%               supress print on one line
%   Modifications by Dr Denis Gilbert <GilbertD@dfo-mpo.gc.ca> five minutes
%   after first post to MATLAB Central.  Thanks Denis!
%
%
%    Doug Hull <hull@mathworks.com>     12/31/2002
%    Copyright 1984-2002 The MathWorks, Inc.
%    This function is not supported by The MathWorks, Inc.
%    It is provided 'as is' without any guarantee of
%    accuracy or functionality.

if nargin < 2
    type = [];
end

hParent = get(hChild, 'Parent');
hSiblings = get(hParent, 'Children');

if ~isempty(type)
    matchType = strcmp(get(hSiblings,'type'), type);
    hSiblings = hSiblings(matchType);
end