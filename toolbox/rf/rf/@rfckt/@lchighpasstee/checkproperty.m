function checkproperty(h)
%CHECKPROPERTY Check the properties of the object.
%   CHECKPROPERTY(H) checks the properties of the object.

%   Copyright 2003-2004 The MathWorks, Inc.
%   $Revision: 1.1.6.4 $  $Date: 2004/04/12 23:36:58 $

% Get the properties
l = get(h, 'L');
c = get(h, 'C');

% Check the number of inductive and capacitive elements
diffcomp = [];
diffcomp = numel(c) - numel(l);
if (diffcomp~=0) && (diffcomp~=1)
    error('rf:rfckt:lchighpasstee:checkproperty:InvalidLC', ['To create an LC Highpass '...
        'Tee network, the number of capacitive elements \nshould be equal to '...
        'or one more than the number of inductive element(s).']);
end

% Check if number of C is atleast 2
if (numel(c) < 2)
    error('rf:rfckt:lchighpasstee:checkproperty:MinimumC',['A minimum of two capacitive '...
        'elements is required to create \nan LC Highpass Tee network.']);
end

% Call createntwk method to build LC highpass tee network
createntwk(h);