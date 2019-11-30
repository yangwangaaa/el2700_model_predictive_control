
% Figures
figure(1)
subplot(2,1,1)
plot(t.Force.Time, t.Force.Data, 'b', 'LineWidth', 2)
xticklabels({})
ylabel('$F$ [N]','Interpreter','latex')
grid on

subplot(2,1,2)
plot(t.Wind_Force.Time, t.Wind_Force.Data, 'b', 'LineWidth', 2)
ylim([0 0.05])
set(gca,'xtickMode', 'auto')
xlabel('Time [s]')
ylabel('$w$[N]', 'Interpreter','latex')
grid on

figure(2)
subplot(2,1,1)
plot(t.Position.Time, t.Position.Data,'b', 'LineWidth', 2)
ylim([-2 12])
xticklabels({})
ylabel('$x$ [m]','Interpreter','latex')
grid on

subplot(2,1,2)
plot(t.Theta.Time, t.Theta.Data, 'b', 'LineWidth', 2)
set(gca,'xtickMode', 'auto')
xlabel('Time [s]')
ylabel('$\theta$[rad]', 'Interpreter','latex')
grid on

