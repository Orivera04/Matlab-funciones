% PORTSIM   相関のある資産収益のランダムシミュレーション
%
% この関数は、NUMOBS 個の連続する観測(値)区間に対して、NASSETS 個の資産
% からもたらされる収益をシミュレーションします。この関数からの出力は、
% 一定の移動率(drift) とボラティリティ Brownian 過程の増分としてシミュ
% レートされます。
%
% RetSeries = .....
%    portsim(ExpReturn, ExpCovariance, NumObs, RetIntervals, NumSim)
%
% 入力:
%    ExpReturn     : 各資産の期待(平均)収益を示す1 行 NASSETS 列のベクト
%                    ルです。
%    ExpCovariance : 資産-資産共分散の NASSETS 行 NASSETS 列の行列です。
%                    収益の標準偏差は、つぎの通りです。
%                    ExpSigma = sqrt(diag(ExpCovariance))となります。
%    NumObs        : 収益時系列における連続する観測値の数。NumObs が空行
%                    列[]として入力されると、RetIntervals の長さが使用さ
%                    れます。
%    RetIntervals  : 観測値間の時間間隔を示すスカラ値、または、NUMOBS 行
%                    1列のベクトルです。RetIntervals の指定がない場合、
%                    全間隔が1の長さであると仮定されます。
%    NumSim        : NUMOBS 個の観測値毎に個別に実行されるシミュレーショ
%                    ンの回数です。デフォルトは1です。
%
% 出力：
%    RetSeries     : 増分収益観測値の NUMOBS x NASSETS x NUMSIM 配列です。
%                    長さ DT の区間に対する収益は、つぎの式で与えられま
%                    す。 ExpReturn *DT + ExpSigma*sqrt(DT)*randn 、ここ
%                    で、randn は、標準正規乱数の発生を意味しています。
%
% PortWts にリストアップされているポートフォリオから得られる収益は、つぎ
% の式によって与えられます。
% 
%     PortReturn = PortWts * RetSeries(:,:,1)',
% 
% ここで、PortWts は各行がポートフォリオの資産配分を含んでいる行列です。
% PortReturn の各行は、 PortWts に指定されるポートフォリオの1つに相当し
% ます。また各列は、RetSeries の観測値の1つに対応しています。ポートフォ
% リオの設定と最適化については、関数 PORTOPT と PORTSTATS を参照してくだ
% さい。
% 
% 参考 : PORTOPT, PORTSTATS, EWSTATS, RET2TICK, RANDN.


%    Author(s): J. Akao 03/24/98
%    Copyright 1995-2002 The MathWorks, Inc.  
