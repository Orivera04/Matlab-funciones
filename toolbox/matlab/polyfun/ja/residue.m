% RESIDUE   部分分数展開(residues)
% 
% [R,P,K] = RESIDUE(B,A) は、2つの多項式の比 B(s)/A(s) を部分分数展開
% して、留数、極、直接項を求めます。重根がない場合は、つぎのようになり
% ます。
% 
%    B(s)       R(1)       R(2)             R(n)
%    ----  =  -------- + -------- + ... + -------- + K(s)
%    A(s)     s - P(1)   s - P(2)         s - P(n)
% 
% ベクトル B と A は、s の降べき順に多項式の分子と分母の係数を指定します。
% 留数は列ベクトル R に出力され、極の位置は列ベクトル Pに、直接項は
% 行ベクトル K に出力されます。極の個数は、
% n = length(A)-1 = length(R) = length(P)
% です。直接項の係数ベクトルは、length(B) < length(A) ならば空で、そうで
% なければ length(K) = length(B)-length(A)+1 になります。
%
% P(j) = ... = P(j+m-1) が多重度 m の極であれば、展開はつぎの型の項を
% 含むことになります。
%
%               R(j)        R(j+1)                R(j+m-1)
%            -------- + ------------   + ... + ------------
%            s - P(j)   (s - P(j))^2           (s - P(j))^m
%
% 3つの入力引数と、2つの出力引数をもつ [B,A] = RESIDUE(R,P,K) は、B と 
% A の係数を使って部分分数展開を多項式に変換します。
%
% ワーニング : 数値的に、多項式の比からの部分分数展開は、条件数の悪い
% 問題になります。分母多項式 A(s) が重根をもつ多項式に近い場合は、丸め
% 誤差を含むデータの小さな変化により、極や留数の結果は大きく変化します。
% 状態空間または零点-極表現を使った問題の定式化の方が好ましいといえます。
%
% 入力 B,A,R のサポートクラス
%   float: double, single
%
% 参考 POLY, ROOTS, DECONV.

%   Reference:  A.V. Oppenheim and R.W. Schafer, Digital
%   Signal Processing, Prentice-Hall, 1975, p. 56-58.

%   Copyright 1984-2004 The MathWorks, Inc.