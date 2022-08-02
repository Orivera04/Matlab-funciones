function checkproperty(h)
%CHECKPROPERTY Check the properties of the object.
%   CHECKPROPERTY(H) checks the properties of the object.

%   Copyright 2003-2004 The MathWorks, Inc.
%   $Revision: 1.1.6.4 $  $Date: 2004/04/12 23:36:54 $

% Get the properties
l = get(h, 'L');
c = get(h, 'C');

% Check the number of inductive and capacitive elements
diffcomp = [];
diffcomp = numel(l) - numel(c);
if (diffcomp~=0) && (diffcomp~=1)
    error('rf:rfckt:lchighpasspi:checkproperty:InvalidLC', ['To create an LC Highpass '...
        'Pi network, the number of inductive elements should \nbe equal to '...
        'or one more than the number of capacitive element(s).']);
end

% Check if number of L is atleast 2
if (numel(l) < 2)
   error('rf:rfckt:lchighpasspi:checkproperty:MinimumL',['A minimum of two inductive '...
        'elements is required to create \nan LC Highpass Pi network.']);
end

% Call createntwk method to build LC highpass pi network
createntwk(h);