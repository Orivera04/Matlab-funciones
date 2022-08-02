% MKTREETIMES   債権オプションの価格決定ツリーに対するノードの時間
%
% TFactors によって定義された(長さ1の)各定期的なクーポン期間以内の 
% Accuracy 期間を配置します。奇数の長さである期間内の期間表示を丸めます。
%
% [InterpTimes, CFIndex, InterpDates] = ...
%    createtreetimes(TFactors, Accuracy, CFlowDates) 
%
% InterpTimes は、クーポン期間内のツリーに対する時間の設定です (TFactors 
% と同じです)。
% InterpDates は、ツリーノードに対する(丸められた)日付の設定です。
%
% CFIndex は、オリジナルの TFactors の TreeTimes 内のインデックスの設定
% です。
% CFIndex は、TFactors と同じ長さです。
%
% ユーザによってコールされることを意図していないプライベート関数です。


%Author: C. Bassignani, 04-18-98
%        J. Akao        05-10-98
%   Copyright 1995-2002 The MathWorks, Inc. 
