% If the input labels are 'x' and 'y', some weird error occurs in
% surfview().

% Create a new FIS.
xorfis = newfis('xor', 'sugeno');

% Set up input 1 and it's MFs.
xorfis = addvar(xorfis, 'input', 'X', [0 1]);
xorfis = addmf(xorfis, 'input', 1, 'near 0', 'zmf', [0 1]);
xorfis = addmf(xorfis, 'input', 1, 'near 1', 'smf', [0 1]);

% Set up input 2 and it's MFs.
xorfis = addvar(xorfis, 'input', 'Y', [0 1]);
xorfis = addmf(xorfis, 'input', 2, 'near 0', 'zmf', [0 1]);
xorfis = addmf(xorfis, 'input', 2, 'near 1', 'smf', [0 1]);

% Set up output and it's MFs.
xorfis = addvar(xorfis, 'output', 'class', [0 1]);
xorfis = addmf(xorfis, 'output', 1, 'zero', 'linear', [0 0 0]);
xorfis = addmf(xorfis, 'output', 1, 'one', 'linear', [0 0 1]);
xorfis = addmf(xorfis, 'output', 1, 'one', 'linear', [0 0 1]);
xorfis = addmf(xorfis, 'output', 1, 'zero', 'linear', [0 0 0]);

% Set up rule list
rulelist = [1 1 1 1 1;
	1 2 2 1 1;
	2 1 3 1 1;
	2 2 4 1 1];
xorfis = addrule(xorfis, rulelist);

%figure; surfview(xorfis);

% Write the newly created FIS to a file
writefis(xorfis, 'xor');

% Display the i/o surface of the FIS
figure; gensurf(xorfis);
set(gca, 'box', 'on');
frot3d on
