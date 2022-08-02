function [s,ro]=mmgetset(h)
%MMGETSET Get Settable Object Property Structure. (MM)
% MMGETSET(H) gets all the properties of the object having handle H
% in the form of a structure and removes those fields that are read only.
% The returned structure can be used to set properties of H.
% If H is an array of handles, a structure array is returned.
%
% [S,RO]=MMGETSET(H) in addition returns the read only property
% structure in RO.

% D.C. Hanselman, University of Maine, Orono, ME  04469
% 5/31/99
% Mastering MATLAB 6, Prentice Hall, ISBN 0-13-019468-9

if ~any(ishandle(h))
   error('Input Must Contain Valid Object Handles.')
end
sget=get(h);                % get property structure
fnget=fieldnames(sget);     % fieldnames of gettable property names

sset=set(h(1));             % settable property structure
fnset=fieldnames(sset);     % fieldnames of settable property names

sdiff=setdiff(fnget,fnset); % cell array of read only property names
s=rmfield(sget,sdiff);      % settable property names

if nargout==2 % return read only structure as well
   sdiff=setdiff(fnget,sdiff); % read only property names
   ro=rmfield(sget,sdiff);
end
