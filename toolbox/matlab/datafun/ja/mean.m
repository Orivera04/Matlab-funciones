% MEAN   配列の平均値
% 
% Xがベクトルの場合、MEAN(X)はXの要素の平均値を出力します。Xが行列の場合、
% MEAN(X)は各列の平均値を含む行ベクトルを出力します。XがN次元配列の場合、
% MEAN(X)は、Xの最初に1でない次元について平均値を出力します。
%
% MEAN(X,DIM)は、Xの次元DIMについて、要素の平均値を出力します。
%
% 例題:
% 
%   X = [0 1 2
%        3 4 5]
%
% の場合、mean(X,1)は[1.5 2.5 3.5]で、mean(X,2)は[1
%                                                 4]です。
%
% 参考：MEDIAN, STD, MIN, MAX, COV.


%   Copyright 1984-2002 The MathWorks, Inc. 
%   $Revision: 1.9.4.1 $  $Date: 2004/04/28 01:46:55 $
