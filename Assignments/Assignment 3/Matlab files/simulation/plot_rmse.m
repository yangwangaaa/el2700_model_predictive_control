%% Retrive Data
T     = t.Y_true.Time;
yt    = t.Y_true.Data;
ythat = t.Y_estimate.Data;


%% Compute root mean square error
y_err = (ythat - yt)';
N     = length(T);
SE    = 0;
for i = 1 : N
    SE = SE + y_err(:,i)'*y_err(:,i);
end
RMSE = sqrt(SE/N);
%% Plot
figure(3)
if size(yt, 2) == 1
    plot(T, yt, '--', T, ythat, 'LineWidth', 2)
    xlabel('Time [s]')
    legend('$x$', '$\hat{x}$', 'Interpreter','latex')
    text(16, -500, sprintf('RMSE=%f',RMSE))
else
    subplot(2,1,1)
    plot(T, yt(:,1),'--', T, ythat(:,1), 'LineWidth', 2)
    xticklabels({})
    legend('$x$', '$\hat{x}$', 'Interpreter','latex')
    grid on

    subplot(2,1,2)
    plot(T, yt(:,2), '--', T, ythat(:,2), 'LineWidth', 2)
    set(gca,'xtickMode', 'auto')
    xlabel('Time [s]')
    legend('$\theta$', '$\hat{\theta}$', 'Interpreter','latex')
    text(16, 0.2, sprintf('RMSE=%f',RMSE))
    grid on
end

