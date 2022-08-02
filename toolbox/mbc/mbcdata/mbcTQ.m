function out = mbcTQ(a, s, n, l)
%MBCTQ Function that loads a model and evaluates it
%
%  MBCTQ(AFR, SPK, N, L) loads a demo MBC engine model and evaluates it at
%  the given (AFR, SPK, N, L) point

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.6.3 $    $Date: 2004/04/04 03:26:21 $

TwoStage = [];
load(fullfile(mbcpath, 'mbctraining', 'mbcTQmodel.mat'));

if length(n) == 1
   n = repmat(n, size(a, 1), 1);
end
if length(l) == 1
   l = repmat(l, size(a, 1), 1);
end
out = EvalModel(TwoStage, [s,n,l,a]);
