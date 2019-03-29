%clear
%clc
%close all

%q1=89;%%%our method
%q2=89;%%%rip-1
q3=3;%%%rip2

k=23;
minTime = Inf;
n=20000;
num=100;%%%number of unknown vectors we want to test
r=3;

%B1 = DeVore_Exp(q1 , n);%%%our method
%B2 = DeVore_Exp(q2 , n);%%%rip-1
B3 = DeVore_Exp(q3 , n);%%%rip-2


%error1=zeros(num,1);%%%our method
%error2=zeros(num,1);%%%rip-1
error3=zeros(num,1);%%%rip2

%t1=zeros(num,1);%%%time elapsed,our method
%t2=zeros(num,1);%%%rip-1
t3=zeros(num,1);%%%rip2


%X=zeros(n,num);%%%unknown vector%%%comment since I'm using "our" workspace


%%%predicted vectors
%Xhat1=zeros(n,num);%%%our method
%Xhat2=zeros(n,num);%%%rip-1
Xhat3=zeros(n,num);%%%rip-2


%% our method

%  for it=1:num 
% % %%generating an unknown signal
% loc = randi(n,k,1);
% xval = 2*rand(k,1) - ones(k,1);
% x = 0*ones(n,1) ;
% x(loc) = xval ;
% X(:,it)=x; 
% % % %%%our method
% B1 = DeVore_Exp(q1 , n);
% y1 = Exp_mult(B1,x); 
% tstart = tic; 
% [xhat1,d]=MVID(y1 , q1 , n,  B1 ,k,r);%%%our algorithm without any iterations
% 
% Xhat1(:,it)=xhat1;
% t1(it) = toc(tstart);
% error1(it)=norm(x-xhat1);
% if it==num
%     figure(1);
%     stem(x)
%     hold on
%     stem(xhat1)
%     title('Real signal vs. signal predicted by OUR expander recovery algorithm')
%     xlabel('Discrete time')
%     ylabel('Signal')
%     legend('Real signal','Predicted signal')
%     figure(2);
%     stem(error1)
%     title('Error of prediction, OUR expander recovery algorithm')
%     xlabel('Discrete time')
%     ylabel('Error (signal-predicted signal)')
% end
  % end
 
%% Xu-Hassibi method
% for it=1:num
% 
% B2 = DeVore_Exp(q2 , n);
% x=X(:,it);
% y2 = Exp_mult(B2,x); 
% tstart2 = tic; 
% xhat2 = Xu_Has( y2 , q2 , n,  B2 );%%%%Xu_hassibi algorithm written by Prof.
% 
% Xhat2(:,it)=xhat2;
% t2(it) = toc(tstart2);
% error2(it)=norm(x-xhat2);
% it
% if it==num
%     figure(3);
%     stem(x)
%     hold on
%     stem(xhat2)
%     title('Real signal vs. signal predicted by expander recovery algorithm')
%     xlabel('Discrete time')
%     ylabel('Signal')
%     legend('Real signal','Predicted signal')
%     figure(4);
%     stem(error2)
%     title('Error of prediction, expander recovery algorithm')
%     xlabel('Discrete time')
%     ylabel('Error (signal-predicted signal)')
% end
% end
   
%% L-1 norm minimization
for it=1:num
%%%ell-one-norm minimization
B3 = DeVore_Exp(q3 , n ) ;
A_D = B_to_A(B3) ;
%%Set up the measurement vector
x=X(:,it);
%%added for image part
x=UU';
%%
y3 = Exp_mult(B3,x) ;
tstart3 = tic; 
cvx_begin
warning('off')
variable z(n)
minimize norm(z,1)
subject to
A_D*z == y3
cvx_end
t3(it) = toc(tstart3);

error3(it)=norm(x-z);
if it==num
    figure(5);
    stem(x)
    hold on
    stem(z)
    title('Real signal vs. signal predicted by ell-1 norm minimization')
    xlabel('Discrete time')
    ylabel('Signal')
    legend('Real signal','Predicted signal')
    figure(6);
    stem(error3)
    title('Error of prediction, ell-1 norm minimization')
    xlabel('Discrete time')
    ylabel('Error (signal-predicted signal)')
end
end