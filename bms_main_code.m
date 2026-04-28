% EKF Based Battery SOC Estimation
% Author: Your Name
% Project: Battery Management System

clc; clear; close all;
format long

%% Battery Parameters
capacity = 1; % Ah
dt = 01; % time step (s)
time = 0:dt:1000;
R0 = 0.015;  % Internal Resistance (Ohm)

%% Input Current (dynamic load)
f = 0.002; % Frequency
omega = 2*pi*f;
current = 3*sin(omega*time) + 0.3*randn(size(time));

%% Temperature variation (°C)
T = 25 + 5*sin(0.001*time); 

%% Initial Values
socTrue = zeros(size(time));
socTrue(1) = 100;

socEst = zeros(size(time));
socEst(1) = 100;

fault = zeros(size(time));

P = 1;        % Initial covariance
Q = 0.001;    % Process noise (tuned)
R = 0.01;     % Measurement noise (tuned)

%% Voltage Model (OCV-SOC)
ocv =@(soc, T) 3 + 1.2*(soc/100) - 0.3*(soc/100).^2 - 0.002*(T-25);

%% Storage variables
voltage_meas_store = zeros(size(time));
voltage_pred_store = zeros(size(time));

%% Initial voltage
voltage_meas_store(1) = ocv(socTrue(1), T(1)) - current(1)*R0;
voltage_pred_store(1) = ocv(socEst(1), T(1)) - current(1)*R0;

%% EKF Loop
for k = 2:length(time)

    %% TRUE SOC
    socTrue(k) = (socTrue(k-1) - (current(k)*dt)/(capacity*3600)*100);

    %% PREDICTION
    socPred = (socEst(k-1) - (current(k)*dt)/(capacity*3600)*100);

    F = 1; % Jacobian of state
    P = (F*P*F' + Q);

    %% MEASUREMENT
    voltage_meas = (ocv(socTrue(k), T(k)) - current(k)*R0 + 0.05*randn);

    %% PREDICTED VOLTAGE (SCALAR)
    voltage_pred = (ocv(socPred, T(k)) - current(k)*R0);

    %% Fault Detection
    fault(k) = abs(voltage_meas - voltage_pred) > 0.2;

    if abs(voltage_meas - voltage_pred) > 0.2
    disp(['Fault detected at t = ', num2str(time(k))])
    end

    %% JACOBIAN (dV/dSOC)
    H = (1.2/100) - (2*0.3/100)*(socPred/100);

    %% KALMAN GAIN
    K = (P*H' / (H*P*H' + R));

    %% UPDATE
    socEst(k) = socPred + K*(voltage_meas - voltage_pred);

    %% Capacity Fading
    capacity = (capacity * 0.99999);

    %% COVARIANCE UPDATE
    P = ((1 - K*H)*P);

    %% LIMIT SOC (0–100)%
    socEst(k) = max(0, min(100, socEst(k)));
    socTrue(k) = max(0, min(100, socTrue(k)));

    %% STORE VOLTAGE
    voltage_meas_store(k) = voltage_meas;
    voltage_pred_store(k) = voltage_pred;
end

%% ERROR & RMSE(Root-Mean Square Error)
error = (socTrue - socEst);
rmse = sqrt(mean(error.^2));
disp(['RMS Error = ', num2str(rmse)]);

%% PLOTTING (using Tiledlayout)
figure;

t = tiledlayout(5,1,'TileSpacing','compact','Padding','compact');

% SOC Plot
nexttile
plot(time, socTrue, 'b', 'LineWidth', 2); 
hold on;
plot(time, socEst, 'r--', 'LineWidth', 2);
legend('True SOC', 'Estimated SOC','Location','best');
ylabel('SOC (%)');
title('EKF SOC Estimation');
grid on;

% Current Plot
nexttile
plot(time, current, 'g', 'LineWidth', 1.5);
ylabel('Current (A)');
title('Input Current');
grid on;

% Voltage Plot
nexttile
plot(time, voltage_meas_store, 'b', 'LineWidth', 1.5); 
hold on;
plot(time, voltage_pred_store, 'r--', 'LineWidth', 1.5);
legend('Measured Voltage', 'Predicted Voltage','Location','best');
ylabel('Voltage (V)');
title('Voltage Comparison');
grid on;

% Error Plot
nexttile
plot(time, error, 'm', 'LineWidth', 1.5);
ylabel('SOC Error (%)');
title('Estimation Error');
grid on;

% Fault Plot
nexttile
plot(time, fault, 'r', 'LineWidth', 1.5);
ylim([-0.1 1.1]);
ylabel('Fault');
title('Fault Detection (1 = Fault)');
grid on;

% Common X-label
xlabel(t, 'Time (s)');