% HIGHLOW   高値-安値 - 始値-終値チャート
%
% HIGHLOW(HI,LO,CL,OP,COLOR) は、資産の高値、安値、始値、終値をプロット
% します。プロットは、垂直線の最上部が高値、最下部が安値で、始値はその線
% の左側に突き出た短い水平の目盛り、終値は右側に突き出た短い水平の目盛り
% です。HI は資産の高値、LO は安値、CL は終値、OP は始値、COLOR は線の色
% です。すべての入力価格は、列ベクトルとして指定されます。
% 
% Color を何も指定しない場合には、MATLAB は、デフォルトの色を使用します。
% デフォルトの色は、フィギュアウインドウの背景の色によって異なります。
% COLOR 名については、MATLAB Reference Guide の 'COLORSPEC' を参照して
% ください。
%
% OP は、オプションです。OP が未知のときにCOLORを指定するためには、OP に
% 空行列 [] を入力してください。
%
% HIGHLOW(HI,LO,CL,OP,COLOR) は、フィギュアをプロットし、ラインのハンドル
% H を出力します。ハンドルグラフィックスの詳細については、MATLAB User's 
% Guide を参照してください。
% 
% HIGHLOW(HI,LO,CL,OP,COLOR,DATES,DATEFORM) を使用すると、ベクトルDATESを
% 指定することができます。DATESは、列ベクトルでなければなりません。
% DATEFORM は、オプションの入力引数で、日付文字列の形式を軸ラベルで指定
% します。日付文字列の形式の詳細については、DATEAXIS を参照して下さい。
% 
% 例題：
% ある資産の高値、安値、終値がそれぞれベクトル asseth, assetl, assetc と
% してある場合、高値-安値-終値チャートは、つぎのコマンドでプロット表示
% されます。
% 
%        highlow(asseth,assetl,assetc)
%
% プロットの対象となるデータは、NaN値で桁揃えを行ってください。
%
% 参考 : CANDLE.


%	Author(s): C.F. Garvin, 2-23-95  
%   Copyright 1995-2002 The MathWorks, Inc. 
