% EWCOV   指数重み付けを用いて、収益時系列から資産共分散を出力
%
% [VarMat, PDFlag] = ewcov(TimeSeriesMatrix, DecayFactor, ... 
% LookBackHorizon) は、LookBackHorizon で指定された時間に対して、資産
% 収益時系列から共分散行列を計算します。
%
% 入力: 
%           TimeSeriesMatrix : 増加収益の観測値で構成されるNumObs行 
%                              NumAssets列の行列、TimeSeriesMatrix の最
%                              初の行は、各変数の最も古い観測値で構成さ
%                              れており、それ以降の行は、より最近の観測
%                              値を古いものから新しいものへという順番で
%                              含まれています。
%           DecayFactor      : スカラ値, 0 < DecayFactor <= 1。観測値は
%                              減衰ファクタ k により重み付けがなされます。
%                              ここで、k は最も新しい観測値からの時間
%                              ステップの数を指しています。デフォルトでは
%                              DecayFactor =1 で、これは、均等加重線形
%                              移動平均モデル(BIS)を示しています。減衰
%                              ファクタが小さくなればなるほど、最近の
%                              データが、より強調されるようになります。
%           LookBackHorizon  : スカラの整数。共分散の計算に用いられる
%                              時間ステップの数です。デフォルトでは、
%                              NumObsステップの時系列全体となっています。
%
%   出力: 
%           VarMat           : 推定された NumAssets 行 NumAssets 列の
%                              共分散行列資産収益プロセスの標準偏差は、
%                              つぎの通りです。
%                                STDVec = sqrt(diag(VarMat))
%                              相関行列は、つぎの通りです。
%                                CorrMat = VarMat./( STDVec*STDVec' )
%
%            PDFlag          : VarMat が正値の場合、0となり、VarMat が
%                              正定値でない場合、1が出力されます。入力
%                              データのいくつかについては、推定された
%                              共分散行列は縮重します。そのような場合、
%                              VarMat は出力しますが、PDFlag は1に設定
%                              されます。
%
%  参考 : COV.


%   Author(s): J. Akao 03/17/1998
%   Copyright 1995-2002 The MathWorks, Inc.  
