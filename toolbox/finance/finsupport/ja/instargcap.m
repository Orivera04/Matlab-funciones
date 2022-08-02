% INSTARGCAP   'Type','Cap' 引数の検証を行うサブルーチン
%
% この関数は、処理ルーチンの最初に実行されます。
%
%  [Strike, Settle, Maturity, Reset, Basis, Principal] = ...
%                                          instargcap(ArgList{:})
%
% 入力: 
%   ArgList{:}  出力と1対1で処理される引数を入力します。
%
% 出力: 出力は、適合する NINST 行1列のベクトルとなります。SIA 確定利付け
% 証券の引数の詳細については、"help ftb" とタイプしてください
%
%   Strike     - キャップが行使される利率。10進法で表記されます。
%   Settle     - キャップの決済日を示す日付文字列、または、シリアル日付
%                番号。
%   Maturity   - キャップの満期日を示す日付文字列、または、シリアル日付
%                番号。
%   Reset      - 年に何回満期が訪れるか、その頻度を示すスカラ値。
%   Basis      - 入力されたフォワード利率ツリーの分析に用いられる日付カ
%                ウント基準を示すスカラ値。
%   Principal  - 想定元本(名目元本)。
%   
% 参考 : INSTCAP.


%   Author(s): J. Akao, M. Reyes-Kattar 19-Apr-1999
%   Copyright 1995-2002 The MathWorks, Inc. 
