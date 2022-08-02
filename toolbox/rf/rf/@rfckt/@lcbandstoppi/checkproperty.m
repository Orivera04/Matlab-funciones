function checkproperty(h)
%CHECKPROPERTY Check the properties of the object.
%   CHECKPROPERTY(H) checks the properties of the object.

%   Copyright 2003-2004 The MathWorks, Inc.
%   $Revision: 1.1.6.4 $  $Date: 2004/04/12 23:36:46 $

% Get the properties
l = get(h, 'L');
c = get(h, 'C');

% Check the number of inductive and capacitive elements
diffcomp = [];
diffcomp = numel(l) - numel(c);
if (diffcomp~=0)
    error('rf:rfckt:lcbandstoppi:checkproperty:InvalidLC', ['To create an LC Bandstop '...
        'Pi network, the number of inductive elements should \nbe equal to '...
        'the number of capacitive elements.']);
end

% Check if number of L,C is atleast 3
if (numel(l) < 3) 
    error('rf:rfckt:lcbandstoppi:checkproperty:MinimumL',['A minimum of three inductive '...
        'elements is required to create \nan LC Bandstop Pi network.']);
end

% Call createntwk method to build LC bandstop pi network
createntwk(h);