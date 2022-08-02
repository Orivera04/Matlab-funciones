function h = figure(GUO);

% function h = figure(GUO);
% 
% Makes the parent figure of "GUO" the current figure and returns its handle.
%
% Copyright (c) SINUS Messtechnik GmbH 2002
% www.sinusmess.de - Sound & Vibration Instrumentation
%                  - PCB Services
%                  - Electronic Design & Production

h = figure(get(GUO, 'Parent'));
