% COV2CORR   共分散を標準偏差及び相関係数に変換
%
% N個のランダムプロセスのボラティリティと各プロセス間の相関度合を計算
% します。
%
%      [ExpSigma, ExpCorrC] = cov2corr(ExpCovariance)
%
% 入力:
%   ExpCovariance: N行N列の共分散行列(COV、または、EWSTATS から算出)
%
% 出力:
%   ExpSigma     : 各プロセスの標準偏差を含む1行N列のベクトル
%
%   ExpCorrC     : 相関係数のN行N列の行列。ExpCorrC の入力は1(完全に
%                  相関)から-1(完全に逆相関)までの範囲となります。
%                  (i,j) の入力要素が0の場合、i番目とj番目のプロセスは
%                  相関関係にないことになります。
% 
%        ExpSigma(i)= sqrt( ExpCovariance(i,i));
%        ExpCorrC(i,j)= ExpCovariance(i,j)/( ExpSigma(i)*ExpSigma(j));
% 
% 参考 : EWSTATS, COV, CORRCOEF, STD, CORR2COV.


%    Author J. Akao 11/17/97
%    Copyright 1995-2002 The MathWorks, Inc.  
