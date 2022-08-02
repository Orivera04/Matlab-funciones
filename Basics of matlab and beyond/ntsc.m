function ntsc

% NTSC Convert color to black and white using NTSC encoding

% Andrew Knight (See 'Using Matlab Graphics Version 5, p. 3-17)
% 14 May 1997

colormap(sum(diag([.3 .59 .11])*colormap')' * [1 1 1]);
