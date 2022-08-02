% EWSTATS   収益時系列から期待収益及び共分散を出力
%
% オプションの指数重み付けは、より最近のデータを強調します。
% 
%   [ExpReturn, ExpCovariance, NumEffObs] = ewstats(RetSeries, ...
%                                           DecayFactor, WindowLength)
%  
% 入力:
%    RetSeries      : 均等に間隔をもつ増加収益の観測値で構成される 
%                     NUMOBS行NASSETS列の行列です。この行列の最初の行は
%                     最も古い観測値となっており、最後の行が最新の観測値
%                     となっています。
%    DecayFactor    : それぞれの観測値について、それより後の観測値より
%                     どれだけ重み付けを軽くするかをコントロールする引数
%                     です。時間的にさかのぼって k 番目の観測値には、減衰
%                     ファクタ k の重み付けがなされます。減衰ファクタは
%                     つぎの値域の範囲内でなければなりません。: 
%                     0 < DecayFactor <=1、デフォルトは、DecayFactor = 1
%                     で、これは均等加重線形移動平均モデル(BIS)と等価
%                     です。
%    WindowLength   : 計算に使用される最近の観測値の数。デフォルトでは、
%                     全ての NUMOBS 観測値が対象となります。
%
% 出力:
%    ExpReturn      : 推定期待収益を示す1行NASSETS列の行列
%    ExpCovariance  : NASSETS行NASSETS列の推定共分散行列
%    NumEffObs      : つぎの公式によって与えられる有効観測値の数。
% 
%       NumEffObs = (1-DecayFactor^WindowLength)/(1-DecayFactor)
% 
%   DecayFactors、または、WindowLengths の値が小さくなるほど、より最近
%   のデータが強く強調されるようになりますが、利用可能なデータセットの
%   数はより少なくなるでしょう。 
%
% 資産収益プロセスの標準偏差は、つぎの式によって与えられます。
% 
%     STDVec = sqrt(diag(ECov))
%
% なお、相関行列は、つぎのとおりです。
% 
%     CorrMat = VarMat./( STDVec*STDVec' )
%
% 参考 : MEAN, COV, COV2CORR.


%   Author(s): J. Akao 3/16/98
%   Copyright 1995-2002 The MathWorks, Inc. 
