% 目的
% FIS へのルールの付加
%
% 表示
% a = addrule(a,ruleList)
%
% 詳細
% addrule は、2つの引数をもっています。最初の引数は、FIS 名です。addrule
% の2番目の引数は、1つまたは複数行の行列で、その各々は与えられたルールを
% 表します。ルールリスト行列のフォーマットは、非常に特殊なものです。m 個
% の入力と n 個の出力をもつシステムを考える場合、厳密に m + n + 2 列のル
% ールリストがあります。
% 
% 最初の m 列は、システムの入力に関連したものです。各々の列は、この変数
% に対するメンバシップ関数のインデックスに関連した数値を含んでいます。
% 
% つぎの n 列は、システムの出力に関連したものです。各々の列は、その変数
% に対するメンバシップ関数のインデックスに関連した数値を含んでいます。
% 
% (m+n+1) 列は、ルールに適用される重みを含んでいます。重みは0と1の間の数
% 値で、一般に1にしています。
% 
% (m+n+2) 列は、ルールの前件部になるステートメントに対するファジィ演算が
% AND の場合1、OR の場合2と設定します。
%
% 例題
%    ruleList = [
%         1 1 1 1 1
%         1 2 2 1 1];
%    a = addrule(a,ruleList);
% 
% 上のシステムが2入力1出力をもつ場合、最初のルールを"入力1が MF1 で、入
% 力2が MF1 の場合、出力1が MF1 である"と解釈することができます。
%
% 参考    addmf, addvar, parsrule, rmmf, rmvar, showrule



%   Copyright 1994-2002 The MathWorks, Inc. 
