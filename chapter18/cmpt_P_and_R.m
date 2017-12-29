function [R,P] = cmpt_P_and_R(lambdaRequests,lambdaReturns,max_n_cars,max_num_cars_can_transfer)
% ���ڼ���ر���ת�Ƹ���
if( nargin==0 )
  lambdaRequests=4; 
  lambdaReturns=2; 
  max_n_cars=20; 
  max_n_cars_can_transfer=5; 
end

PLOT_FIGS=0;        % �Ƿ�ͼ
% ÿ����˾�������Ͽ��ܵĳ�����Ŀ 
nCM = 0:(max_n_cars+max_num_cars_can_transfer);
% ����ƽ���ر�
R = zeros(1,length(nCM));
% ÿ���ط�������͵��صĳ������йأ���ÿ���ط����ϵĳ�����������25����26��״̬������ÿ��״̬��һ�������ر�
for n = nCM,
    tmp = 0.0;
     % ���س�����������ʵ���Ͽ������κ���Ȼ�������ǵ�����ƫ��ƽ������̫��ʱ�����ʻ���Ϊ0���������ȡ��30
    for nreq = 0:(10*lambdaRequests),
      for nret = 0:(10*lambdaReturns), % <- a value where the probability of returns is very small.
          % ���㵱��ÿ��������ȥ�����ĸ���
        tmp = tmp + 10*min(n+nret,nreq)*poisspdf( nreq, lambdaRequests )*poisspdf( nret, lambdaReturns );
      end
    end
    R(n+1) = tmp;
end


if( PLOT_FIGS ) 
  figure; plot( nCM, R, 'x-' ); grid on; axis tight; 
  xlabel(''); ylabel(''); drawnow; 
end

% P��ʾת�Ƹ��ʣ� 
P = zeros(length(nCM),max_n_cars+1); 
for nreq = 0:(10*lambdaRequests), 
  reqP = poisspdf( nreq, lambdaRequests ); 
  % ���й黹�����Ŀ������:
  for nret = 0:(10*lambdaReturns), 
    retP = poisspdf( nret, lambdaReturns ); 
    % ÿ���糿���ܳ��ֳ����������: 
    for n = nCM,
      sat_requests = min(n,nreq); 
      new_n = max( 0, min(max_n_cars,n+nret-sat_requests) );
      P(n+1,new_n+1) = P(n+1,new_n+1) + reqP*retP;
    end
  end
end
if( PLOT_FIGS ) 
  figure; imagesc( 0:max_n_cars, nCM, P ); colorbar; 
  xlabel('num at the end of the day'); ylabel('num in morning'); axis xy; drawnow; 
end





