function [pol_pi,policyStable] = jcr_policy_improvement(pol_pi,V,gamma,Ra,Pa,Rb,Pb,max_num_cars_can_transfer)
if( nargin < 3 ) gamma = 0.9; end
% �������: 
max_n_cars = size(V,1)-1;
% �ܹ���״̬��������0����� 
nStates = (max_n_cars+1)^2; 
% assume the policy is stable (until we learn otherwise below): 
policyStable = 1; tm = NaN; 

% ����S�е�ÿ��״̬��ѭ��:
fprintf('��ʼ��������...\n'); 
for si=1:nStates, 
    % �õ�ÿ�������ĳ�����: 
    [na1,nb1] = ind2sub( [ max_n_cars+1, max_n_cars+1 ], si ); 
    na = na1-1; nb = nb1-1; % (zeros based) 
    
    % ԭʼ�Ĳ���: 
    b = pol_pi(na1,nb1);

    % ��ǰ����Ϊ�ռ䣬�����ڵ��صĳ����������Ŀ��ƶ��ĳ�����
    posA = min([na,max_num_cars_can_transfer]); 
    posB = min([nb,max_num_cars_can_transfer]); 
    % posActionsInState��ʾ��Aת�Ƶ�B�����п��ܵ������Ҳ�������ǵ���Ϊ�ռ�
    posActionsInState = [ -posB:posA ]; npa = length(posActionsInState); 
    Q = -Inf*ones(1,npa);   % ��Ϊֵ����
    tic; 
    for ti = 1:npa,
      ntrans = posActionsInState(ti);
      % ����������Ϊ�������ر�
      Q(ti) = jcr_rhs_state_value_bellman(na,nb,ntrans,V,gamma,Ra,Pa,Rb,Pb,max_num_cars_can_transfer);
    end % end ntrans 
    tm=toc; 
    
    % ���²���
    [dum,imax] = max( Q );  % �õ���Ѳ��Ե������Ͷ�Ӧ��Qֵ
    maxPosAct  = posActionsInState(imax);   % �����Ϊ
    if( maxPosAct ~= b )      % ���ԭʼ�����Ƿ����� ...
      policyStable = 0; 
      pol_pi(na1,nb1) = maxPosAct; % <- ���²���
    end
end % end state loop 
fprintf('������������...\n'); 