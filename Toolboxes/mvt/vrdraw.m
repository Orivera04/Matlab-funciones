function vrdraw(vr_world, seq, data, t)
% VRDRAW Updates the current VR-figure.
%    VRDRAW(VRWORLD, SEQUENCE, DATA, T) updates the VR-figure associated 
%    with VRWORLD. Vessel states are retrieved from sample T in DATA. 
%    Object properties are retrieved from the settings in SEQUENCE.
%
%    Called by DIRECTOR in the Marine Visualization Toolbox.
%
% See also DIRECTOR, CREATEVRML.
%
% Author:   Andreas Lund Danielsen
% Date:     10th November 2003
% Revisions: 


% get length of data
len = length(data(1).t);

% for all vessels:
for cv = 1:length(data)
    
    % find node in vr-world
    node_name = ['vessel_' num2str(cv)];
    node_view = ['view_'   num2str(cv)];
    
    % create vrnode handles
    vessel = vrnode(vr_world, node_name);
    view   = vrnode(vr_world, node_view);
    
    % set translation
    vessel.translation = data(cv).x(t, 1:3);
    view.translation   = data(cv).x(t, 1:3);
    % set rotation
    [beta, epsilon] = euler2p(data(cv).x(t, 4:6));
    vessel.rotation = [beta epsilon];
    
    % set sequence properties
        % create node handles
        vessel_sw = vrnode(vr_world, ['vessel_' num2str(cv) '_switch']);
        path_sw   = vrnode(vr_world, ['path_'   num2str(cv) '_switch']);
        path_mat  = vrnode(vr_world, ['path_'   num2str(cv) '_mat']);
        path_ext  = vrnode(vr_world, ['path_'   num2str(cv) '_ext']);
        
        % switch vessel on/off
        vessel_sw.whichChoice = seq.vessel(cv).switch;
        
        % switch path on/off
        if seq.vessel(cv).path_switch == 0
            % switch path on
            path_sw.whichChoice = 0;
            
            % set path properties
                % set scale
                sta = eval(seq.vessel(cv).path_start);
                en  = eval(seq.vessel(cv).path_end);
                path_ext.scale = seq.vessel(cv).path_radius * [zeros(sta,2); ...
                                                               ones(en-sta,2); ...
                                                               zeros(len-en,2)];
                
                % set diffuse color
                path_mat.diffuseColor = seq.vessel(cv).path_color;
        else
            % switch path off
            path_sw.whichChoice = -1;
        end
    
end

% make sure figure is refreshed
vrdrawnow;