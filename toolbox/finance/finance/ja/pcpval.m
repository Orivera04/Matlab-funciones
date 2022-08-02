% PCPVAL   固定されたポートフォリオの総価値に対する一次不等式を出力
%
% NumAssets 個の資産からなるポートフォリオの総価値を、PortValue に
% スケーリングします。ExpReturn と ExpCovariance (PORTOPTを参照)を除く
% ポートフォリオの加重値、範囲収益、危険値全てが PortValue の項でスケー
% リングされます。
%  
%       [A,b] = pcpval(PortValue, NumAssets)
%
% 入力:
%   PortValue : ポートフォリオの総価値(スカラ)。PortValue は、全資産に
%               おける配分量の総和です。PortValue =1と入力すると、その
%               値に関わらず、加重値はポートフォリオの端数(fraction)と
%               して、収益と危険数は、レートとして指定されます。
%   NumAssets : 利用可能な資産投資の数
%
% 出力:
% A*Pwts' <= b の関係にある行列 A 及びベクトル b を出力します。ここで、
% Pwts は、資産配分の1行NASSETS列のベクトルです。
%
% 別の使用法：
% 2つ以下の出力引数を伴う形でこの関数をコールした場合、A 及び b は互いに
% 連結されることになります。
% 
%        Cons = [A, b]; Cons = pcpval(PortValue, NumAssets)
% 
% 
% 参考 : PORTOPT, PCALIMS, PCGLIMS, PCGCOMP, PORTCONS.


%   Author(s): J. Akao, M. Reyes-Kattar, 03/11/98
%   Copyright 1995-2002 The MathWorks, Inc. 
