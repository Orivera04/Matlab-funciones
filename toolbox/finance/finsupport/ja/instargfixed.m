% INSTARGFIXED   'Type','Fixed' 引数の検証を行うサブルーチン
%
% この関数は、処理ルーチンの最初に実行されます。
%
%   [CouponRate, Settle, Maturity, Reset, Basis, Principal] = ...
%                                              instargfixed(ArgList{:})
%
% 入力: 
% ArgList{:}  出力と1対1で処理される引数を入力します。
%
% 出力: 
% 出力は、適合する NINST 行1列のベクトルとなります。
%
%   CouponRate      - 10進法表記の年率
%   Settle          - 決済日
%   Maturity        - 満期日
%   Reset           - 年に何回決済が行われるか、その頻度を示す引数。
%                     デフォルトは1です。
%   Basis           - 日数のカウント基準。デフォルトは 0 (actual/actual)
%                     です。
%   Principal       - 想定元本(名目元本)。デフォルトは100です。
%   
% 参考 : INSTFIXED.


%   Author(s): J. Akao, M. Reyes-Kattar 04/28/99
%   Copyright 1995-2002 The MathWorks, Inc. 
