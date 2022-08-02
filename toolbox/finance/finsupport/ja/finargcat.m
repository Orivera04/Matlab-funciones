% FINARGCAT   サイズの異なる配列にパディングを行って連結
%
% FINARGCAT(DIM,A,B) は、配列 A と B を次元 DIM に沿って連結します。配列 
% A と B のサイズが DIM 以外の次元で等しくない場合、A と B は各次元に
% おける最小共通サイズに NaN でパディングされます。入力引数が文字列の場合
% パディングには、NaN の代わりにスペースが用いられます。
%
% B = FINARGCAT(DIM,A1,A2,A3,A4,...)は、入力された配列 A1, A2,...を次元 
% DIM に沿って連結します。
% 
% FINARGCAT は、DIM 以外の次元で入力全てのサイズが等しい場合、CAT と等価
% です。
%
% 例題: 
% 例題の出力において、連結されたレイヤーには印が付けられています。
%     A1 =   ones(2,3)
%     A2 = 2*ones(1,4)
%     A3 = 3*ones(3,1)
%     finargcat(1,A1,A2,A3)
% は、つぎの (2+1+3)行 4 列の行列を生成します。
%     1     1     1   NaN
%     1     1     1   NaN
%     -------------------
%     2     2     2     2
%     -------------------
%     3   NaN   NaN   NaN
%     3   NaN   NaN   NaN
%     3   NaN   NaN   NaN
%  
% これに対して finargcat(2,A1,A2,A3)は、つぎの 3 行 (3+4+1)列の行列を
% 生成します。
%      1     1     1 |   2     2     2     2  |  3
%      1     1     1 | NaN   NaN   NaN   NaN  |  3
%    NaN   NaN   NaN | NaN   NaN   NaN   NaN  |  3
%   
% また、finargcat(3,A1,A2,A3)は、3 × 4 ×(1+1+1)行列を生成します。
%
% 参考 : CAT.


%   Author(s): J. Akao 12/18/98
%   Copyright 1995-2002 The MathWorks, Inc. 
