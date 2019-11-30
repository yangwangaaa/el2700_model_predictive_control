% Did the pendulum fall over during the simulation? 
fallen = t.PendulumFallen(1);
if fallen
    fprintf("WARNING: The control failed and the pendulum fell over at time = %f\n", t.PendulumFallen(2))
end


%% Plot
figure('Name','Pendulum state', 'Position', [150 150 900 600])

subplot(2,2,1)
plot(t.X.Time, t.X.Data(:,1), 'LineWidth', 2)
xticklabels({})
xlabel('Time [s]')
ylabel('Distance [m]')
title("Pendulum position")
grid on
 
subplot(2,2,2)
plot(t.X.Time, t.X.Data(:,2), 'LineWidth', 2)
hold on
plot(t.X.Time([1, end]), [-5, -5], 'r--', 'LineWidth', 2)
plot(t.X.Time([1, end]), [5, 5], 'r--', 'LineWidth', 2)
hold off
xticklabels({})
xlabel('Time [s]')
ylabel('Velocity [m/s]')
title("Pendulum velocity")
grid on

subplot(2,2,3)
plot(t.X.Time, t.X.Data(:,3)*(180/pi), 'LineWidth', 2)
hold on
plot(t.X.Time([1, end]), [-10, -10], 'r--', 'LineWidth', 2)
plot(t.X.Time([1, end]), [10, 10], 'r--', 'LineWidth', 2)
hold off
set(gca,'xtickMode', 'auto')
xlabel('Time [s]')
ylabel('Angle [deg]')
title("Pendulum angle")
grid on

subplot(2,2,4)
plot(t.X.Time, t.X.Data(:,4)*(180/pi), 'LineWidth', 2)
hold on
plot(t.X.Time([1, end]), [-90, -90], 'r--', 'LineWidth', 2)
plot(t.X.Time([1, end]), [90, 90], 'r--', 'LineWidth', 2)
hold off
set(gca,'xtickMode', 'auto')
xlabel('Time [s]')
ylabel('Anglular velocity [deg/s]')
title("Pendulum Angle Rate")
grid on

figure('Name','Pendulum input and disturbance', 'Position', [150 150 900 600])
subplot(2,1,1)
plot(t.Force.Time, t.Force.Data, 'LineWidth', 2)
hold on
plot(t.X.Time([1, end]), [-5, -5], 'r--', 'LineWidth', 2)
plot(t.X.Time([1, end]), [5, 5], 'r--', 'LineWidth', 2)
hold off
xticklabels({})
xlabel('Time [s]')
ylabel('Force [N]')
grid on
title("Pendulum control input")
 
subplot(2,1,2)
plot(t.Wind_Force.Time, t.Wind_Force.Data, 'LineWidth', 2)
set(gca,'xtickMode', 'auto')
xlabel('Time [s]')
ylabel('Force [N]')
grid on
title("Wind disturbance")
