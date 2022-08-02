% INSTSWAP   'Swap' �^�C�v�̏��i���쐬����֐�
%
% �V�������i�ϐ����f�[�^�z�񂩂琶������ɂ́A���̂悤�ɐݒ肵�܂��B
%   ISet = instswap(LegRate, Settle, Maturity, LegReset, Basis, ....
%           Principal, LegType)
%
% 'Swap'���i�����i�ϐ��ɒǉ�����ɂ́A���̂悤�ɐݒ肵�܂��B
%   ISet = instswap(ISet, LegRate, Settle, Maturity, LegReset, ....
%          Basis, Principal, LegType)
%
% 'Swap'���i�̃t�B�[���h���^�f�[�^�����X�g�\������ɂ́A���̂悤�ɐݒ�
% ���܂��B
%
%   [FieldList, ClassList, TypeString] = instswap;
%
% ���́F �f�[�^������NINST�s�P��̃x�N�g���A�܂��́ANINST�s2��̃x�N�g��
%        �X�J���A�܂��́A��̂����ꂩ����͂ł��܂��B�x�N�g�����̎w���
%        �Ȃ����͂ɂ��ẮANaN �l�����͂���܂��B���i�̐����ɂ͂�����
%        1�̃f�[�^�������K�v�Ƃ���A���̃f�[�^�����͍폜�A�܂��́A��s
%        �� []�Ƃ��ďȗ�����܂��B�S�Ă̓��͂́A���̓f�[�^�̃N���X�ɉ���
%        �āAFINARGPARSE �ɂ���āA���߂���܂��B�f�[�^�̃N���X���Q�Ƃ�
%        ��ɂ́A"[FieldList, ClassList] = instswap " �ƃ^�C�v���Ă�����
%        ���B�܂��A���t�ɂ��ẮA�V���A�����t�ԍ��A�܂��́A���t������
%        �œ��͂��Ă��������B
%
%   LegRate    - NINST�s2��̍s��ł��B���̍s��̊e�s�͎��̂悤�ɒ�`
%                ����Ă��܂��B
%                [CouponRate Spread]�A�܂��́A[Spread CouponRate]
%                ������CouponRate ��10�i���\�L�̔N���BSpread�͊������
%                ������x�[�V�X�|�C���g�̐��ł��B�ŏ��̗�͎󂯎����
%                ���(receiving leg)�A��Ԗڂ̗�͎x�������s�����
%                (paying leg)�������Ă��܂��B              
%   Settle     - �t���A�̌��ϓ����������t������A�܂��́A�V���A�����t
%                �ԍ�
%   Maturity   - �X���b�v�̖�����������NINST�s1��̃x�N�g���ł��B
%   LegReset   - ���ꂼ��̃X���b�v�ɂ��ĔN�ɉ��񌈍ς��s���邩��
%                ���� NINST �s2��̍s��ł��B�f�t�H���g��[1 1]�ł��B
%   Basis      - ���͂��ꂽ�t�H���[�h�����c���[�̕��͂ɓK�p����������
%                �J�E���g�������NINST�s1��̃x�N�g���ł��B�f�t�H���g
%                ��0 (actual/actual)
%   Principal  - �z�茳�{(���ڌ��{)������NINST�s1��̃x�N�g���ł��B
%                �f�t�H���g��100
%   LegType    - NINST�s2��̍s��ł��B���̍s��̊e�s�́A�X���b�v���i
%                �ɑΉ����Ă���A�e��́A�Ή������Ԃ��Œ藘���A�܂���
%                �ϓ������̂�����ł���̂��������Ă��܂��B���̗�̒l��
%                0�ł���΁A�ϓ������A�l��1�ł���ΌŒ藘���ł��B�s��
%                LegRate�ɓ��͂��ꂽ�l���ǂ̂悤�ɉ�͂��邩���`����
%                ���߂ɂ��̍s��͎g�p����܂��B�f�t�H���g�ł́A�e���i��
%                ���� [1,0] �ɐݒ肳��Ă��܂��B
%
% �o��:
%   ISet       - ���i�̏W������Ȃ�ϐ��B���i�́A�^�C�v���ɕ��ނ���A
%                ���̂��ꂼ��̃^�C�v�ɂ��Č݂��ɈقȂ�f�[�^�t�B�[���h
%                ��ݒ肷�邱�Ƃ��ł��܂��B�L�����ꂽ�f�[�^�t�B�[���h��
%                ���i�̂��ꂼ��ɑΉ�����s�x�N�g���A�܂��́A�������
%                �Ȃ��Ă��܂��B�ϐ� ISet �Ɋւ���ڍׂɂ��ẮA
%                "help instget" �ƃ^�C�v���Ă��������B
% 
%   FieldList  - ���̏��i�^�C�v�ɓK�p�����f�[�^�t�B�[���h�̖��̂����X
%                �g�\�����镶����ō\������� NFIELDS �s1��̃Z���z��B
%
%   ClassList  - �e�t�B�[���h�̃f�[�^�N���X���L�ڂ��镶���񂩂�Ȃ� 
%                NFIELDS �s 1 ��̃Z���z��A�����ɋL�ڂ����f�[�^�N���X
%                �ɂ���āA�����̉��ߖ@�����肳��܂��B���͉\�Ȉ����́A
%                'dble', 'date',  'char'�ł��B 
% 
%   TypeString - �ǉ�����鏤�i�̃^�C�v���w�肷�镶����ł��B
%                TypeString = 'Swap'.
%
% �Q�l : INSTBOND, INSTCAP, INSTFLOOR, INSTADDFIELD, INSTDISP, 
%        INTENVPRICE, HJMPRICE


%   Author(s): M. Reyes-Kattar 03/10/99
%   Copyright 1995-2002 The MathWorks, Inc. 
