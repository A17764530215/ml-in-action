function [V] = jcr_policy_evaluation(V,pol_pi,gamma,Ra,Pa,Rb,Pb,max_num_cars_can_transfer)

if( nargin < 3 ) gamma = 0.9; end
  
% ÿ���ط����������: 
max_n_cars = size(V,1)-1;
% ���е�״̬�������һά�����: 
nStates = (max_n_cars+1)^2; 
% ���������趨����Ҫ�ǵ������͵�������
MAX_N_ITERS = 100; iterCnt = 0; 
CONV_TOL    = 1e-6;  delta = +inf;  tm = NaN; 

fprintf('beginning policy evaluation ... \n'); 
% ������ε���ֵ�����Ĳ�ֵ������ֵ�ҵ�������û�г������ޣ���һֱ����
while( (delta > CONV_TOL) && (iterCnt <= MAX_N_ITERS) ) 
  delta = 0; 
  % ����ÿһ��״̬s \in {S}�����ĸ���ֵ:
  for si=1:nStates, 
    % ind2sub������һά������ֵת��Ϊ��ά�ģ������ض�Ӧ�Ķ�ά�����±꣬������Ƿ���a,b�ĳ�����: 
    [na1,nb1] = ind2sub( [ max_n_cars+1, max_n_cars+1 ], si ); 
    na = na1-1; nb = nb1-1; % (��0��ʼ) 
    % ����ǰ��ֵ 
    v = V(na1,nb1); 
    % ���ݵ�ǰ���Ժ�״̬ȷ��ת�Ƶĳ�����������Ϊ�� 
    ntrans = pol_pi(na1,nb1); 
    % ���ݱ��������̼��㵱ǰ�ĸ���ֵ���ؼ���һ��
    V(na1,nb1) = jcr_rhs_state_value_bellman(na,nb,ntrans,V,gamma,Ra,Pa,Rb,Pb,max_num_cars_can_transfer);
    delta = max( [ delta, abs( v - V(na1,nb1) ) ] ); 
  end % end state loop 
    
  iterCnt=iterCnt+1; 
  % ��ӡ��ǰ��step����Ӧ�����delta 
  if( 1 && mod(iterCnt,1)==0 )
    fprintf( 'iterCnt=%5d; delta=%15.8f\n', iterCnt, delta );  
  end
end  
fprintf('ended policy evaluation ... \n'); 