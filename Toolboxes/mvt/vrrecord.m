function [avi_out] = vrrecord(avi_in, fps, seq, vr_fig, vr_world, data)
% VRRECORD Records animations for the Marine Visualization Toolbox.
%    AVIOUT = VRRECORD(AVIIN, SEQUENCE, VRFIG, VRWORLD, DATA) interpolates 
%    the desired range of samples and time step (specified in SEQUENCE) of data 
%    values given in DATA. This new set of data is sent to corresponding nodes 
%    in VRWORLD and VRFIG. Each frame is added to the AVI movie object AVIIN.
%    AVIOUT is returned when all frames are added to movie.
%
%    Note: Due to the functionality of vrfigure/capture, the VR-figure must 
%    not be closed, minimized or completely covered by another window while 
%    the recording is in progress! This will cause the animation to freeze
%    at the last valid frame.
%
% See also VRFIGURE, VRWORLD, VRNODE, DIRECTOR, CREATEVRML.
%
% Author:   Andreas Lund Danielsen
% Date:     10th November 2003
% Revisions: 


% interpolate simdata, to achieve desired animation speed.
% time_step = 1/framesPerSecond implies that one second of 
% simulation equals one second of animation. multiply by
% this sequence's playback speed:
    % time step
    time_step = seq.speed * 1/fps;
    % smallest fine meshed time array
    min_t = inf;
    
    % retrieve desired set of data, [seq.start seq.stop]
    % for all vessels
    for cv = 1:length(data)
        
        % simulation data, raw
        raw.t = data(cv).t(seq.start:seq.stop);
        raw.x = data(cv).x(seq.start:seq.stop,:);
        
        % add 2*pi to avoid interpolation of steps
        tmp_raw.x = raw.x;
        for sample = 1:size(raw.x,1)-1
            if ( sign(raw.x(sample,6)) ~= sign(raw.x(sample+1,6)) ) & (abs(raw.x(sample,6)) > 2)
                tmp_raw.x(sample+1:end,6) = sign(raw.x(sample,6))*2*pi + tmp_raw.x(sample+1:end,6);
            end
        end
        raw.x = tmp_raw.x;
        
        % interpolated data, fine
        fine(cv).t = [data(cv).t(seq.start) : time_step : data(cv).t(seq.stop)];
        
        % interpolate all states
        for state = 1:6
            tmp = raw.x(:, state);
            fine(cv).x(:, state) = pchip(raw.t, tmp, fine(cv).t);
        end % state
        
        % find the smallest interpolated states
        min_t = min(min_t, length(fine(cv).t));
        
    end % cv
    
% create handles to vr nodes
% and chop off end of long interpolations
for cv = 1:length(data)
    % handles
    node_name = ['vessel_' num2str(cv)];
    node_view = ['view_'   num2str(cv)];
    node_path = ['path_'   num2str(cv) '_ext'];
    vessel(cv).h   = vrnode(vr_world, node_name);
    view(cv).h     = vrnode(vr_world, node_view);
    path(cv).h     = vrnode(vr_world, node_path);
    
end

% open waitbar
wb_h = waitbar(0, ['Adding frame 0/' num2str(min_t) '...']);

% record animation!
for t = 1:min_t
    % for all vessels
    for cv = 1:length(data)

        % set translation
        vessel(cv).h.translation = fine(cv).x(t, 1:3);
        view(cv).h.translation = fine(cv).x(t, 1:3);
        % set rotation
        [beta, epsilon] = euler2p(fine(cv).x(t, 4:6));
        vessel(cv).h.rotation = [beta epsilon];
       
        % is path constant?
        % or redraw path...
        if strcmp(seq.vessel(cv).path_start, 't')
            % path_start is char
            en = eval(seq.vessel(cv).path_end);
            len = length(data(1).x);
            sta = seq.start + round(t/length(fine(1).t) * length(raw.t)) - 1;
            path(cv).h.scale = seq.vessel(cv).path_radius * [zeros(sta,2); ...
                                                             ones(en-sta,2); ...
                                                             zeros(len-en,2)];
        elseif strcmp(seq.vessel(cv).path_end, 't')
            % path_end is char
            sta = eval(seq.vessel(cv).path_start);
            len = length(data(1).x);
            en = seq.start + round(t/length(fine(1).t) * length(raw.t)) - 1;
            path(cv).h.scale = seq.vessel(cv).path_radius * [zeros(sta,2); ...
                                                             ones(en-sta,2); ...
                                                             zeros(len-en,2)];
        else
            % do nothing, path is constant
        end            

    end % for : cv
    
    % refresh figure
    vrdrawnow;
    
    % display waitbar
    try
        % display wait bar and continue
        msg = ['Adding frame ' num2str(t) '/' num2str(min_t) '...'];
        waitbar(t/min_t, wb_h, msg);
    catch
        % user closed waitbar, return from funtcion
        return;
    end
    
    % add current frame to movie
        % capture image
        cap_image = capture(vr_fig);
        
        % convert to image
        cap_frame = im2frame(cap_image);
        
        % add to movie
        avi_in = addframe(avi_in, cap_frame);
    % --- finished adding frame

end

% close waitbar
close(wb_h);

% set return value
avi_out = avi_in;