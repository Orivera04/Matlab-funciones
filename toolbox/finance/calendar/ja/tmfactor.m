% TMFACTOR   任意の日付の時間係数
%
%    TFactors = tmfactor(Settle, Maturity)
%
% 詳細: この関数は、決済日のベクトルから満期日のベクトルまでの時間係数を
%       出力します。
%
% 入力: Settle (必須)
%       Maturity (必須)
%
% すべての必要な引数は、N行1列、または、1行N列のベクトル、または、スカラ
% 引数です。すべてのオプション引数は、N行1列、または、1行N列のベクトル、
% スカラ、空行列のいずれかです。
%
% それぞれの入力引数及び出力引数の詳細については、コマンドライン上で
% 'help ftb' + 引数名(たとえば、Settle(決済日)に関するヘルプは、
% "help ftbSettle" とタイプして得られます。 
%
% 出力: TFactors
%
% 参考 : CFAMOUNTS, CFTIMES.


%Author(s): Charlie Bassignani, 10-17-97, 02-13-98 
%   Copyright 1995-2002 The MathWorks, Inc. 
