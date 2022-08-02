function flag = setRestartData(this, info)
% SETOBJECTDATA Set cell array of Matlab types corresponding to data for
% Simulink parameters and I/O ports.
%
% The input INFO has four parts:  INFO(1): value
%                                 INFO(2): row number
%                                 INFO(3): column number
%                                 INFO(4): data type, e.g., 'parameters'
%
% The output FLAG = 0 for failure, 1 for success in assigning the value.

% Author(s): Bora Eryilmaz
% Revised:
% Copyright 1986-2004 The MathWorks, Inc.
% $Revision: 1.1.6.4 $ $Date: 2004/04/11 00:38:56 $

columns = {'Name', 'BestValue', 'Estimated', 'InitialValue', ...
           'Minimum', 'Maximum', 'Scaling'};
restartscolumns = {'Name', 'Random', 'Points'};

value = info(1);
row   = info(2);
col   = info(3);
type  = char( info(4) );

hData  = this.Parameters(row);
hParam = find(this.getRoot, '-class', 'spenodes.Variables');
h      = find(hParam.Parameters, 'Name', hData.Name);

switch type
case 'parameters'
  % Parameter table
  property = columns{col};
  flag = hData.update(property, value);
case 'init'
  % initialize from best value
  flag = hData.update('InitialValue', hData.BestValue);
case 'reset'
  % Reset row from global
  this.Parameters(row) = copy(h);
  flag = true;
case 'save'
  % Save row to global
  idx = find(hParam.Parameters == h);
  hParam.Parameters(idx) = copy(hData);
  flag = true;
case 'restarts'
  % Restarts table
  property = restartscolumns{col};
  flag = true;
end

% Set the dirty flag
this.setDirty
