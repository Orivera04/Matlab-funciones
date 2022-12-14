function varargout = createvrml(data, world, target_file)
% CREATEVRML Creates a VRML file for use with the Marine Visualization Toolbox.
%   FLAG = CREATEVRML(DATA, WORLD, TARGETFILE) creates a VRML file TARGETFILE 
%   based on the infomation in DATA (see VERIFYDATA for help on DATA). The VR-
%   world is created from the VRML file WORLD, which must be located 
%   in the Marine Visualization Toolbox subfolder 'world'. 
%
%   [FLAG, TARGETFILE] = CREATEVRML(DATA, WORLD) same as above function
%   call, but TARGETFILE is specified by user when when executing
%   CREATEVRML and returned.
%
%   If the field 'type' is not specified in DATA, 'type' is set equal to
%   the first entry in type list.
%
% See also TYPEDEF, VERIFYDATA, DIRECTOR.
%
% Author:    Andreas Lund Danielsen
% Date:       7th November 2003
% Revisions: 30th November 2003, Full pathname on file-save


% set default return value false
flag = false;

% define useful local variables
    % directory structure
    root = [fullfile(matlabroot, 'toolbox', 'mvt', '') filesep];
    % number of steps for waitbar
    n_steps = length(data) + 2;

% detect available VRML files in subfolder 'vessel\'
vessel_names = dirlist('vessel', 'wrl');

% display waitbar
wb_h = waitbar(1/n_steps, 'Creating VRML-world...');

% create handle to the new world and open for editing
    % construct world file name
    world_file = [root 'world' filesep world '.wrl'];

    % load environment file
    vr_world = vrworld(world_file);

    % open world for editing
    open(vr_world);
    
    % make sure updates are loaded
    reload(vr_world);
    
    % add info to world
    world_info = vrnode(vr_world, 'world_info', 'WorldInfo');
    vr_info = {'VRML-file generated by the Marine Visualization Toolbox' ...
              ['Created: ' date] ...
              ['Number of vessels in file: ' num2str(length(data))]};
    world_info.info = vr_info;
    world_info.title = 'Virtual World';

