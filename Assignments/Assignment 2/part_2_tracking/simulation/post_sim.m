%% Retrive Data
T  = t.Force.Time;
X1 = t.Position.Data;
X3 = t.Theta.Data;
u  = t.Force.Data;

%% Plot
figure
subplot(3,1,1)
plot(T, X1, 'b', 'LineWidth', 2)
xticklabels({})
ylabel('$x$[m]', 'Interpreter','latex')
grid on

subplot(3,1,2)
plot(T, X3, 'b', 'LineWidth', 2)
xticklabels({})
ylabel('$\theta$[rad]', 'Interpreter','latex')
grid on

subplot(3,1,3)
plot(T, u, 'b', 'LineWidth', 2)
set(gca,'xtickMode', 'auto')
xlabel('Time [s]')
ylabel('F [N]')
grid on
