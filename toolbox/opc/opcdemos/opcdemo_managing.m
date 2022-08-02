%% OPCDEMO_MANAGING
% This example shows you how to manage OPC Toolbox objects.

% Copyright 2004 The MathWorks, Inc.

%% Finding OPC Toolbox objects in memory
% You use the OPCFIND finction to find OPC Toolbox objects in memory.
opcfind

%% 
% Create some OPC Toolbox objects
da = opcda('localhost', 'Dummy.Server.1');
grp = addgroup(da);
itm1 = additem(grp, 'Fake.Item.ID1');
itm2 = additem(grp, 'Fake.Item.ID2');

%%
% Find all valid objects
allOPC = opcfind

%%
% The information is returned in a cell array, because OPCFIND can locate
% different objects. To access an object, use cell indexing.
newGrp = allOPC{2}

%%
% To find objects with a specific property, pass property/value pairs to
% the OPCFIND function.
allDA = opcfind('Type', 'opcda')

%% Removing objects from memory
% To delete an OPC Toolbox object from memory, use the DELETE function with
% the object. Deleting a client object deletes all group and item objects
% associated with the client. Deleting a group deletes all items in that
% group.
delete(grp)

%%
% Find all remaining valid objects.
allOPC = opcfind

%%
% Using the DELETE function with the object will remove the object from the
% OPC Toolbox engine but not from the MATLAB workspace. To remove an object
% from the MATLAB workspace use the CLEAR function. To see what objects are
% in the MATLAB workspace, use the WHOS function.

%%
% Display the current workspace.
whos

%%
% Since an object was deleted, it is no longer valid.
grp

%% 
% The items contained by that group are also invalid
itm1

%%
% Clear the associated variables.
clear grp itm1 itm2

%%
% Display the current workspace.
whos

%% 
% To remove all OPC Toolbox objects from the engine and to reset the
% toolbox to its initial state, use the OPCRESET function.
%
% *Note*: Using the OPCRESET function will only delete objects from
% memory, not clear them from the MATLAB workspace.
opcreset

%%
% Verify no objects remain.
allOPC = opcfind

%%
% Variables associated with deleted objects still remain.
whos

%%
% Clear any remaining variables associated with deleted objects.
clear da newGrp allOPC allDA

