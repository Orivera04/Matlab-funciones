function ret = issimpletable(T)
%ISSIMPLETABLE Check if table is simply connected
%
%  OUT = ISSIMPLETABLE(T) returns true if the table is simply connected to
%  2 normalisers which are in turn connected directly to 2 input values.
%  False is returned if there are any more complex expressions connected
%  downstream.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.6.1 $    $Date: 2004/02/09 07:11:52 $ 

Nx = get(T, 'x');
Ny = get(T, 'y');
xval = Nx.get('x');
yval = Ny.get('x');

if xval.isddvariable && yval.isddvariable
    ret = true;
else
    ret = false;
end