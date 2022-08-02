% CORR2COV   標準偏差と相関を共分散に変換
%
% N 個のランダムプロセスのボラティリティとプロセス間の相関度合をN行N列の
% 共分散行列に変換します。
%
% ExpCovariance = corr2cov(ExpSigma, ExpCorrC)
%
% 入力：
%   ExpSigma : 各プロセスの標準偏差を含む長さ N のベクトル
%
%   ExpCorrC : N行N列の相関係数行列。ExpCorrC が未指定の場合、プロセス
%              には、相関がないと仮定され、単位行列が使用されます。
%
% 出力：
%   ExpCovariance  : N行N列の共分散行列。(i,j) への入力要素は、平均からの
%                    i番目の偏差 x 平均からのj番目の偏差の期待値です。
% 
%         ExpCov(i,j)= ExpCorrC(i,j)*( ExpSigma(i)*ExpSigma(j))
% 
% 参考 : EWSTATS, COV, CORRCOEF, STD, COV2CORR.


%   Author: J. Akao 11/17/97
%   Copyright 1995-2002 The MathWorks, Inc.  
