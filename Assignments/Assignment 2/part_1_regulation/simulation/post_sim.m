%% Retrive Data
T  = t.Cart_acceleration.Time;
x1 = t.Theta.Data;
x2 = t.Thetadot.Data;
x  = [x1'; x2'];
u  =  t.Cart_acceleration.Data;

%% Penalty matrices
Q       = diag([100,10]);
R       = 1;
[J, E]  = accumulated_cost_energy(x, u, Q, R);  

%% Plot
figure(1)
subplot(3,1,1)
plot(T, x1, 'b', 'LineWidth', 2)
xlim([0 4.8])
xticklabels({})
ylabel('$\theta$[rad]', 'Interpreter','latex')
grid on

subplot(3,1,2)
plot(T, x2, 'b', 'LineWidth', 2)
xlim([0 4.8])
xticklabels({})
ylabel('$\omega$[rad s$^{-1}$]', 'Interpreter','latex')
grid on

subplot(3,1,3)
plot(T, u, 'b', 'LineWidth', 2)
xlim([0 4.8])
set(gca,'xtickMode', 'auto')
xlabel('Time [s]')
ylabel('Cart Acceleration [m s^{-2}]')
grid on

figure(2)
subplot(2,1,1)
plot(T, E, 'b', 'LineWidth', 2)
xlim([0 4.8])
xticklabels({})
ylabel('Control Energy')
grid on

subplot(2,1,2)
plot(T, J, 'b', 'LineWidth', 2)
xlim([0 4.8])
set(gca,'xtickMode', 'auto')
xlabel('Time [s]')
ylabel('Accumulated Cost')
grid on

