% INSTBOND   'Bond'タイプ 商品の作成関数
%
% データ配列から新しい商品変数を生成するには、つぎのように設定します。
%   ISet = instbond(CouponRate, Settle, Maturity, ...
%             Period, Basis, EndMonthRule, ...
%             IssueDate, FirstCouponDate, LastCouponDate, ...
%             StartDate, Face)
%
%    'Bond' 商品を商品変数に追加するには、つぎのように設定します。
%   ISet = instbond(ISet, CouponRate, Settle, Maturity, ...
%             Period, Basis, EndMonthRule, ...
%             IssueDate, FirstCouponDate, LastCouponDate, ...
%             StartDate, Face)
%
% 商品に適用されるフィールドメタデータをリスト表示するには、つぎのように
% 設定します。
% 
%   [FieldList, ClassList, TypeString] = instbond;
%
% 入力: 
% データ引数には、NINST 行1列のベクトル、スカラ、または、空のいずれかを
% 入力できます。ベクトル内の指定のない入力については、NaN 値が入力され
% ます。商品の生成には、たった1つのデータ引数が必要とされ、他のデータ
% 引数は削除、または、空行列 []として省略されます。全ての入力は、入力
% データのクラスに応じて、FINARGPARSE によって解釈されます。データの
% クラスを参照するには、"[FieldList, ClassList] = instbond " とタイプ
% してください。なお、日付については、シリアル日付番号、または、日付
% 文字列で入力してください。SIA 確定利付証券の引数に関する詳細については、
% "help ftb" とタイプしてください。
%
%         CouponRate      - 10進法表記でのクーポンレート
%         Settle          - 決済日
%         Maturity        - 満期日
%         Period          - 年あたりのクーポン支払い回数(デフォルトは2)
%         Basis           - 日数カウント基準。デフォルトは0 
%                           (actual/actual)
%         EndMonthRule    - 月末ルール。デフォルトは1(月末ルールは有効)
%         IssueDate       - 債券の発行日
%         FirstCouponDate - 不定期、または、通常の第一回クーポン支払日
%         LastCouponDate  - 不定期、または、通常の最終クーポン支払日
%         StartDate       - 支払いを前もってスタートさせる日付(2.0では
%                           この引数の入力は無視されます)。
%         Face            - 債券の額面価値。デフォルトは100です。
%   
% 出力:
%   ISet        - 商品の集合からなる変数。商品は、タイプ毎に分類され、
%                 そのそれぞれのタイプについて互いに異なるデータフィールド
%                 を設定することができます。記憶されたデータフィールドは
%                 商品のそれぞれに対応する行ベクトル、または、文字列と
%                 なっています。変数ISetに関する詳細については、
%                 "help instget" とタイプしてください。
% 
%   FieldList   - この商品タイプに適用されるデータフィールドの名称をリス
%                 ト表示する文字列で構成される NFIELDS 行1列のセル配列。
%   ClassList   - 各フィールドのデータクラスを記載する文字列からなる 
%                 NFIELDS行1列のセル配列、ここに記載されるデータクラスに
%                 よって、引数の解釈法が決定されます。入力可能な引数は、
%                 'dble', 'date',  'char' です。 
%   TypeString  - 追加される商品のタイプを指定する文字列です。
%                  TypeString = 'Bond'.
%
%
% 参考 : INSTADDFIELD, INSTGET, INSTDISP, INTENVPRICE, HJMPRICE.


%   Copyright 1995-2002 The MathWorks, Inc. 
