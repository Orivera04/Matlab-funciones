% INSTARGFLOOR   'Type','Floor' 引数の検証を行うサブルーチン
%
% この関数は、処理ルーチンの最初に実行されます。
%
%   [Strike, Settle, Maturity, Reset, Basis, Principal] = ....
%                                            instargfloor(ArgList{:})
%
% 入力: 
%   ArgList{:} 出力と1対1で処理される引数を入力します。
%
% 出力: 
% 出力は、適合する NINST 行1列のベクトルとなります。SIA 確定利付け証券の
% 引数の詳細については、"help ftb" とタイプしてください。
%
%   Strike     - フロアが行使される利率。十進数で表記されます。
%   Settle     - フロアの決済日を示す日付文字列、または、シリアル日付
%                番号。
%   Maturity   - フロアの満期日を示す日付文字列、または、シリアル日付
%                番号。
%   Reset      - 年に何回満期が訪れるか、その頻度を示すスカラ値。
%   Basis      - 入力されたフォワード利率ツリーを分析する際に適用される
%                日数カウント基準を示すスカラ値。
%   Principal  - 想定元本(名目元本)。
%   
% 参考 : INSTFLOOR.


%   Author(s): J. Akao, M. Reyes-Kattar 19-Apr-1999
%   Copyright 1995-2002 The MathWorks, Inc. 
