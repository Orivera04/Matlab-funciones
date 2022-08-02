% INSTARGFLOAT   'Type','Float' 引数の検証を行うサブルーチン
%
% この関数は、処理ルーチンの最初に実行されます。
%
%   [Spread, Settle, Maturity, Reset, Basis, Principal] = ...
%                                              instargfloat(ArgList{:})
%
% 入力: 
% 出力と1対1で処理される引数を入力します。
%
% 出力: 
% 出力は、適合する NINST 行1列のベクトルとなります。
%
%   Spread     - 基準金利を超えるベーシスポイントの数。
%   Settle     - 変動利付け債の決済日を示す日付文字列、または、シリアル
%                日付番号
%   Maturity   - 変動利付け債の満期日を示す日付文字列、または、シリアル
%                日付番号
%   Reset      - 年に何回満期が訪れるか、その頻度を示すスカラ値
%   Basis      - 入力されたフォワード利率ツリーを分析する際に適用される
%                日数カウント基準を示すスカラ値。
%   Principal  - 想定元本(名目元本)。
%   
% 参考 : INSTFLOAT.


%   Author(s): J. Akao, M. Reyes-Kattar 19-Apr-1999
%   Copyright 1995-2002 The MathWorks, Inc. 
