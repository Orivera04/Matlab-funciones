function [labels, callbacks] = list2cb(list)
% LIST2CB This is used in ch02.m ch03.m, etc.
%	Given list is something like this;
%
%list = [...
%    '#Figure 4.5: mam1', ...
%    '#Figure 4.6: mam2', ...
%    '#Figure 4.7: ruleview mam21', ...
%    '#Figure 4.9: sug1', ...
%    '#Figure 4.10: sug2', ...
%    '#Figure 4.12: tsu1'];

labels = [];
callbacks = [];
while ~isempty(list),
	% Generate labels
	[item, list] = strtok(list, '#');
	labels = str2mat(labels, item);

	% Generate callbacks
	[fig_title, remain] = strtok(item, ':');
	m_file = strtok(remain, ':'); 
	command = strtok(m_file, '.');
	callback = ['genfig(''', fig_title, '''); ', command, ';'];
	callbacks = str2mat(callbacks, callback);
end
labels(1,:) = [];
callbacks(1,:) = [];
