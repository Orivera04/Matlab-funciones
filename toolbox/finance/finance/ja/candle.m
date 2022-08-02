% CANDLE   キャンドルスティックチャート 
%
% CANDLE(HI,LO,CL,OP,COLOR,DATES,DATEFORM) は、有価証券の価格の高値 HI、
% 安値 LO、終値 CL、始値 OP のデータが与えられた時に、キャンドルスティック
% チャートをプロットします。
% 全ての価格データは列ベクトルでなければなりません。
%
% 終値が始値よりも高い場合には、キャンドル本体(始値と終値の間の範囲)は
% 空になります。始値が終値よりも高い場合には、本体が塗りつぶされます。
% COLOR はキャンドルスティックの色を指定します。これは文字列で入力します。
% MATLABは色の指定が無い場合には、デフォルトを使用します。デフォルトの色
% は、figureウィンドウの背景の色によって異なります。COLOR 名については、
% MATLAB Reference Guide の 'COLERSPEC' の項を参照してください。
%
% 特定の日付をX軸目盛りに自由に使用することができます。
% 日付は列ベクトルDATESとして指定されます。 DATEFORMによって、日付文字列
% 目盛りの形式を設定できます。日付文字列形式の詳細は、DATEAXISを参照して
% ください。
%
% 参考 : HIGHLOW, BOLLING, MOVAVG, POINTFIG. 


%	Author(s): C.F. Garvin, 2-23-95 
%	Copyright 1995-2002 The MathWorks, Inc.  
