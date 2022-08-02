function out = channel(in0, in1, in2, in3)
% CHANNEL Channel characteristics of equalization problem.
%	out = channel(in0, in1, in2, in3),
%	where in1 = input(t), in2 = input(t-1), etc., out = output(t).
%	(in1, in2 and out are all column vectors.)

% Figure 7 of [2]
out = 0.5*in0 + in1;

% Figure 4 of [2]
%tmp = in0 + 0.5*in1;
%out = tmp - 0.9*tmp.^3;

% Figure 6 of [2]
%tmp = in0 + 0.5*in1;
%out = tmp - 0.5*tmp.^3;

% [1] "Multilayer perceptron structures applied to adaptive
%      equalisers for data communications", IEEE conference, (1989)
%     multilayer perceptrons", Signal Processing 22 (1991) 77-93
% [2] "Adaptive equalization of finite nonlinear channels using
%     multilayer perceptrons", Signal Processing 22 (1991) 77-93
% [3] "Reconstruction of binary signals using an adaptive
%     radial-basis-function equalizer", Signal Processing 20 (1990) 107-119
