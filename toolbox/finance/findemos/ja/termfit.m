% TERMFIT   �N�[�|���̉��i����~�����[���Ȑ����ߎ�
%
% [ZeroRates, CurveDates, BootZeros, BootDates, BreakDates] = termfit(...
%     Smoothing, Bonds, Prices, Settle, ...
%         OutputCompounding, OutputBasis, CurveDates, BreakDates)
%
% �ڍׁF
% TERMFIT �́A1�g�̍��̎s�ꉿ�i�ɂ���Ď�������闘���\���ɕ���������
% �Ȑ���K�������܂��B���̓K�������\���́A���̉��i�𐳊m�Ɍ��肷�邱��
% �͂���܂��񂪁A�s�ꉿ�i�ɂ����邢�����̃m�C�Y�𐄒肷�邱�Ƃ��ł���
% ���BSMOOTHING �p�����[�^�́A�[���Ȑ��̉~�����Ɠ��͂��ꂽ���̉��i����
% �ɂ�����덷�Ƃ̊Ԃɂ݂���g���[�h�I�t�𒲐����܂��B
% 
% ����: 
%    Smoothing   - �X�J���l, 0 <= Smoothing <= 1, �������̓x������K�p��
%                  �邩���w�肵�܂��B
%             Smoothing = 0 �́A���̉��i����ɂ�����덷���ŏ��ɂ��܂��B
%             Smoothing = 1 �́A�����ߎ����܂��B
%
%    Bonds       - �[���Ȑ������o�����N�[�|���̃|�[�g�t�H���I�ł��B
%                  ���ɁA���p�����[�^�� N �s M ��̍s��ƂȂ�A�e�s��
%                  �X�̍��ɑΉ����A�e��͓���̃p�����[�^�ɑΉ�����
%                  ���܂��B���̍s��ɕK�{�ƂȂ��(�p�����[�^)�́A����
%                  �ʂ�ł��B
%    Maturity    - (�� 1)�|�[�g�t�H���I�̊e���ɑ΂��閞�����B�V���A��
%                  ���t�ԍ��ŕ\�����܂��B
%    CouponRate  - (�� 2)�|�[�g�t�H���I�̊e���ɑ΂���N�[�|�����[�g�B
%                  10�i���ŕ\�����܂��B
% 
% �Ȃ��A�I�v�V�����̗�(�p�����[�^)�́A���̒ʂ�ł��B
%    Face        - (��3)�|�[�g�t�H���I�̊e���̊z�ʉ��l�B�f�t�H���g��
%                  $100�ł��B
%    Period      - (��4)�N������̃N�[�|���x�����񐔂ŁA�����ŕ\�������
%                  ���B��蓾��l�� 1, 2 (�f�t�H���g), 3, 4, 6, 12�ł��B
%    Basis       - (��5)�|�[�g�t�H���I�̊e���ɑ΂��ēK�p���������J�E
%                  ���g��������l�ł��B��蓾��l�͂��̒ʂ�ł��B
%               1)Basis = 0 - actual/actual(�f�t�H���g)
%               2)Basis = 1 - 30/360
%               3)Basis = 2 - actual/360
%               4)Basis = 3 - actual/365
%    EndMonthRule - (�� 6)�|�[�g�t�H���I���\������e���ɑ΂��Č����K��
%                   ��K�p���邩���Ȃ������w�肷��l�ł��B��蓾��l�́A
%                   ���̒ʂ�ƂȂ�܂��B
%               1)EndMonthRule = 1(�f�t�H���g)
%                     ���ɑ΂��錎���K���͗L���ł�(���Ȃ킿�A���̖���
%                     �ɃN�[�|�����������s�����́A��Ɍ��̖����Ɏx����
%                     ���s�����ƂɂȂ�܂�)�B
%               2)EndMonthRule = 0 
%                     �����K���͍��ɑ΂��Ė����ƂȂ��Ă��܂��B
%
%    Prices      -  Bonds �s��ɂ���Ď������|�[�g�t�H���I���\������
%                   �e���ɑ΂��鉿�i�l������ N �s1��̗�x�N�g���ł��B
%    Settle      -  �[���Ȑ������߂���ۂ�0���_�������X�J���l�B�ʏ� 
%                   ���̒l�́A�[���Ȑ��𓱏o����|�[�g�t�H���I���\������
%                   ���̌��ϓ��ƂȂ�܂��B
%
%    OutputCompounding - 
%                   (�I�v�V����)�o�͂����[��������N���Ɋ��Z����Ƃ���
%                    �ǂ̂��炢�̊����ŕ����v�Z���s�����������X�J���l�B
%                    �f�t�H���g�l�́A���N�����v�Z(2)�ł��B
%
%    OutputBasis - �o�͂����[��������N���Ɋ��Z����Ƃ��ɂǂ̓����J�E
%                  ���g���p���邩�������X�J���l�B���͂ł���l�́A��
%                  ���̒ʂ�ł��B
%              1)Basis = 0 - actual/actual(�f�t�H���g)
%              2)Basis = 1 - 30/360
%              3)Basis = 2 - actual/360
%              4)Basis = 3 - actual/365
%
%    CurveDates  - �ߎ�����[�����������V���A�����t�� NumOut �s1��̗�x
%                  �N�g���ł��B�f�t�H���g�ł́A�|�[�g�t�H���I���\������
%                  �������̍����L���b�V���t���[��L������t�Őݒ肳
%                  ��܂��B
%    BreakDates  - ���ϓ��Ɩ����܂ł��ł��������̖������Ƃ̊Ԃ̓��t��
%                  ��Ȃ�NumBreaks �s1��̗�x�N�g���ł��B�u���̃t�H���[�h
%                  �Ȑ��́ABreakDates �Ԃ̊Ԋu�ŋ敪�I��3���֐�(cubic)��
%                  �Ȃ�܂��B���ϓ��Ɩ����܂ł̊��Ԃ��ł��������̖�����
%                  �́ABreakDates �ɓ��͂���Ă��Ȃ��ꍇ�ł������I�ɐߓ_�Q
%                  �ɉ������܂��B
%
% �o�́F
%    ZeroRates  - �������ɂ���Ē�`���ꂽ���L���ԏ�̊e�_�ɑ΂���ߎ�
%                 �[�����̒l����Ȃ� NumOut �s1��̃x�N�g���ł��B
%    CurveDates - ���L���ԏ�̊e�[�����ɑ΂��閞��������Ȃ�NumOut�s1��
%                 �̃x�N�g���ł�(���L���Ԃ́AT = Settle �Œ�`���ꂽ����
%                 �ƌ���|�[�g�t�H���I���\��������̒��Ŗ����܂ł̊���
%                 ���ł��������̖����� T = maturity �܂ł̊��ԂƂ���
%                 ��`����܂�)�B
%    BootZeros  - ���͂��ꂽ�|�[�g�t�H���I�̉��i�𐳊m�Ɍ��肷�������
%                 �����̃u�[�g�X�g���b�v�[��������Ȃ� NumBoot �s1��̃x
%                 �N�g���ł��BBootZores �Ȑ��ɂ́A�X���[�V���O�͑S���K�p
%                 ���Ă��܂���B�u�[�g�X�g���b�v�@�̏ڍׂɂ��ẮA
%                 ZBTPRICE ���Q�Ƃ��Ă��������B
%    BootDates  - �u�[�g�X�g���b�v�[���Ȑ��̖���������Ȃ� NumBoot �s1��
%                 �̃x�N�g���ł�
%    BreakDates - �t�H���[�h�Ȑ��̃X�v���C���\���̍\�z�ɗp������ߓ_�x
%                 �N�g���ł��B
%
% ���ӁF 
% TERMFIT �́A�t�H���[�h�����Ȑ��ɑ΂��āA�~���ȎO���X�v���C���Ȑ���K��
% �����܂��B�K�؂ȋȐ��������邩�ǂ����́A���� SMOOTHING �̒l�ƃL���[
% �r�b�N�f�ʊԂ̐ߓ_�̐ݒ�Ɉ˂�܂��B����̃f�[�^�Z�b�g�ɑ΂��āA�p��
% ���[�^�ݒ�́A�����ɂ�鎎�s���낪�K�v�ł��B
%
% ���̃v���O�����ɑg�ݍ��܂�Ă���J�[�u�t�B�b�e���O���f���́A
% Mark Fisher, Douglas Nychka and David Zervos ���A���̕����̒��ŏЉ�
% ���Ă�����̂ł��B
%
% �Q�l�����FFinance and Economics Discussion Series Working 
%           Paper # 95-1, published by the Division of Research and 
%           Statistics, Division of Monetary Affairs, Federal Reserve
%           Board, Washington, D.C.
%
%
%         ���̊֐��̎��s�ɂ̓X�v���C���c�[���{�b�N�X���K�v�ł��B
%
% �Q�l : ZBTPRICE, ZBTYIELD, ZERO2FWD, FWD2ZERO, ZERO2DISC, DISC2ZERO,
%        ZERO2PYLD PYLD2ZERO.


%   Author(s): D. Eiler, 02-12-97, J. Akao 12/01/97
%   Copyright 1995-2002 The MathWorks, Inc.  
