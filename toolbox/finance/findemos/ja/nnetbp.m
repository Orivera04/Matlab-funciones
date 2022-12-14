% NNETBP   Financial Expo 用ニューラルネット高速バックプロパゲーション
%          のデモンストレーションです。
%
% PRED = NNETBP(INDAT,PTS,N,NEURONS) は、Financial Expo 用ニューラル
% ネット高速バックプロパゲーションのデモンストレーション実行します。PTS 
% は、使用されるデータセット点の総数を指定します。N は、PTS 内部の点の
% いくつが、つぎの出力を予測するために使用されるかを指定します。NEURONS 
% は、ニューラルネットワークで用いられる中間層のニューロンの数を指定し
% ます。たとえば、データセット 300点(PTS = 300)から、10点(N = 10)が、
% つぎの点の予測のために用いられます。すなわち、最初の10点を使って、
% 11番目の点を予測子、2番目から11番目の点を使って、12番目の点を、等々、
% 予測します。より正確な結果を求めるためには、NEURONS の数を大きくして
% ください。この関数は、NEURDEMO.M によってコールされます。


%       Author(s): C.F. Garvin, 6-21-95
%       Copyright 1995-2002 The MathWorks, Inc. 
