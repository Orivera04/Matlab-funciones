
% This program facilitates manual spike detection, taking advantage of
% the integration abilities of the human visual system. The program 
% displays a spectrogram of a spike train and records the user-captured 
% time-stamps (referenced to the beginning of the file), and the associated 
% intervals. The outputs can be saved as text files with names adapted from
% the original data file names, and in the original directory. 
% 
% Events other than spikes may be analyzed. However, the program was 
% designed for and is probably best suited for spike trains.
%
% Notes:
% 
% 1- The program is written to read .wav files as inputs. You will need to 
% modify that part of the code to read other formats.
% 
% 2- Optimal spectrogram parameters may vary with type of signal. See the specgram 
% command help.
% 
% 3- When zooming in onto a time segment, be sure to include as much of the 
% vertical frequency extent as is useful.
% 
% 4- The order of capturing spikes is not important. 
%
% 5- The minimum spike time uncertainty is equal to +/- the pixel width, in
% seconds. The minimum interval uncertainty is +/- 2x pixel width.


% Hazem Baqaen (Hazem@brown.edu), Simmons lab., Brown University.
% MATLAB 6.5.


% Clear all variables
clear

% Close all figures
close all hidden;

% Select and read .wav data file to get waveform (Change this for other formats)
[filename, path] = uigetfile('*.wav');
[data,Fs,bits] = wavread([path filename]);

% Get spectrogram (optimal parameters may vary with signal)
specgram(data,[],Fs,blackmanharris(fix(min(512,length(data))/2)),(fix(min(1024,length(data))/2))*3/8);
title(['Spectrogram for  ' filename])
xlabel('Time (s)')
ylabel('Frequency (Hz)')
scales = axis;          % Capture figure scales (useful for making vertical line labels later)
vertmax = scales(4);

disp('Take this opportunity to zoom in onto the spectrogram if necessary. Press SpaceBar to continue')
pause

% Select spikes using cross-hairs
disp('Use the vertical cursor to mark the onsets of the spikes and record their times')
spikecount = 0;
r = 0;
Times = [];
one_ISI = [];
while 1
    if r ~= 1
        [t,f] = ginput(1);      % Capture spike timestamp
        hold on
        h = stem(t,vertmax,'.');% Label with vertical line on figure to mark position
    end
    r = 0;

    % Create choice menu
    k = menu(['Spike Count = ' num2str(spikecount+1)],'Redo Previous','Next','End');
    
    if k == 1               % Redo previous spike selection
        delete(findobj(h)); % Delete last marker line
        continue
    elseif k == 2           % Move on to the next spike, save and display previous
        spikecount = spikecount + 1;
        Times(spikecount) = t;
        disp(['Last spike time = ' num2str(t) ' seconds'])
    else                    % Record last spike time and quit
        Endchoice = menu('End capture mode. Are you sure?','Yes, and keep last spike','Yes, but forget last','No, continue capture');
        if Endchoice == 1     % Confirm end capture
            spikecount = spikecount + 1;
            Times(spikecount) = t;
            disp(['Last spike time = ' num2str(t) ' seconds'])
            break
        elseif Endchoice == 2
            r = 1;            % Skip capture
            delete(findobj(h)); % Delete last marker line
            break
        else                % Go back to previous menu
            r = 1;
        end
    end
end

Times = sort(Times');
one_ISI = diff(sort(Times)); % First-order inter-spike intervals, in seconds

% Save results as ASCII text files in the same directory as the data file
savechoice = input('Save spike time stamps and intervals as 8-digit ASCII files? (y/n, default is no)\n','s');
savechoicetest = strcmpi('y', lower(savechoice));        
if savechoicetest == 1   
    [token,rem] = strtok(filename,'.');
    filename = strrep([path filename],rem,lower(rem));
    save(strrep(filename,'.wav','_Times.txt'), 'Times', '-ascii', '-tabs')
    save(strrep(filename,'.wav','_ISI.txt'), 'one_ISI', '-ascii', '-tabs')
end









