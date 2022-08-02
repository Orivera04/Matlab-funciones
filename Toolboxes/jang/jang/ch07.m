function chap07
% List of plots in chapter 7 of "Neuro-Fuzzy and Soft Computing".

%labels = str2mat(...
%    'Figure 2.1: mf_univ', ...
%    'Figure 2.2: lingmf', ...
%    'Figure 2.19: resolut');
%
%% Callbacks
%callbacks = str2mat(...
%    'genfig(''Figure 2.1''); mf_univ', ...
%    'genfig(''Figure 2.2''); lingmf', ...
%    'genfig(''Figure 2.19''); resolut');
%
%choices('Chapter 1', 'Plots for Chapter 1', labels, callbacks);

list = [...
    '#Figure 7.4: peaks', ...
    '#Figure 7.5 & 7.6: go_ga', ...
    '#Figure 7.8: tsp', ...
    '#Figure 7.10: go_rand', ...
    '#Figure 7.14: go_simp'];

[labels, callbacks] = list2cb(list);
choices('Chapter 7', 'Plots for Chapter 7', labels, callbacks, 1);