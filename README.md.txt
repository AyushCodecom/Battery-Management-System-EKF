# Battery Management System (BMS) using Extended Kalman Filter (EKF)

## Project Overview
This project implements a Battery Management System (BMS) model in MATLAB for estimating the **State of Charge (SOC)** of a battery using an **Extended Kalman Filter (EKF)**.

The model simulates battery behavior under dynamic current loading conditions and predicts SOC by comparing measured battery voltage with estimated voltage.

The project also includes:
- Voltage prediction
- Temperature influence
- Capacity fading
- Fault detection
- Estimation error analysis

---

## Objective
The objective of this project is to estimate battery SOC accurately using an EKF-based approach and analyze battery behavior under realistic operating conditions.

---

## Features
- Extended Kalman Filter (EKF) based SOC estimation
- Dynamic load current simulation
- Battery voltage modeling using OCV-SOC relationship
- Temperature-dependent voltage variation
- Internal resistance voltage drop
- Fault detection based on voltage deviation
- RMSE (Root Mean Square Error) calculation
- Visualization using multiple performance plots

---

## Tools Used
- MATLAB
- Numerical Modeling
- Extended Kalman Filter (EKF)

---

## Battery Parameters
| Parameter            |  Value   |
|----------------------|----------|
| Capacity 	       |  1 Ah    |
| Internal Resistance  | 0.015 Ω  |
| Time Step	       |  1 sec   |
| Simulation Time      | 1000 sec |

---

## Battery Voltage Model
The Open Circuit Voltage (OCV) model used:

V = [3 + 1.2*(soc/100) - 0.3*(soc/100).^2 - 0.002*(T-25)

Where:
- SOC = State of Charge (%)
- T = Temperature (°C)

---

## EKF Workflow
1. Initialize battery states
2. Generate dynamic current profile
3. Predict SOC using Coulomb counting
4. Predict battery voltage
5. Compare measured and predicted voltage
6. Update SOC using EKF correction
7. Detect faults
8. Calculate estimation error

---

## Input Conditions
### Current Profile
Dynamic sinusoidal current with noise:

I(t) = (3*sin(omega*time) + Noise)


### Temperature Variation
Temperature changes over time:

T = 25 + 5*sin(0.001t)


---

## Fault Detection Logic
Fault is detected when:

|V_{measured} - V_{predicted}| > 0.2

If exceeded:
- Fault flag = 1
- Fault timestamp displayed in command window

---

## Output Graphs
The script generates:

1. True SOC vs Estimated SOC
2. Input Current Profile
3. Measured Voltage vs Predicted Voltage
4. SOC Estimation Error
5. Fault Detection Signal

---

## Performance Metric
### RMSE (Root Mean Square Error)
Used to evaluate SOC estimation accuracy.

Lower RMSE indicates better estimation performance.

---

## Project Structure
```text
BMS_EKF_Project/
│
├── README.md
└── BMS_Project_Report.pdf
├── bms_main_code.m
├── screenshots/
│   ├── output_plot.png
├── results/
│   ├── soc_plot.png
│   ├── voltage_plot.png
│   ├── error_plot.png


