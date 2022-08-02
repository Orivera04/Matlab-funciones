function beepbeep(tempo,varargin)
%BEEPBEEP Warning sound composed by intermittent beeps.
%   BEEPBEEP(TEMPO,OPTION1) emits a sequence of the OS beeps
%   in predefined time lapses. This function can be regarded
%   as an extention of MATLABs built-in BEEP function.
%   The argument TEMPO can assume three possible forms:
%
%       scalar (1x1): produces a N second sound with one
%                     beep per second.
%       vector (Nx1): the vector elements represent the time
%                     between interleaving beeps.
%       empty matrix: only when OPTION1 is selected.
%
%   The OPTION1 string specifies one of the following sounds:
%
%       'diner time', 'diner' -> tempo = [0.2 0.2 0.2 0.1]'
%
%       'hotel reception', 'hotel' -> tempo = [0.1 0.1 0.1]'
%
%       'anxious' -> tempo = 0.1*ones(1,10)'
%
%       'alarm clock' -> tempo = repmat([0.1 0.1 0.1 0.1 0.8],1,3)
%
%   Examples
%   -------------
%       Create a sound composed by seven beeps (1 beep per second).
%       >> BEEPBEEP(7)
%
%       Create a sound composed by three beeps with a frequency of
%       1 beep per 0.2 seconds.
%       >> BEEPBEEP([0.2 0.2 0.2]')
%
%       Create a annoying alarm clock sound:
%       >> BEEPBEEP([],'alarm clock')
%
%
% See also beep.

% Credits:
% Daniel Simoes Lopes
% ICIST
% Instituto Superior Tecnico - Universidade Tecnica de Lisboa
% danlopes @ civil ist utl pt
% http://www.civil.ist.utl.pt/~danlopes
%
% May 2007 original version.

% Initial state of the beep.
s = beep;

% Turn on the beep.
if strcmp(s,'off')
    beep on
end

% Type of beeping warning.
switch nargin
    case 0
        % Two beeps signal.
        for t = 1:2
            beep
            pause(0.5)
        end

    case 1
        if length(tempo) == 1
            % One beep per second.
            for t = 1:tempo
                beep
                pause(1)
            end
        elseif length(tempo) > 1
            % Customized beeping signal.
            for t = 1:length(tempo)
                beep
                pause(tempo(t))
            end
        end
    case 2
        if length(tempo) == 0
            % Default beeping signals.
            switch varargin{:}
                case {'diner time', 'diner'}
                    dtempo = [0.2 0.2 0.2 0.1]';
                case {'hotel reception', 'hotel'}
                    dtempo = [0.1 0.1 0.1]';
                case {'anxious'}
                    dtempo = 0.1*ones(1,10)';
                case {'alarm clock'}
                    dtempo = repmat([0.1 0.1 0.1 0.1 0.8],1,3);
            end
            for t = 1:length(dtempo)
                beep
                pause(dtempo(t))
            end
        end
end

% Maintain the initial beep status before leaving function.
if strcmp(s,'off')
    % Turn off the beep.
    beep off
end
