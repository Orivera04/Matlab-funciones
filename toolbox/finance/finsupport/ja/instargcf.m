% INSTARGCF   'Type', 'CashFlow' 引数の検証を行うサブルーチン
%
% この関数は、処理ルーチンの最初に実行されます。
%
%   [CFlowAmounts, CFlowDates, Settle, Basis] = instargcf(Arglist{:})
%
% 入力: 
%     Arglist{:}  出力と1対1で処理される引数を入力します。
%
% 出力: 
% 出力は、適合する NINST 行 MOSTCFS 列の行列となります。
%
%   CFlowAmounts - キャッシュフロー額からなる NINST 行 MOSTCFS 列の行列
%                  です。この行列を構成するそれぞれの行は、対応する1つの
%                  証券のキャッシュフロー値のリストとなっています。証券
%                  のキャッシュフローが、MOSTCFS キャッシュフローよりも
%                  少ない場合、行の末尾は NaN でパディングされます。
%
%   CFlowDates   - キャッシュフロー日付を示す NINST 行 MOSTCFS 列の行列
%                  です。この行列の各入力値は、CFlowAmounts 内の対応する
%                  キャッシュフローのシリアル日付を示しています。
%
%   Settle       - 決済日
%
%   Basis        - 日数のカウント基準。デフォルトは0 (actual/actual).
%
% 参考 : INSTCF.


%   Author(s): J. Akao 19-Mar-1999
%   Copyright 1995-2002 The MathWorks, Inc.
