% LINE   lineオブジェクトの作成
% 
% LINE(X,Y) は、カレントのaxesにベクトル X と Ｙ で指定したlineを追加します。
% X と Y が同じサイズの行列の場合、1列ごとに1つのlineが追加されます。
% LINE(X,Y,Z) は、3次元座標にlineを作成します。
%
% LINE は、ライン毎に1つのハンドル番号をもち、LINEオブジェクトのハンドル
% 番号を要素とする列ベクトルを出力します。LINEは、AXESオブジェクトの子です。
%
% X、Y の組(3次元では X、Y、Z の3要素)の後には、lineの他のプロパティを
% 設定するためにパラメータ/値の組を設定できます。X、Y の組(3次元では 
% X、Y、Z の3要素)は省略することができ、パラメータと値の組を使ってすべて
% のプロパティを指定できます。
%
% H がラインのハンドル番号のとき、lineオブジェクトのプロパティとそれらのカレ
% ントの値を見るためには、GET(H) を実行してください。lineオブジェクトのプロ
% パティと設定できるプロパティ値を見るためには、SET(H) を実行してください。
% 
%
% 参考：PATCH, TEXT, PLOT, PLOT3.


%   Copyright 1984-2002 The MathWorks, Inc. 
%   $Revision: 1.9.4.1 $  $Date: 2004/04/28 01:55:57 $
%   Built-in function.
