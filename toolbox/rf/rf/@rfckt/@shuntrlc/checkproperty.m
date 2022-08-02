function checkproperty(h)
%CHECKPROPERTY Check the properties of the object.
%   CHECKPROPERTY(H) checks the properties of the object.

%   Copyright 2003-2004 The MathWorks, Inc.
%   $Revision: 1.1.6.4 $  $Date: 2004/04/12 23:37:52 $

% Get the properties
r = get(h, 'R');
l = get(h, 'L');
c = get(h, 'C');

% Check the properties
if (r <= 0)
    error('rf:rfckt:shuntrlc:checkproperty:InvalidR', ['Resistive element in '...
        'the circuit must be a positive scalar.']);
end

if (l <= 0)
    error('rf:rfckt:shuntrlc:checkproperty:InvalidL',['Inductive element in '...
        'the circuit must be a positive scalar.']);
end 

if (c < 0 | c==Inf)
    error('rf:rfckt:shuntrlc:checkproperty:InvalidC',['Capactive element in '...
        'the circuit must be a finite non-negative scalar.']);
end