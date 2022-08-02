% BOLLING   Bollingerバンドチャート 
%
% BOLLING(ASSET,SAMPLES,ALPHA) は、ASSETデータが与えられた時に、Bollinger
% バンドチャートをプロットします。SAMPLES は、移動平均の計算に使用する
% サンプル数を指定します。ALPHA は、移動平均の要素加重値を計算するために
% 使用する指数です。この関数は、出力データをもちません。
%       
% [MAV,UBAND,LBAND] = BOLLING(ASSET,SAMPLES,ALPHA) は、MAV に ASSET 
% データの移動平均を、UBAND に上方のバンドのデータを、LBAND に下方の
% バンドのデータを出力します。この場合には、どのデータもプロットされ
% ません。
% 
% BOLLING(ASSET,20,1) は、線形の20日間移動平均Bollingerバンドをプロット
% します。
% 
% [MAV,UBAND,LBAND] = BOLLING(ASSET,20,1) は、線形の20日間移動平均
% Bollingerバンドをプロットするためのデータを出力しますが、この場合、
% この関数自身では、データのプロットは行いません。
%
% 入力引数のエラーチェックを行って下さい。重みベクトルを計算、ループを
% 用いて、移動平均ベクトルを計算してください。
% 
% 参考 : MOVAVG, HIGHLOW, CANDLE, POINTFIG.


%       Author(s): C.F. Garvin, 2-23-95 
%       Copyright 1995-2002 The MathWorks, Inc.  
