% PLOTBINTREE   2���Č����c���[�̃m�[�h�̃v���b�g
%
% ���̃c���[�́A�s��̏�O�p���ɋL������A�s�ɂ͎��s����鎞�ԁA��ɂ�
% ���s������Ԃ��L������Ă��܂��B���g�p�̃m�[�h���}�X�N���� NaN ����
% ���A���̃c���[�̒l�ɂ͊܂܂�Ă��܂��B
%
%   plotbintree(TreeMat, TreeTimes)
%
% ����:
%   TreeMat   :NSTATES �s NTIMES ��̍s��́A�S�Ă̎��ԁA��Ԃɂ�����
%              �c���[��� Y �l����O�p���ɋL�������s��ł��B
%   TreeTimes :1�s NTIMES ��̃x�N�g���́A�m�[�h�� X �l���܂ރx�N�g����
%              ���BTreeTimes ���A[] �A�܂��́A�����͂̏ꍇ�A1���� Ntimes
%              �܂ł̎��Ԃ��ݒ肳��܂��B
%
% ���:
%   [PriceTree] = binprice(52,50,.1,5/12,1/12,.4,0,0,2.06,3.5)
%
%   PriceTree = 
% 
%     52.0000   58.1367   65.0226   72.7494   79.3515   89.0642 
%           0   46.5642   52.0336   58.1706   62.9882   70.6980 
%           0         0   41.7231   46.5981   49.9992   56.1192 
%           0         0         0   37.4120   39.6887   44.5467 
%           0         0         0         0   31.5044   35.3606 
%           0         0         0         0         0   28.0688 
%
%   plotbintree(PriceTree, (0:5)/12)


%       Author(s): J. Akao 18-May-1998
%       Copyright 1995-2002 The MathWorks, Inc.  