% loop through vessels, cv = current vessel
for cv = 1:length(data)
    
    % update waitbar
    wb_msg = ['Adding vessel ' num2str(cv) '...'];
    waitbar((1+cv)/n_steps, wb_h, wb_msg);
    
    % open vrml-file specified in field 'type'
    % is field 'type' specified?
    if isfield(data, 'type')
        %  get handle to file for current vessel
        cvr = vrworld([root 'vessel' filesep data(cv).type '.wrl']);
    else
        % vessel type not specified, use default: supply
        cvr = vrworld([root 'vessel' filesep 'supply.wrl']);
    end

    % open resource file and add a copy of properties to the new world
    open(cvr);
    reload(cvr);
    
    % create one node for the vessel and one for viewpoints
        % vessel
        vessel_trans_name = ['vessel_' num2str(cv)];
        vessel_trans = vrnode(vr_world, vessel_trans_name, 'Transform');
            % add a default switch to vessel transform
            vessel_switch_name = ['vessel_' num2str(cv) '_switch'];
            vessel_sw = vrnode(vessel_trans, 'children', vessel_switch_name, 'Switch');
            % set default value = 0 (implies first element)
            vessel_sw.whichChoice = 0;
            
        % view
        view_trans_name = ['view_' num2str(cv)];
        view_trans = vrnode(vr_world, view_trans_name, 'Transform');
    
    % find all nodes in file
    node_list = nodes(cvr);
    
    % search list for transforms
    for n = 1:length(node_list)
        
        % create handle to this node
        this_node = node_list(n);
        
        % read field 'type'
        node_type = get(this_node, 'Type');
        
        % what kind of node is is?
        switch node_type
            
            % transform
            case 'Transform'
                if strcmp(get(this_node, 'Name'), 'vessel')
                    % this node is the vessel transform, do nothing
                    % --- empty ---
                elseif strcmp(get(this_node, 'Name'), 'view')
                    % this node is the viewpoint transform
                    % copy properties
                    view_trans.translation = this_node.translation;
                    view_trans.rotation = this_node.rotation;
                end
                
            % inline: add inline reference to vessel switch
            case 'Inline'
                % add node
                vessel_inline = vrnode(vessel_sw, 'choice', [get(this_node, 'Name') '-' num2str(cv)], 'Inline');
                % copy properties
                % use full file name for url!
                full_url = fullfile(matlabroot, 'toolbox', 'mvt', 'vessel', char(this_node.url));
                vessel_inline.url = full_url;
            
            % add viewpoint to view transform
            case 'Viewpoint'
                % add ndoe
                viewp = vrnode(view_trans, 'children', ['vessel_' num2str(cv) '_' get(this_node, 'Name')], 'Viewpoint');
                % copy properties
                viewp.position = this_node.position;
                viewp.orientation = this_node.orientation;
                viewp.description = this_node.description;
                
            case 'Switch'
                % do nothing, already accounted for
                
            % node is ignored
            otherwise
                % display message
                warning('VISUAL:NodeNotRecognized', 'Ignoring source node, not recognized:');
                disp(node_type);
                
        end % switch: node
        
    end % for: node_list

    % close cvr
    close(cvr);
    
    % add paths for current vessel
    % an extrusion object is created with following properties
    %       - circular crosssection, radius = 1
    %       - spine points equal to the vessel's time variant xyz-positions
    
    % create path transform
    path_trans = vrnode(vr_world, ['path_' num2str(cv)], 'Transform');
    path_trans.translation = [0 0 -.1];
        
        % create path switch
        path_sw = vrnode(path_trans, 'children', ['path_' num2str(cv) '_switch'], 'Switch');
        % set default value
        path_sw.whichChoice = 0;
            
            % create path shape
            path_shape = vrnode(path_sw, 'choice', ['path_' num2str(cv) '_shape'], 'Shape');
                
                % create appearance
                path_appearance = vrnode(path_shape, 'appearance', ['path_' num2str(cv) '_app'], 'Appearance');
                
                % create path extrusion
                path_ext = vrnode(path_shape, 'geometry', ['path_' num2str(cv) '_ext'], 'Extrusion');
                
                    % create path material
                    path_material = vrnode(path_appearance, 'material', ['path_' num2str(cv) '_mat'], 'Material');
                    path_material.diffuseColor = [.25 .25 .25] + .5 * rand(1,3);
                    path_material.transparency = 0;
                
    % lay extrusion along path
        % set scale/radius of path
        scale = 1;
        % spine coord = vessel xyz
        path_ext.spine = data(cv).x(:,1:3);
        % scale = 1
        path_ext.scale = scale * ones(length(path_ext.spine), 2);
        % set orientation = straight
        path_ext.orientation = [zeros(length(path_ext.spine),2) ...
                                 ones(length(path_ext.spine),1) ...
                                zeros(length(path_ext.spine),1)];
        % set circular cross section
        path_ext.crossSection = [1    0;  .7  -.7;   0  -1; ...
                                -.7 -.7;  -1    0; -.7  .7; ...
                                 0    1;  .7   .7;   1   0];

end % vessel loop

% close waitbar handle
close(wb_h);

% request a filename from user to save VR-world
% save if file naem is specified
if ~exist('target_file')
    [filename, pathname, filterindex] = uiputfile( ...
           {'*.wrl','VRML-files (*.wrl)'; ...
            '*.*',  'All Files (*.*)'}, ...
            'Save generated VRML file as', ...
            [cd filesep 'untitled.wrl']);
    if filterindex
        % save file and continue...
        % retrieve fileparts
        [pathname, filename, extension, version] = fileparts(fullfile(pathname, filename));
        % ensure correct extension
        extension = '.wrl';
        % reconstruct filename
        filename = [filename extension];
        save(vr_world, fullfile(pathname, filename));
    else
        % user pressed cancel
        filename = '';
        disp('File-save aborted by user.');
        return;
    end
else
    % save new world to specified file
    save(vr_world, target_file);
end

% set return values depending on number of outputs
if nargout ~= 2
    % return success!
    flag = true;
    varargout = flag;
else
    % return success and entered TARGETFILE
    flag = true;
    target_file = fullfile(pathname, filename);
    varargout = {flag target_file};
end

% close vr-world
close(vr_world);