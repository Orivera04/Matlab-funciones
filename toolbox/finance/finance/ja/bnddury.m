% BNDDURY �^����ꂽ����肩����̃f�����[�V�������v�Z���܂��B
%
% ���̊֐��́ANUMBONDS �m�藘�t���� Macaulay �f�����[�V�����y�яC���f
% �����[�V���������ꂼ��̍��̖����܂ł̗���肩��v�Z���܂��B���̊֐�
% �́A���̃N�[�|���\�����ŏ��A�܂��́A�Ō�̊��Ԃ��Z���A�܂��́A������
% ����ꍇ�ł��A���̃f�����[�V�������v�Z���邱�Ƃ��ł��܂�(���Ȃ킿�A
% �N�[�|���\���������Ɠ������Ă��邩�ǂ����ɂ�����炸���̃f�����[�V��
% �����v�Z�ł��܂�)�B���̊֐��́A�[���N�[�|���� Macaulay �y�яC���f��
% ���[�V�����̌v�Z���\�ɂ��܂��B
%
%   [ModDuration, YearDuration, PerDuration] = ....
%            bnddury(Yield, CouponRate, Settle, Maturity)
%
%   [ModDuration, YearDuration, PerDuration] = ....
%            bnddury(Yield, CouponRate, Settle, Maturity, ....
%            Period, Basis, EndMonthRule, IssueDate,....
%            FirstCouponDate, LastCouponDate, StartDate, Face)
%
% ����: [�K�{]�Ǝw�肳��Ă���S�Ă̈����́ANUMBONDS�s1��A�܂��́A1�s
% NUMBONDS��̃x�N�g���A�܂��́A�X�J�������ł��B�I�v�V�����̈����͑S��
% NUMBONDS�s1��A�܂��́A1�sNUMBONDS��̃x�N�g���A�X�J���A�܂��́A��s��
% �ƂȂ�܂��B����(�I�v�V����)�́A��s��ɂ���ďȗ����邱�Ƃ��ł��܂��B
% ����ɓ���(�I�v�V����)�̒��ŁA�������X�g�̖����Ɉʒu������͂͊�������
% ���Ƃ��ł��܂��B����(�I�v�V����)�̒l���f�t�H���g�l�ɐݒ肷��ɂ́A
% NaN �l����͒l�Ƃ��Đݒ肵�Ă��������B���t�����́A�V���A�����t�ԍ�
% �܂��́A���t������ł��BSIA�m�藘�t���̈����Ɋւ���ڍׂɂ��ẮA 
% 'help ftb'�ƃ^�C�v���Ă��������B
% �������̈����Ɋւ���ڍׁA���Ƃ��΁ASettle�́A"help ftbSettle"��
% �^�C�v����ΎQ�Ƃł��܂��B
%
%  Yield (�K�{)      - ���N�����v�Z�̖��������
%  CouponRate (�K�{) - 10�i�@�ŕ\�L���ꂽ�N�[�|������
%  Settle (�K�{)     - ���ϓ�
%  Maturity (�K�{)   - ������
%
% ����(�I�v�V����):
%  Period          - 1�N�ł̃N�[�|���x����(�f�t�H���g��2)
%  Basis           - �����J�E���g��B�f�t�H���g��0 (actual/actual)
%  EndMonthRule    - �����K��; �f�t�H���g��1(�����K���͗L��)
%  IssueDate       - ���̔��s��
%  FirstCouponDate - �s����A�܂��́A�ʏ�̑�1��N�[�|���x����
%  LastCouponDate  - �s����A�܂��́A�ʏ�̍ŏI�N�[�|���x����
%  StartDate       - �x������O�����ăX�^�[�g��������t
%                    (2.0�ł͂��̈����̓��͖͂�������܂��B)
%  Face            - ���̊z�ʉ��l�B�f�t�H���g��100
%
% �o��:
% ModifiedDuration - �C���f�����[�V����
% YearDuration     - �N�P�ʂ� Macaulay �f�����[�V����
% PerDuration      - ���� Macaulay �f�����[�V����
%         
% �o�͂́ANUMBONDS�s1��̃x�N�g���ł��B
%
% �Q�l : BNDDURP, BNDCONVY, BNDCONVP.


%   Author(s): C. Bassignani, 07-29-98 
%   Copyright 1995-2002 The MathWorks, Inc. 
