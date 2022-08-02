% INSTARGSWAP   'Type','Swap' 引数の検証を行うサブルーチン
%
% この関数は、処理ルーチンのトップで実行されます。
%
%   [LegRate, Settle, Maturity, LegReset, Basis, Principal, ...
%                LegType] = instargswap(ArgList{:})
%
% 入力: 
%     ArgList{:} 出力と1対1対応で処理される引数を入力します。
%
% Outputs: 出力は適合する NINST 行1列、または、NINST行2列のベクトルと
%          なります。
%   LegRate    - NINST行2列の行列です。この行列の各行は次のように定義
%                されています。
%                [CouponRate Spread]、または、[Spread CouponRate]
%                ここで、CouponRate は10進数表記の年率。Spreadは基準金利
%                を超えるベーシスポイントの数です。最初の列は受け取った
%                区間(receiving leg)、二番目の列は支払いを行う区間
%                (paying leg)を示しています。              
%   Settle     - 各スワップ債に対する決済日を表す日付を要素とするNINST行
%                1列のベクトル
%   Maturity   - スワップ債の満期日を示すNINST行1列のベクトルです。
%   LegReset   - それぞれのスワップ債について年に何回決済が行われるかを
%                示す NINST 行2列の行列です。デフォルトは[1 1]です。
%   Basis      - 入力されたフォワード利率ツリーの分析に適用される日数の
%                カウント基準を示すNINST行1列のベクトルです。デフォルト
%                は0 (actual/actual)
%   Principal  - 想定元本(名目元本)を示すNINST行1列のベクトルです。
%                デフォルトは100
%   LegType    - NINST行2列の行列です。この行列の各行は、スワップ債商品
%                に対応しており、各列は、対応する区間が固定利率、または
%                変動利率のいずれであるのかを示しています。この列の値が0
%                であれば、変動利率、値が1であれば固定利率です。行列
%                LegRateに入力された値をどのように解析するかを定義する
%                ためにこの行列は使用されます。デフォルトでは、各商品に
%                ついて [1,0] に設定されています。
%   
% 参考 : INSTSWAP.


%   Author(s): J. Akao, M. Reyes-Kattar 25-Apr-1999
%   Copyright 1995-2002 The MathWorks, Inc. 
