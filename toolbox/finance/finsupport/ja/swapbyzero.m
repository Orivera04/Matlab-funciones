% SWAPBYZERO   1�g�̃[���Ȑ�����ʏ�̃X���b�v�̉��i������
%
%   [Price, SwapRate] = swapbyzero(RateSpec, LegRate, Settle, Maturity)
%
%   [Price, SwapRate] = swapbyzero(RateSpec, LegRate,  Settle,....
%         Maturity, LegReset, Basis,  Principal, LegType)
%
% ����(�K�{): ���t�̓V���A���f�[�g�ԍ��A�܂��́A���t������łȂ���΂Ȃ�
% �܂���B�I�v�V�����̈����͋�s�� []�ɂ���ďȗ��ł��܂��B
%
%   RateSpec   - �N�����Z���ꂽ�[���������ԍ\��
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
%
% ����(�I�v�V����)�F
%   LegReset   - ���ꂼ��̃X���b�v�ɂ��ĔN�ɉ��񌈍ς��s���邩��
%                ����NINST�s2��̍s��ł��B�f�t�H���g�� [1 1] �ł��B
%   Basis      - ���͂��ꂽ�t�H���[�h�����c���[�̕��͂ɓK�p����������
%                �J�E���g�������NINST�s1��̃x�N�g���ł��B�f�t�H���g
%                ��0 (actual/actual)
%   Principal  - �z�茳�{(���ڌ��{)������NINST�s1��̃x�N�g���ł��B
%                �f�t�H���g��100
%   LegType    - NINST�s2��̍s��ł��B���̍s��̊e�s�́A�X���b�v���i
%                �ɑΉ����Ă���A�e��́A�Ή������Ԃ��Œ藘���A�܂���
%                �ϓ������̂�����ł���̂��������Ă��܂��B���̗�̒l��0
%                �ł���΁A�ϓ������A�l���P�ł���ΌŒ藘���ł��B�s��
%                LegRate �ɓ��͂��ꂽ�l���ǂ̂悤�ɉ�͂��邩���`����
%                ���߂ɂ��̍s��͎g�p����܂��B�f�t�H���g�ł́A�e���i��
%                ���� [1,0] �ɐݒ肳��Ă��܂��B
%
% �o��:
%   Price     - �X���b�v�̉��i����Ȃ�NINST�sNUMCURVES��̍s��ł��B
%               �s��̊e��͂��ꂼ��P�̃[���Ȑ��ɑΉ����Ă��܂��B
%
%   SwapRate  - �X���b�v�̉��i�����ώ��_�Ń[���ƂȂ�悤�ȁA�Œ藘��
%               ��ԂɓK�p�ł��闘������Ȃ�NINST�s NUMCURVES��̍s��
%               �ł��B���� LegRate �ŌŒ藘����ԂɎw�肳�ꂽ������NaN�l
%               �̏ꍇ�ɂ��̗������v�Z����A�X���b�v�̉��i����Ɏg�p
%               ����܂��B
% 
%               �N�[�|��������NaN�ɐݒ肳��Ă��Ȃ����ɂ��ẮA
%               SwapRate �ɑ΂���NaN�l��p�������������s���܂��B
%
% �Q�l : BONDBYZERO, CFBYZERO, FIXEDBYZERO, FLOATBYZERO.


%   Author(s): M. Reyes-Kattar, 02/07/2000
%   Copyright 1995-2002 The MathWorks, Inc. 
