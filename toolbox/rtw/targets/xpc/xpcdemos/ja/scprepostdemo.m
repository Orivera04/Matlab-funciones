% SCPREPOSTDEMO xPC スコープのプリ/ポストトリガに関するデモンストレーション
%
% SCPREPOSTDEMO は、モデルxpcsosc.mdlを開き、モデルを構築し、さらに、
% ターゲットPCにダウンロードします。タイプがhostのスコープは、アプリ
% ケーションに追加され、シグナル'Signal Generator' と'Integrator1'
% が、スコープに追加されます。それから、スコープは、トリガレベル0.0、 
% 立ち上がりエッジ検出として、シグナル'Signal Generator' (プロパティ名は、 
% 関数GETSIGNALIDを使用して回収されます)のトリガに設定されます。
%
% その後、アプリケーションが起動し、データ表示のためのモニタのロードが
% 完了します。それから、データがアップロードされ、プロットされます。
% このプロセスは、総計で25回繰り返されます。その際、パラメータ'Gain1/Gain'
% (プロパティ名は、関数GETPARAMIDを通して回収されます。）の値を5つおきに
% ランダム値に変更します。さらに、5つおきに、スコープは、プリトリガに
% 12サンプル、ポストトリガに12 サンプル、交互に設定します。
%
% 12 サンプルを選択しているのは、'SignalGenerator' ブロックが、
% 20 Hzで方形波を出力するためです。スコープのDecimation は、4であるので、
% 2つの取得したサンプル間の違いは、1 msです。そのため、取得サンプルは、
% 毎回、方形波のおよそ1/4シフトします。



%   Copyright (c) 1996-2000 The MathWorks, Inc. All Rights Reserved.
