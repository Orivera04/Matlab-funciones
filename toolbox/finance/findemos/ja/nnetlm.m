% NNETLM   Financial Expo 用ニューラルネットワーク Levenberg-Marquardt 法
%          を使ったデモンストレーション
%
% PRED = NNETLM(INDAT,PTS,N,NEURONS) は、Financial Expo用ニューラルネット
% ワークで、Levenberg-Marquardt 法を使ったデモンストレーションを実行し
% ます。INDAT は、トレーニングとテスト用のデータです。PTS は、使用される
% データセットの総数を指定します。N は、つぎの出力を予測するのに使用する 
% PTS の中の点数、NEURONS は、ニューラルネットワークで使用する中間層の
% ニューロンの数です。
%
% たとえば、データセット300点(PTS = 300)から、10点
% (N = 10)が、つぎの点の予測のために用いられます。すなわち、最初の10点を
% 使って、11番目の点を予測子、2番目から11番目の点を使って、12番目の点を、
% 等々、予測します。より正確な結果を求めるためには、NEURONS の数を大きく
% してください。
%
% この関数は、NEURDEMO.M によってコールされます。


%       Author(s): C.F. Garvin, 6-21-95
%       Copyright 1995-2002 The MathWorks, Inc. 
