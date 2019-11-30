%% Retrive Data
T  = t.Force.Time;
X1 = t.Position.Data;
X3 = t.Theta.Data*180/pi;
u  = t.Force.Data;
w  = t.Wind_Force.Data;

%% Plot
figure(1)
subplot(2,1,1)
plot(T, X1, 'b', 'LineWidth', 2)
xticklabels({})
ylabel('$x$[m]', 'Interpreter','latex')
grid on
 
subplot(2,1,2)
plot(T, X3, 'b', 'LineWidth', 2)
set(gca,'xtickMode', 'auto')
xlabel('Time [s]')
ylabel('$\theta[^\circ]$', 'Interpreter','latex')
grid on

figure(2)
subplot(2,1,1)
plot(T, u, 'b', 'LineWidth', 2)
xticklabels({})
ylabel('$F$[N]', 'Interpreter','latex')
grid on
 
subplot(2,1,2)
plot(T, w, 'b', 'LineWidth', 2)
ylim([0 0.05])
set(gca,'xtickMode', 'auto')
xlabel('Time [s]')
ylabel('$w$[N]', 'Interpreter','latex')
grid on

%% Performance of the estimator
if Type == 2
    run('plot_rmse.m')
end
