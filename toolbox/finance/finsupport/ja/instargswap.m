% INSTARGSWAP   'Type','Swap' �����̌��؂��s���T�u���[�`��
%
% ���̊֐��́A�������[�`���̃g�b�v�Ŏ��s����܂��B
%
%   [LegRate, Settle, Maturity, LegReset, Basis, Principal, ...
%                LegType] = instargswap(ArgList{:})
%
% ����: 
%     ArgList{:} �o�͂�1��1�Ή��ŏ���������������͂��܂��B
%
% Outputs: �o�͓͂K������ NINST �s1��A�܂��́ANINST�s2��̃x�N�g����
%          �Ȃ�܂��B
%   LegRate    - NINST�s2��̍s��ł��B���̍s��̊e�s�͎��̂悤�ɒ�`
%                ����Ă��܂��B
%                [CouponRate Spread]�A�܂��́A[Spread CouponRate]
%                �����ŁACouponRate ��10�i���\�L�̔N���BSpread�͊����
%                �𒴂���x�[�V�X�|�C���g�̐��ł��B�ŏ��̗�͎󂯎����
%                ���(receiving leg)�A��Ԗڂ̗�͎x�������s�����
%                (paying leg)�������Ă��܂��B              
%   Settle     - �e�X���b�v�ɑ΂��錈�ϓ���\�����t��v�f�Ƃ���NINST�s
%                1��̃x�N�g��
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
%                �ϓ������̂�����ł���̂��������Ă��܂��B���̗�̒l��0
%                �ł���΁A�ϓ������A�l��1�ł���ΌŒ藘���ł��B�s��
%                LegRate�ɓ��͂��ꂽ�l���ǂ̂悤�ɉ�͂��邩���`����
%                ���߂ɂ��̍s��͎g�p����܂��B�f�t�H���g�ł́A�e���i��
%                ���� [1,0] �ɐݒ肳��Ă��܂��B
%   
% �Q�l : INSTSWAP.


%   Author(s): J. Akao, M. Reyes-Kattar 25-Apr-1999
%   Copyright 1995-2002 The MathWorks, Inc. 
