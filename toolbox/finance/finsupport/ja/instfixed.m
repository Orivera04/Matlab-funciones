% INSTFIXED   'Fixed'タイプ 商品の作成関数
%
% データ配列から新しい商品変数を生成するには、つぎのように設定します。
% 
%   ISet = instfixed(CouponRate, Settle, Maturity, Reset, Basis, ....
%          Principal)
%
% 商品変数に'Fixed'商品を追加するには、つぎのように設定します。
% 
%   ISet = instfixed(ISet, CouponRate, Settle, Maturity, Reset,...
%                  Basis, Principal)
%
%  'Fixed' 商品に対応するフィールドメタデータをリストアップするには、
% つぎのように設定します。
% 
%   [FieldList, ClassList, TypeString] = instfixed;
%
% 入力: 
% データ引数には、NINST 行1列のベクトル、スカラ、または、空のいずれかを
% 入力できます。ベクトル内の指定のない入力については、NaN 値が入力され
% ます。商品の生成には、たった1つのデータ引数が必要とされ、他のデータ
% 引数は削除、または、空行列 []として省略されます。全ての入力は、入力
% データのクラスに応じて、FINARGPARSE を使って解釈されます。データの
% クラスを参照するには、"[FieldList, ClassList] = instfixed" とタイプ
% してください。なお、日付については、シリアル日付番号、または、日付
% 文字列で入力してください。
%
%   CouponRate      - 10進数表記の年利率
%   Settle          - 決済日
%   Maturity        - 満期日
%   Reset           - 年に何回決済が行われるかの頻度です。
%                     デフォルトは1です。
%   Basis           - 日数カウント基準。デフォルトは 0 (actual/actual)。
%   Principal       - 想定元本(名目元本)。デフォルトは100です。
%   
% 出力:
%   ISet       - 商品の集合からなる変数。商品は、タイプ毎に分類され、そ
%                のそれぞれのタイプについて互いに異なるデータフィールド
%                を設定することができます。記憶されたデータフィールドは
%                商品のそれぞれに対応する行ベクトル、または、文字列とな
%                っています。変数 ISet に関する詳細については、
%                "help instget" とタイプしてください。
% 
%   FieldList  - この商品タイプに適用されるデータフィールドの名称をリス
%                ト表示する文字列で構成される NFIELDS 行1列のセル配列。
% 
%   ClassList  - 各フィールドのデータクラスを記載する文字列からなる 
%                NFIELDS行1列のセル配列、ここに記載されるデータクラスに
%                よって、引数の解釈法が決定されます。入力可能な引数は、
%                'dble', 'date',  'char'です。 
%   TypeString - 追加される商品のタイプを指定する文字列です。
%                TypeString = 'Fixed'.
%
% 参考 : INSTADDFIELD, INSTGET, INSTDISP, INTENVPRICE, HJMPRICE.


%   Author(s): M. Reyes-Kattar 04/28/99
%   Copyright 1995-2002 The MathWorks, Inc. 
