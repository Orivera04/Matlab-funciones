% INSTSWAP   'Swap' タイプの商品を作成する関数
%
% 新しい商品変数をデータ配列から生成するには、つぎのように設定します。
%   ISet = instswap(LegRate, Settle, Maturity, LegReset, Basis, ....
%           Principal, LegType)
%
% 'Swap'商品を商品変数に追加するには、つぎのように設定します。
%   ISet = instswap(ISet, LegRate, Settle, Maturity, LegReset, ....
%          Basis, Principal, LegType)
%
% 'Swap'商品のフィールドメタデータをリスト表示するには、つぎのように設定
% します。
%
%   [FieldList, ClassList, TypeString] = instswap;
%
% 入力： データ引数はNINST行１列のベクトル、または、NINST行2列のベクトル
%        スカラ、または、空のいずれかを入力できます。ベクトル内の指定の
%        ない入力については、NaN 値が入力されます。商品の生成にはたった
%        1つのデータ引数が必要とされ、他のデータ引数は削除、または、空行
%        列 []として省略されます。全ての入力は、入力データのクラスに応じ
%        て、FINARGPARSE によって、解釈されます。データのクラスを参照す
%        るには、"[FieldList, ClassList] = instswap " とタイプしてくださ
%        い。また、日付については、シリアル日付番号、または、日付文字列
%        で入力してください。
%
%   LegRate    - NINST行2列の行列です。この行列の各行は次のように定義
%                されています。
%                [CouponRate Spread]、または、[Spread CouponRate]
%                ここでCouponRate は10進数表記の年率。Spreadは基準金利を
%                超えるベーシスポイントの数です。最初の列は受け取った
%                区間(receiving leg)、二番目の列は支払いを行う区間
%                (paying leg)を示しています。              
%   Settle     - フロアの決済日を示す日付文字列、または、シリアル日付
%                番号
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
%                変動利率のいずれであるのかを示しています。この列の値が
%                0であれば、変動利率、値が1であれば固定利率です。行列
%                LegRateに入力された値をどのように解析するかを定義する
%                ためにこの行列は使用されます。デフォルトでは、各商品に
%                ついて [1,0] に設定されています。
%
% 出力:
%   ISet       - 商品の集合からなる変数。商品は、タイプ毎に分類され、
%                そのそれぞれのタイプについて互いに異なるデータフィールド
%                を設定することができます。記憶されたデータフィールドは
%                商品のそれぞれに対応する行ベクトル、または、文字列と
%                なっています。変数 ISet に関する詳細については、
%                "help instget" とタイプしてください。
% 
%   FieldList  - この商品タイプに適用されるデータフィールドの名称をリス
%                ト表示する文字列で構成される NFIELDS 行1列のセル配列。
%
%   ClassList  - 各フィールドのデータクラスを記載する文字列からなる 
%                NFIELDS 行 1 列のセル配列、ここに記載されるデータクラス
%                によって、引数の解釈法が決定されます。入力可能な引数は、
%                'dble', 'date',  'char'です。 
% 
%   TypeString - 追加される商品のタイプを指定する文字列です。
%                TypeString = 'Swap'.
%
% 参考 : INSTBOND, INSTCAP, INSTFLOOR, INSTADDFIELD, INSTDISP, 
%        INTENVPRICE, HJMPRICE


%   Author(s): M. Reyes-Kattar 03/10/99
%   Copyright 1995-2002 The MathWorks, Inc. 
