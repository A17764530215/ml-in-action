
%% ��������ģ��
% һ������������ϵļ�ʾ��
mu = @(x) -1.9+.23*x;   % ������ʵ����Ϸ��̣�ϵ���ֱ��ǣ�-1.9��.23
x = 5:.1:15;    % ����������
yhat = mu(x);   % ��Ӧֵ

% ����Ĵ�������X��ĳ���㴦������һ����˹ģ�ͣ�����������PDF
% dy��y�ı仯��Χ��k����λ��
dy = -3.5:.1:3.5; sz = size(dy); k = (length(dy)+1)/2;
% x1�ǽضϵ㣬z1��ʾ��x1����y1ȡ��ֵͬ�ĸ���
x1 =  7*ones(sz); y1 = mu(x1)+dy; z1 = normpdf(y1,mu(x1),1);
x2 = 10*ones(sz); y2 = mu(x2)+dy; z2 = normpdf(y2,mu(x2),1);
x3 = 13*ones(sz); y3 = mu(x3)+dy; z3 = normpdf(y3,mu(x3),1);
line = plot3(x,yhat,zeros(size(x)),'b-', ...
      x1,y1,z1,'r-', x1([k k]),y1([k k]),[0 z1(k)],'r:', ...
      x2,y2,z2,'r-', x2([k k]),y2([k k]),[0 z2(k)],'r:', ...
      x3,y3,z3,'r-', x3([k k]),y3([k k]),[0 z3(k)],'r:');
set(line, 'LineWidth', 1.5);
zlim([0 1]);
xlabel('X'); ylabel('Y'); zlabel('�����ܶ�');
grid on; view([-45 45]);
set(gcf, 'Position', [100 100 400 300]);

%%
% ����ϵĺ�����ָ����ʽ������link����log����
mu = @(x) exp(-1.9+.23*x);
% �������ݼ�
x = 5:.1:15;
yhat = mu(x);
% ��x=7,10,13����y�ֱ�ȡ��ͬ��ֵ���������ǵĲ��ɷֲ�����
% poisspdf(k, lambda)��ʾy=k,����Ϊlambdaʱ�ĸ���
x1 =  7*ones(1,5);  y1 = 0:4; z1 = poisspdf(y1,mu(x1));
x2 = 10*ones(1,7); y2 = 0:6; z2 = poisspdf(y2,mu(x2));
x3 = 13*ones(1,9); y3 = 0:8; z3 = poisspdf(y3,mu(x3));
line = plot3(x,yhat,zeros(size(x)),'b-', ...
      [x1; x1],[y1; y1],[z1; zeros(size(y1))],'r-', x1,y1,z1,'r.', ...
      [x2; x2],[y2; y2],[z2; zeros(size(y2))],'r-', x2,y2,z2,'r.', ...
      [x3; x3],[y3; y3],[z3; zeros(size(y3))],'r-', x3,y3,z3,'r.');
zlim([0 1]);
xlabel('X'); ylabel('Y'); zlabel('����');
grid on; view([-45 45]);
set(line, 'LineWidth', 1.5);
set(gca, 'FontSize', 9);
set(gcf, 'Position', [100 100 350 250]);
%% Fitting a Logistic Regression

% һϵ�в�ͬ�����ĳ�
weight = [2100 2300 2500 2700 2900 3100 3300 3500 3700 3900 4100 4300]';
% �����������͵ĳ�����Ŀ
tested = [48 42 31 34 31 21 23 23 21 16 17 21]';
% ÿ�������ĳ����ڲ�����fail������Ŀ
failed = [1 2 0 3 8 8 14 17 19 15 17 21]';
% ������
proportion = failed ./ tested;

plot(weight,proportion,'sb')
xlabel('����'); ylabel('����');
set(gcf, 'Position', [100 100 350 280]);
set(gca, 'FontSize', 9);
%%

% �������.
% polyfit)x,y,n)ִ�ж���ʽ��ϣ�n�������ʽ��������n=1ʱ���������Թ�ϵ�����ض���ʽϵ��
linearCoef = polyfit(weight,proportion,1);  
% value = polyval(p, x)���ض���ʽ��ֵ��p�Ƕ���ʽ��ϵ������������
linearFit = polyval(linearCoef,weight);
line = plot(weight,proportion,'s', weight,linearFit,'r-', [2000 4500],[0 0],'k:', [2000 4500],[1 1],'k:')
xlabel('����'); ylabel('����');
set(gcf, 'Position', [100 100 350 280]);
set(gca, 'FontSize', 9);
set(line, 'LineWidth', 1.5)
%%
% ����ʽ���
% ��δ����������ϵĺ����ƣ��������������ѡ��3�׶���ʽ�����ص�stats��һ���ṹ�壬��Ϊpolyval����������
% �����������ƣ�ctr�����˾�ֵ�ͷ�������ڶ�����x��һ��
[cubicCoef,stats,ctr] = polyfit(weight,proportion,3);
cubicFit = polyval(cubicCoef,weight,[],ctr);    % ���ù�һ����weight���ж���ʽ���
line = plot(weight,proportion,'s', weight,cubicFit,'r-', [2000 4500],[0 0],'k:', [2000 4500],[1 1],'k:')
xlabel('����'); ylabel('����');
set(gcf, 'Position', [100 100 350 280]);
set(gca, 'FontSize', 9);
set(line, 'LineWidth', 1.5)
%%
% However, this fit still has similar problems.  The graph shows that the
% fitted proportion starts to decrease as weight goes above 4000; in fact
% it will become negative for larger weight values.  And of course, the
% assumption of a normal distribution is still violated.
%
% Instead, a better approach is to use |glmfit| to fit a logistic
% regression model.  Logistic regression is a special case of a generalized
% linear model, and is more appropriate than a linear regression for these
% data, for two reasons.  First, it uses a fitting method that is
% appropriate for the binomial distribution.  Second, the logistic link
% limits the predicted proportions to the range [0,1].
%
% For logistic regression, we specify the predictor matrix, and a matrix
% with one column containing the failure counts, and one column containing
% the number tested.  We also specify the binomial distribution and the
% logit link.

