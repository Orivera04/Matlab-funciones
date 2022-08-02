%VECROT Animation program which shows a rotating vector            % -  1
%       defined as complex number (Section 4.10)                   % -  2

f      = 50;            % frequency, Hz                            % -  3
omega  = 2*pi*f;        % angular frequency, rad/s                 % -  4
tmax   = 1/f;           % time for a complete rotation, s          % -  5
time   = [ ];                                                      % -  6
motion = [ ];                                                      % -  7
for t = 0: tmax/36: tmax                                           % -  8
        z      = exp(i*omega*t);   % complex number description    % -  9
        x      = real(z);          % cartesian projection          % - 10
        y      = imag(z);          % cartesian projection          % - 11
        time   = [ time t ];                                       % - 12
        motion = [ motion y ];                                     % - 13
        plot([ 0, x ], [ 0, y ])                                   % - 14
        axis('square'), axis([ -1 1 -1 1 ])                        % - 15
        pause(1.0)                                                 % - 16
end                                                                % - 17
