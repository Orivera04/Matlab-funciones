function checkproperty(h)
%CHECKPROPERTY Check the properties of the object.
%   CHECKPROPERTY(H) checks the properties of the object.

%   Copyright 2003-2004 The MathWorks, Inc.
%   $Revision: 1.1.6.4 $  $Date: 2004/04/12 23:37:02 $

% Get the properties
l = get(h, 'L');
c = get(h, 'C');

% Check the number of inductive and capacitive elements
diffcomp = [];
diffcomp = numel(c) - numel(l);
if (diffcomp~=0) && (diffcomp~=1)
    error('rf:rfckt:lclowpasspi:checkproperty:InvalidLC', ['To create an LC Lowpass '...
        'Pi network, the number of capacitive elements should \nbe equal to '...
        'or one more than the number of inductive element(s).']);
end

% Check if number of C is atleast 2
if (numel(c) < 2)
    error('rf:rfckt:lclowpasspi:checkproperty:MinimumC',['A minimum of two capacitive '...
          'elements is required to create \nan LC Lowpass Pi network.']);
end

% Call createntwk method to build LC lowpass pi network
createntwk(h);