% ����glmfit��ϣ���glmfit��һ��response��һ�������������ǵ��ֲ��Ƕ���ֲ���ʱ��
% y������һ����ֵ��������ʾ���ι۲��гɹ�����ʧ�ܣ�Ҳ������һ�����еľ��󣬵�һ��
% ��ʾ�ɹ��Ĵ�����Ŀ����ֵĴ��������ڶ��б�ʾ�ܹ��Ĺ۲�������������y = [failed, tested]
% ����ָ��distri='binomial', link='logit'
[logitCoef,dev] = glmfit(weight,[failed tested],'binomial','logit');
% glmval���ڲ�����ϵ�ģ�ͣ���������Ƶ�yֵ
logitFit = glmval(logitCoef,weight,'logit');
line = plot(weight,proportion,'bs', weight,logitFit,'r-');
xlabel('����'); ylabel('����');
set(gcf, 'Position', [100 100 350 280]);
set(gca, 'FontSize', 9);
set(line, 'LineWidth', 1.5)
legend('����', 'logistic�ع�')
%%
% As this plot indicates, the fitted proportions asymptote to zero and one
% as weight becomes small or large.


%% Model Diagnostics
% The |glmfit| function provides a number of outputs for examining the fit
% and testing the model.  For example, we can compare the deviance values
% for two models to determine if a squared term would improve the fit
% significantly.
[logitCoef2,dev2] = glmfit([weight weight.^2],[failed tested],'binomial','logit');
pval = 1 - chi2cdf(dev-dev2,1)

%%
% The large p-value indicates that, for these data, a quadratic term does
% not improve the fit significantly.  A plot of the two fits shows there is
% little difference in the fits.
logitFit2 = glmval(logitCoef2,[weight weight.^2],'logit');
plot(weight,proportion,'bs', weight,logitFit,'r-', weight,logitFit2,'g-');
legend('Data','Linear Terms','Linear and Quadratic Terms','Location','northwest');

%%
% To check the goodness of fit, we can also look at a probability plot of
% the Pearson residuals.  These are normalized so that when the model is a
% reasonable fit to the data, they have roughly a standard normal
% distribution. (Without this standardization, the residuals would have
% different variances.)
[logitCoef,dev,stats] = glmfit(weight,[failed tested],'binomial','logit');
normplot(stats.residp);

%%
% The residual plot shows a nice agreement with the normal distribution.


%% Evaluating the Model Predictions
% Once we are satisfied with the model, we can use it to make predictions,
% including computing confidence bounds.  Here we predict the expected
% number of cars, out of 100 tested, that would fail the mileage test at
% each of four weights.
% ģ����ϣ�����stats��һ���ṹ��
[logitCoef,dev,stats] = glmfit(weight,[failed tested],'binomial','logit');
normplot(stats.residp);
% ����������ĸ����͵ĳ��������ֱ���2500��4000
weightPred = 2500:500:4000;
% logitCoef����ϳ���ģ�͵�ϵ����failedPred��Ԥ����ϵĳ�������dlo��dhi�ֱ���95%
% ������������޺�����
[failedPred,dlo,dhi] = glmval(logitCoef,weightPred,'logit',stats,.95,100);
line = errorbar(weightPred,failedPred,dlo,dhi,'r:');
set(gcf, 'Position', [100 100 300 250]);
set(gca, 'FontSize', 9);
set(line, 'LineWidth', 1.5)
grid on
axis tight
%% Link Functions for Binomial Models
% For each of the five distributions that |glmfit| supports, there is a
% canonical (default) link function.  For the binomial distribution, the
% canonical link is the logit.  However, there are also three other links
% that are sensible for binomial models.  All four maintain the mean
% response in the interval [0, 1].
eta = -5:.1:5;
plot(eta,1 ./ (1 + exp(-eta)),'-', eta,normcdf(eta), '-', ...
     eta,1 - exp(-exp(eta)),'-', eta,exp(-exp(eta)),'-');
xlabel('Linear function of predictors'); ylabel('Predicted mean response');
legend('logit','probit','complementary log-log','log-log','location','east');

%%
% For example, we can compare a fit with the probit link to one with the
% logit link.
probitCoef = glmfit(weight,[failed tested],'binomial','probit');
probitFit = glmval(probitCoef,weight,'probit');
plot(weight,proportion,'bs', weight,logitFit,'r-', weight,probitFit,'g-');
legend('Data','Logit model','Probit model','Location','northwest');

%%
% It's often difficult for the data to distinguish between these four
% link functions, and a choice is often made on theoretical grounds.
