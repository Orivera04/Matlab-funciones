% MOVAVG   リード/ラグ移動平均チャート
%
% [SHORT,LONG] = MOVAVG(ASSET,LEAD,LAG,ALPHA) は、リード／ラグ移動平均
% チャートをプロットします。ASSET は有価証券のデータ、LEAD はリード平均の
% 計算に使用するサンプル数、LAG はラグ平均の計算に使用するサンプル数です。
% ALPHA は移動平均の種類を決定する制御パラメータです。
% 
%       ALPHA = 0 (デフォルト)は、単純な移動平均を計算します。
%       ALPHA = 0.5 は、平方根加重移動平均、ALPHA =1は、線形移動平均、
%  　   ALPHA = 2 は、二乗加重移動平均等々を計算します。指数移動平均を計
%               算するためには、ALPHA = 'e'とします。 
% 
% MOVAVG(ASSET,3,20,1) は、線形な3サンプルのリード移動平均と20サンプルの
% ラグ移動平均をプロットします。 
% 
% [SHORT,LONG] = MOVAVG(ASSET,3,20,1) は、リード移動平均データとラグ移動
% 平均データを出力しますが、プロットは行いません。
% 
% 参考 : BOLLING, HIGHLOW, CANDLE, POINTFIG.


%       Author(s): C.F. Garvin, 2-23-95 
%       Copyright 1995-2002 The MathWorks, Inc.  
