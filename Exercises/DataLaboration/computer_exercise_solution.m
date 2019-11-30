clear all; close all; clc; 

%% Initialization

A=[1 1; 2 0]; 

B=[0;1];

Q1=eye(2); Qf=Q1; Q2=1;

Nsim=20;


%% PART A

N=15;


P{N+1}=Qf;

   
%Ricatti
for t=N+1:-1:2

    P{t-1} = Q1+A'*P{t}*A - A'*P{t}*B*inv(Q2 + B'*P{t}*B)*B'*P{t}*A;

    p11(t-1) = P{t-1}(1,1); 

    p12(t-1) = P{t-1}(1,2);

    p21(t-1) = P{t-1}(2,1);

    p22(t-1) = P{t-1}(2,2);
    
end

Lmat=[];
M=eye(2);


% Gain
for t=1:1:N

    L{t}= inv(Q2 + B'*P{t}*B)*B'*P{t}*A;
    
    Lmat=[Lmat; -L{t}*M];
    
    M=(A-B*L{t})*M;

    l11(t) = L{t}(1,1);
    l12(t) = L{t}(1,2);
end


x0=[1;1];

u_ricatti=Lmat*x0;


%% PART B
p11(N+1) = P{N+1}(1,1); 
p12(N+1) = P{N+1}(1,2);
p21(N+1) = P{N+1}(2,1);
p22(N+1) = P{N+1}(2,2);

for t=N+1:-1:2

    p11(t-1) = P{t-1}(1,1); 

    p12(t-1) = P{t-1}(1,2);

    p21(t-1) = P{t-1}(2,1);

    p22(t-1) = P{t-1}(2,2);
    
end


figure 
plot(p11)

figure 
plot(u_ricatti)


for t=1:1:N+1

    x{t}=sdpvar(2,1);
    
    u{t}=sdpvar(1,1);
end

cost=0; constraints=[x{1}==x0];

for t=1:1:N
    
    cost=cost+x{t}'*Q1*x{t} + u{t}'*Q2*u{t};
    
    constraints=[constraints, x{t+1}==A*x{t}+B*u{t}];
    
end

constraints=[constraints, u{N+1}==0];

cost=cost+x{N+1}'*Qf*x{N+1};

optimize(constraints, cost);

u_qp=[];

for t=1:1:N

    u_qp=[u_qp; value(u{t})];

end
u_qp

% Compare the control sequences
figure
hold on
plot(u_qp,'linewidth',2)
plot(u_ricatti,'--','linewidth',2)

% Compare the control sequences
figure
subplot(2,1,1)
hold on
plot(u_qp,'linewidth',2)
ylabel('u_{qp}')
xlabel('k')

subplot(2,1,2)
hold on
plot(u_ricatti,'linewidth',2)
ylabel('u_{ricatti}')
xlabel('k')

 %%
 % Simulate the system
 xsim{1}=x0;
 for t=1:1:N
     
     xsim{t+1}=A*xsim{t}+B*value(u{t});
 
 end
 
 % Validate that the first N components agree with the prediction equations
 for t=1:1:N
     
     diffx(:,t)=xsim{t}-value(x{t});
     
 end
 
figure
subplot(2,1,1)
hold on
plot(diffx(1,:),'linewidth',2)
ylabel('Difference x_1')
xlabel('k')

subplot(2,1,2)
hold on
plot(diffx(2,:))
ylabel('Difference x_2')
xlabel('k')
 %% 
 % Simulate perturbed system
 xsim_p{1}=x0;
 
 Ap=[1 1.25; 1.75 0];
 
 Bp=B;
 
 for t=1:1:N
     
     xsim_p{t+1}=Ap*xsim_p{t} + B*value(u{t});
     
 end
 
 figure
 subplot(211);
 hold on; 
 stairs(cell2mat(xsim)','linewidth',2);
 ylabel('Nominal system')
 legend('x_1','x_2')

 subplot(212);
 hold on; 
 ylabel('Perturbed system')
 stairs(cell2mat(xsim_p)','linewidth',2);
 
%% Now create optimizer object for YALMIP
clear x, u;

N=1;

for t=1:1:N+1
    
    x{t}=sdpvar(2,1);
    
    u{t}=sdpvar(1,1);
    
end

cost=0; %constraints=[x{1}==x0];

for t=1:1:N
    
    cost=cost+x{t}'*Q1*x{t} + u{t}'*Q2*u{t};
    
    constraints=[constraints, x{t+1}==A*x{t}+B*u{t}];
    
end

[K,Qf]=dlqr(A,B,Q1,Q2);

cost=cost+x{N+1}'*Qf*x{N+1};

options=sdpsettings('solver', 'gurobi');

controller=optimizer(constraints, cost, [], x{1}, u{1});

% Now simulate the nominal system
xrhc{1}=x0;
for t=1:1:Nsim
    
    urhc{t}=controller(xrhc{t});   %% Contoller performs the optimization for the current state
    
    xrhc{t+1} = A*xrhc{t}+B*urhc{t};
    
end

 


% Now simulate the perturbed system
xrhc_p{1}=x0;
for t=1:1:Nsim
    
    urhc_p{t}=controller(xrhc_p{t})
    
    xrhc_p{t+1} = Ap*xrhc_p{t}+Bp*urhc_p{t};
    
end


figure
subplot(211);
hold on; 
stairs(cell2mat(xrhc_p)','linewidth',2);
ylabel('Nominal system')
legend('x_1','x_2')

subplot(212);
hold on; 
ylabel('Perturbed system')
stairs(cell2mat(xrhc_p)','linewidth',2);


