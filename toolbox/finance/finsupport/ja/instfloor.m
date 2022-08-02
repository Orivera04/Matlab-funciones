% INSTFLOOR   'Floor'タイプ 商品の作成関数
%
% データ配列から新しい商品を生成するには、つぎのように設定してください。
% 
%   ISet = instfloor(Strike, Settle, Maturity, Reset, Basis, Principal)
%
% 'Floor' 商品を商品変数に追加するには、つぎのように設定してください。
%   ISet = instfloor(ISet, Strike, Settle, Maturity, Reset, Basis, ....
%        Principal)
%
% 'Floor' 商品に適用されるフィールドメタデータをリスト表示するには、つぎ
% のように設定します。
% 
%   [FieldList, ClassList, TypeString] = instfloor;
%
% 入力:
% データ引数には、NINST 行1列のベクトル、スカラ、または、空のいずれかを
% 入力してください。ベクトル内の指定のない入力については、NaN 値が入力さ
% れます。商品の生成には、たった1つのデータ引数が必要とされ、他のデータ
% 引数は、削除、または、空行列 []として省略されます。全ての入力は、入力
% データのクラスに応じて、FINARGPARSE によって解釈されます。データのクラ
% スを参照するには、"[FieldList, ClassList] = instbond" とタイプしてくだ
% さい。なお、日付については、シリアル日付番号、または、日付文字列で入力
% してください。
%
%   Strike     - フロアが行使される利率。十進数で表記されます。
%   Settle     - フロアの決済日を示す日付文字列、または、シリアル日付番
%   Maturity   - フロアの満期日を示す日付文字列、または、シリアル日付番号
%   Reset      - 年に何回満期が訪れるか、その頻度を示すスカラ値
%   Basis      - 入力されたフォワード利率ツリーを分析する際に適用される
%                日数カウント基準を示すスカラ値
%   Principal  - 想定元本(名目元本)
%
% 出力:
%   ISet       - 商品の集合からなる変数。商品は、タイプ毎に分類され、そ
%                のそれぞれのタイプについて、互いに異なるデータフィール
%                ドを設定することができます。記憶されたデータフィールド
%                は、商品のそれぞれに対応する行ベクトル、または、文字列
%                となっています。変数 ISet に関する詳細については、
%                "help instget" とタイプしてください。
% 
%   FieldList  - この商品タイプに適用されるデータフィールドの名称をリス
%                ト表示する文字列で構成される NFIELDS 行1列のセル配列。
% 
%   ClassList  - 各フィールドのデータクラスを記載する文字列からなる 
%                NFIELDS行1列のセル配列、ここに、記載されるデータクラス
%                によって、引数の解釈法が決定されます。入力可能な引数は
%                'dble', 'date',  'char' です。 
% 
%   TypeString - 追加される商品のタイプを指定する文字列です。
%                TypeString = 'floor'
%
% 参考 : INSTBOND, INSTCAP, INSTSWAP, INSTADDFIELD, INSTDISP, 
%        INTENVPRICE, HJMPRICE.


%   Author(s): M. Reyes-Kattar 03/10/99
%   Copyright 1995-2002 The MathWorks, Inc. 
