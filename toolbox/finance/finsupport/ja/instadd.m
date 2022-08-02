% INSTADD   ���i�̏W���ϐ��ɁAMathWorks �ɂ���ċ������ꂽ���i�^�C�v��
%           �ǉ�
%
%INSTADD �ɂ́A���̃^�C�v�̏��i���L������Ă��܂��B'Bond', 'CashFlow', 
% 'OptBond', 'Fixed', 'Float', 'Cap', 'Floor'�A�܂��́A'Swap' �ł��B
% �Ȃ��A���i���胋�[�`���y�ъ����x���[�`���̑o�����A�����̏��i�ɑ΂���
% �񋟂���Ă��܂��B
%
% �g�p�@�F
%   ���ꂼ��̏،��쐬�֐��ɂ��āA�g�p�@�Ƌ��ɐ������Ă����܂��B
% 
%   instbond   - �����i
%   InstSet = instadd('Bond', CouponRate, Settle, Maturity, ...
%                     Period, Basis, EndMonthRule, ...
%                     IssueDate, FirstCouponDate, LastCouponDate, ...
%                     StartDate, Face)
%
%   instcf     - �C�ӂ̃L���b�V���t���[��L���鏤�i
%   InstSet = instadd('CashFlow', CFlowAmounts, CFlowDates, TFactors)
%   
%   instoptbnd -�I�v�V�����g�ݍ��ݍ�
%   InstSet = instoptbnd('OptBond', BondIndex, OptSpec, ... 
%                         Strike, ExerciseDates, AmericanOpt)
%
%   instfixed  - �m�藘�t���i
%   InstSet = instadd('Fixed', CouponRate, Settle, Maturity, ...
%                      Reset, Basis, Principal)
%
%   instfloat  - �ϓ����t���i
%   InstSet = instadd('Float', Spread, Settle, Maturity, ...
%                      Reset, Basis, Principal)
%
%   instcap    - �L���b�v�t�����i
%   InstSet = instadd('Cap', Strike, Settle, Maturity, Reset, Basis, ...
%                      Principal)
%
%   instfloor  - �t���A�t�����i.
%   InstSet = instadd('Floor', Strike, Settle, Maturity, Reset, ...
%              Basis, Principal)
%
%   instswap   - �X���b�v���i
%   InstSet = instadd('Swap', LegRate, Settle, Maturity, LegReset, ....
%              Basis, Principal, LegType)
%
%   �����̏W���ɏ��i��ǉ�����ɂ́A���̊֐������s���Ă��������B
%   InstSet = instadd(InstSetOld, TypeString, Data1, Data2, ...)
%   InstSet = instadd('CashFlow', CFlowAmounts, CFlowDates, TFactors)
%
% ����: 
% ���Ƃ��΁A"help instcap" �ƃ^�C�v����΁A���i�̃f�[�^�p�����[�^��
% �ւ���ڍׂȏ��𓾂邱�Ƃ��ł��܂��B
%
%   InstSetOld - ���i�̏W������Ȃ�ϐ��B���i�́A�^�C�v���ɕ��ނ���Ă�
%                ��A���ꂼ��̃^�C�v�ɂ��ĈقȂ�f�[�^�t�B�[���h���
%                ��ł��܂��B�L�����ꂽ�f�[�^�t�B�[���h�́A���i�̂��ꂼ
%                ��ɑΉ�����s�x�N�g���A�܂��́A������ƂȂ��Ă��܂��B
%
% �o��:   
%   InstSet    - �V�������̓f�[�^���܂ޏ��i�W���ϐ��B
%
% ���: 
%   2�̃L���b�v�t������6�������o�͂��܂��B
%   CapStrike = [0.06; 0.07];
%   BondCoupon = 0.04;
%   Settle = '06-Feb-1999';
%   Maturity = '15-Jan-2001';
%
%   ISet = instadd('Cap', CapStrike, Settle, Maturity);
%   ISet = instadd(ISet, 'Bond', BondCoupon, Settle, Maturity);
%   instdisp(ISet)
%   
% �Q�l : INSTBOND, INSTCF, INSTOPTBND, INSTFIXED, INSTFLOAT, INSTCAP, 
%        INSTFLOOR, INSTSWAP.


%   Author(s): J. Akao, M. Reyes-Kattar 10/27/99
%   Copyright 1995-2002 The MathWorks, Inc. 
