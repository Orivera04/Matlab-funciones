% EXCELPORTOPT   平均分散有効フロンティアを計算
%
% PortfOptResults = EXCELPORTOPT(AssetExpectedReturns, .....
%     AssetStandardDeviations, AssetCorrelationMatrix, .....
%     AssetUpperLowerBounds, AssetGroupConstraintMatrix, ....
%     FrontierReturns, PlotFlag)
% は、ある1組の資産の期待収益、標準偏差、相関行列が与えられたときに、
% 当該資産の平均分散有効フロンティアを計算します。その他のオプション
% 引数としては、資産に対する加重値の上限値、下限値及び資産の加重値の
% 線形結合の上限、下限が考えられます。
%
% EXCELPORTOPT は、ポートフォリオ最適化アプリケーションによって、コール
% されることを意図して設計された PORTOPT の一つのバージョンです。
%
% 入力: 
% AssetExpectedReturns は、各資産の期待収益を含むベクトルです。
%
% AssetStandardDeviations は、各資産の標準偏差を含むベクトルです。
%     
% AssetCorrelationMatrix は、各資産の履歴相関(historical correlation)行
% 列です。
%     
% AssetUpperLowerBounds は、各資産の加重値の上限及び下限値を含む行列です
% (N行2列の行列, ここで、N は、資産数を表しています)。
%
% AssetGroupConstraintMatrix は、資産に対する加重値の線形結合の上限、
% 下限を指定する値からなる行列です。
%
% FrontierReturns (オプション)は、フロンティア関数の評価に用いられる期待
% 収益のベクトルです。
%
% 注意： 
% 行列 AssetGroupConstraintMatrix の各行は、資産が制約の中にあるかどうか
% を示しています(資産が含まれているときは1，含まれていないときは0です)。
% AssetRows は、与えられた期待収益及び標準偏差と同一の次数で生じると仮定
% されます。資産数よりも少ない数の行しかない場合、最後の行を超える資産に
% 対しては値0が適用されます。
%
% 出力: 
% PortfolioOptimizationResults は、フロンティア上の点に対応する期待収益、
% 標準偏差、加重値からなる行列です。


%   Author(s) : D. Eiler, 09-30-96
%   Copyright 1995-2002 The MathWorks, Inc. 
