%% Plot response
figure('Name','Pendulum stabilization', 'Position', [150 150 900 600])

subplot(3,1,1)
plot(t.Theta.Time, t.Theta.Data, 'LineWidth', 2)
hold on
plot(t.Theta.Time([1,end]), [-pi/4,-pi/4], 'r--')
plot(t.Theta.Time([1,end]), [pi/4,pi/4], 'r--')
title('Pendulum Angle')
ylabel('Angle [rad]')

subplot(3,1,2)
plot(t.Thetadot.Time, t.Thetadot.Data, 'LineWidth', 2)
hold on 
plot(t.Theta.Time([1,end]), [-pi/2,-pi/2], 'r--')
plot(t.Theta.Time([1,end]), [pi/2,pi/2], 'r--')
title('Pendulum Angular rate')
ylabel('Angle rate [rad/s]')

subplot(3,1,3)
plot(t.Cart_acceleration.Time, t.Cart_acceleration.Data, 'LineWidth', 2)
hold on
plot(t.Theta.Time([1,end]), [-5,-5], 'r--')
plot(t.Theta.Time([1,end]), [5,5], 'r--')
title('Cart Acceleration')
xlabel('Time [s]')
ylabel('Acceleration [m/s^2]')

