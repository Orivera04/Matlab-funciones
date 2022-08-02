% INSTBOND   'Bond'�^�C�v ���i�̍쐬�֐�
%
% �f�[�^�z�񂩂�V�������i�ϐ��𐶐�����ɂ́A���̂悤�ɐݒ肵�܂��B
%   ISet = instbond(CouponRate, Settle, Maturity, ...
%             Period, Basis, EndMonthRule, ...
%             IssueDate, FirstCouponDate, LastCouponDate, ...
%             StartDate, Face)
%
%    'Bond' ���i�����i�ϐ��ɒǉ�����ɂ́A���̂悤�ɐݒ肵�܂��B
%   ISet = instbond(ISet, CouponRate, Settle, Maturity, ...
%             Period, Basis, EndMonthRule, ...
%             IssueDate, FirstCouponDate, LastCouponDate, ...
%             StartDate, Face)
%
% ���i�ɓK�p�����t�B�[���h���^�f�[�^�����X�g�\������ɂ́A���̂悤��
% �ݒ肵�܂��B
% 
%   [FieldList, ClassList, TypeString] = instbond;
%
% ����: 
% �f�[�^�����ɂ́ANINST �s1��̃x�N�g���A�X�J���A�܂��́A��̂����ꂩ��
% ���͂ł��܂��B�x�N�g�����̎w��̂Ȃ����͂ɂ��ẮANaN �l�����͂���
% �܂��B���i�̐����ɂ́A������1�̃f�[�^�������K�v�Ƃ���A���̃f�[�^
% �����͍폜�A�܂��́A��s�� []�Ƃ��ďȗ�����܂��B�S�Ă̓��͂́A����
% �f�[�^�̃N���X�ɉ����āAFINARGPARSE �ɂ���ĉ��߂���܂��B�f�[�^��
% �N���X���Q�Ƃ���ɂ́A"[FieldList, ClassList] = instbond " �ƃ^�C�v
% ���Ă��������B�Ȃ��A���t�ɂ��ẮA�V���A�����t�ԍ��A�܂��́A���t
% ������œ��͂��Ă��������BSIA �m�藘�t�،��̈����Ɋւ���ڍׂɂ��ẮA
% "help ftb" �ƃ^�C�v���Ă��������B
%
%         CouponRate      - 10�i�@�\�L�ł̃N�[�|�����[�g
%         Settle          - ���ϓ�
%         Maturity        - ������
%         Period          - �N������̃N�[�|���x������(�f�t�H���g��2)
%         Basis           - �����J�E���g��B�f�t�H���g��0 
%                           (actual/actual)
%         EndMonthRule    - �������[���B�f�t�H���g��1(�������[���͗L��)
%         IssueDate       - ���̔��s��
%         FirstCouponDate - �s����A�܂��́A�ʏ�̑���N�[�|���x����
%         LastCouponDate  - �s����A�܂��́A�ʏ�̍ŏI�N�[�|���x����
%         StartDate       - �x������O�����ăX�^�[�g��������t(2.0�ł�
%                           ���̈����̓��͖͂�������܂�)�B
%         Face            - ���̊z�ʉ��l�B�f�t�H���g��100�ł��B
%   
% �o��:
%   ISet        - ���i�̏W������Ȃ�ϐ��B���i�́A�^�C�v���ɕ��ނ���A
%                 ���̂��ꂼ��̃^�C�v�ɂ��Č݂��ɈقȂ�f�[�^�t�B�[���h
%                 ��ݒ肷�邱�Ƃ��ł��܂��B�L�����ꂽ�f�[�^�t�B�[���h��
%                 ���i�̂��ꂼ��ɑΉ�����s�x�N�g���A�܂��́A�������
%                 �Ȃ��Ă��܂��B�ϐ�ISet�Ɋւ���ڍׂɂ��ẮA
%                 "help instget" �ƃ^�C�v���Ă��������B
% 
%   FieldList   - ���̏��i�^�C�v�ɓK�p�����f�[�^�t�B�[���h�̖��̂����X
%                 �g�\�����镶����ō\������� NFIELDS �s1��̃Z���z��B
%   ClassList   - �e�t�B�[���h�̃f�[�^�N���X���L�ڂ��镶���񂩂�Ȃ� 
%                 NFIELDS�s1��̃Z���z��A�����ɋL�ڂ����f�[�^�N���X��
%                 ����āA�����̉��ߖ@�����肳��܂��B���͉\�Ȉ����́A
%                 'dble', 'date',  'char' �ł��B 
%   TypeString  - �ǉ�����鏤�i�̃^�C�v���w�肷�镶����ł��B
%                  TypeString = 'Bond'.
%
%
% �Q�l : INSTADDFIELD, INSTGET, INSTDISP, INTENVPRICE, HJMPRICE.


%   Copyright 1995-2002 The MathWorks, Inc. 
