function varargout = mvtguide(varargin)
% MVTGUIDE Runs the Marine Visualization Toolbox step-by-step.
%    MVTGUIDE(DATA) Runs the Marine Visualization Toolbox by calling MVT 
%    functions in the following order:
%        1: verifydata     - verifies the input DATA
%        2: typedef        - displays a graphical user interface where the
%                            vessels identified in DATA are linked to 3D
%                            vessel models and a scene model
%        3: createvrml     - assembles the linked 3D files to a single file
%        4: director       - displays a graphical user interface where
%                            animations are created and viewed/saved
%
%    DATA: Structure of 6 DOF data arrays and type vectors, see VERIFYDATA
%    for required fields and dimensions.
%
%    Users comfortable with MVT and MATLAB are encouraged to make custom
%    m-file functions that automatically convert their data to the correct 
%    format and run the files listed above.
%
% See also VERIFYDATA, TYPEDEF, CREATEVRML, DIRECTOR,
%
% Author:    Andreas Lund Danielsen
% Date:      20th November 2003
% Revisions:


% display instructions in matlab workspace
clc;
disp('% Display help on the MVTGUIDE:');
disp('help mvtguide');
help mvtguide
disp('% Starting mvtguide...');
disp('%');

% step 1: verify input 6 DOF data-----------------------------------------------
% input must be a struct of the correct format, see MVT\VERIFYDATA.
try
    % is first input argument a structure?
    data = struct(varargin{1});
    % input argument is of class struct
    disp('data = struct(varargin{1});');
    disp('% The input argument to MVTGUIDE is verified.');
    disp('%');
catch
    error('Input argument error in MVTGUIDE, first argument not a structure (see STRUCT and VERIFYDATA).');
end

% run VERIFYDATA, which returns true or false (verified/not verified)
disp('% Calling the function VERIFYDATA...');
disp('success = verifydata(data);');
success = verifydata(data);
% if not successful, display error message and terminate program
if ~success
    error('DATA verification error in MVTGUIDE.');
else
    % success!
    disp('% VERIFYDATA completed.');
    disp('%');
end


% step 2: link 6 DOF data to 3D models------------------------------------------
% link the vessels in data to the vessel models
%   TYPEDEF returns linked_data (same as data, but with one appended 
%   field: 'type' where links are stored as char arrays, for instance:
%   data(1).name = 'auv';
disp('% Calling the graphical user interface TYPEDEF...');
disp('[linked_data, vrml_scene] = typedef(data);');
[linked_data, vrml_scene] = typedef(data);

% is cancel is pressed in the TYPEDEF gui, return values linked_data and
% vrml_scene are empty.
if isempty(linked_data) & isempty(vrml_scene)
    % return values are empty, 
    % display error message nad terminate program
    error('DATA linking aborted by user.');
else
    % success!
    disp('% TYPEDEF completed.');
    disp('%');
end


% step 3: assemble and build final vrml file-----------------------------------
% call createvrml with data and filename arguments,
% which returns true or false
disp('% Calling the function CREATEVRML...');
disp('[success, vrml_world] = createvrml(linked_data, vrml_scene);');
[success, vrml_world] = createvrml(linked_data, vrml_scene);

% was execution of createvrml successful?
if ~success
    % error occured while running createvrml
    error('Error while running CREATEVRML from MVTGUIDE.');
else
    disp('% CREATEVRML completed.');
    disp('%');
end


% step 4: create animations ---------------------------------------------------
% run the graphical user interface DIRECTOR to create animations,
% animations consists of one or more sequences. sequences are created 
% in the sequence editor
disp('% Calling the graphical user interface DIRECTOR...');
disp('director(linked_data, vrml_world);');
director(linked_data, vrml_world);
disp('% MVTGUIDE completed.');
disp(' ');