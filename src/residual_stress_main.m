%% residual_stress_main.m
% =========================================================================
% Machining-Induced Residual Stress Analysis — AISI 1045 Steel
% =========================================================================
%
% This project is an extension of the research paper that focuses on residual stresses of a machined component and how different parameters influence it.
%
% To investigate this, we machined eight identical AISI 1045 steel
% specimens under different combinations of cutting speed, feed rate,
% and depth of cut, then measured the surface residual stresses using
% X-ray diffraction (XRD) — a non-destructive technique that reads
% stress by measuring how far the atomic lattice spacing has shifted
% from its natural, unstressed state.
%
% What we found was that all eight surfaces were left in compression
% after milling — which is actually beneficial for fatigue life. But the
% magnitude varied enormously: from -170 MPa at high feed and speed, to
% -585 MPa at high speed and low feed. That 3x range, from the same
% material and the same process, driven purely by parameter choices,
% is what made this problem worth publishing.
%
% This specific MATLAB project reproduces the regression analysis from that paper,
% visualises the parametric relationships, and builds a prediction tool
% that applies the published model to any combination of inputs.
%
% Published paper:
%   Padma Ooha D.N.V., et.al.
%   "Effect of Speed, Feed and Depth of Cut on Machining Induced
%    Residual Stresses in AISI 1045 Steel."
%   International Journal of Recent Technology and Engineering,
%   Vol. 8, Issue 2, pp. 3397-3400, July 2019.
%   DOI: 10.35940/ijrte.A1262.078219
%
% Author : Ooha Dhulipala
% =========================================================================

clear; clc; close all;

if ~exist('outputs', 'dir'); mkdir('outputs'); end

% =========================================================================
% SECTION 1 — Load the experimental data
%
% These are the actual XRD measurements from the published study.
% Each row is one machined specimen. The residual stress values are
% negative throughout indicating compressive stresses, as expected for milled steel.
% The range of -170 to -585 MPa across eight specimens is what the
% regression analysis below attempts to explain.
% =========================================================================
fprintf('=========================================================\n');
fprintf('  RESIDUAL STRESS — AISI 1045 STEEL (MILLING + XRD)\n');
fprintf('=========================================================\n\n');
data   = readtable('data/experimental_data.csv');
coeffs = readtable('data/regression_coefficients.csv');
fprintf('Experimental dataset — 8 XRD-measured runs (Table 1, paper):\n');
disp(data);
% =========================================================================
% SECTION 2 — Reproduce the regression model from Eq. 1 of the paper
%
% Linear regression was performed on the 8 experimental results.
% The model takes the form:
%   RS = b0 + b1*speed + b2*feed + b3*doc
%
% Key observations: feed rate (p = 0.004) has the strongest influence.
% Speed is significant (p = 0.050). Depth of cut is least (p = 0.940)
% significant — which was somewhat unexpected and is one
% of the more interesting results of this study.
%
% R-squared of 0.90 means the three parameters together explain 90%
% of the variation in measured residual stress across the eight runs.
% =========================================================================
b0 = -340.74;   % intercept
b1 = -0.3763;   % speed:        more speed = more compressive stress
b2 =  4.7605;   % feed:         more feed = less compressive (toward tensile)
b3 = -11.323;   % depth of cut: statistically insignificant
speed       = data.speed_rpm;
feed        = data.feed_mm_min;
doc         = data.depth_of_cut_mm;
rs_measured = data.residual_stress_MPa;
rs_predicted = b0 + b1.*speed + b2.*feed + b3.*doc;
error_pct    = abs((rs_predicted - rs_measured) ./ rs_measured) * 100;
fprintf('Regression model — Eq. 1 from paper:\n');
fprintf('  RS = %.2f + (%.4f x Speed) + (%.4f x Feed) + (%.4f x DOC)\n\n', ...
        b0, b1, b2, b3);
fprintf('Regression statistics:\n');
fprintf('  Multiple R        : 0.9485\n');
fprintf('  R-squared         : 0.8997  (model explains 90%% of variance)\n');
fprintf('  Adjusted R-squared: 0.8244\n');
fprintf('  Observations      : 8\n\n');
fprintf('Predicted vs measured (paper states max error < 5%%):\n');
fprintf('%-6s %-15s %-15s %-10s\n', 'Exp', 'Measured(MPa)', 'Predicted(MPa)', 'Error(%)');
fprintf('%s\n', repmat('-', 1, 50));
for i = 1:length(rs_measured)
    fprintf('%-6d %-15.1f %-15.1f %-10.2f\n', ...
            i, rs_measured(i), rs_predicted(i), error_pct(i));
end
fprintf('\nMax error: %.2f%%\n\n', max(error_pct));

% =========================================================================
% SECTION 3 — Predicted vs measured scatter plot
% =========================================================================
plot_predicted_vs_measured(rs_measured, rs_predicted, ...
    'outputs/predicted_vs_measured.png');

% =========================================================================
% SECTION 4 — Parametric sensitivity
%
% One of the practical takeaways from this study is that feed rate is
% the parameter you should control most carefully if you are trying to
% manage surface residual stress in a milled AISI 1045 component.
% Speed matters too, but less. Depth of cut, within the range tested,
% has least effect on residual stress.
% =========================================================================
plot_parametric_sensitivity(b0, b1, b2, b3, data, ...
    'outputs/parametric_sensitivity.png');

% =========================================================================
% SECTION 5 — Regression coefficient chart with significance flags
% =========================================================================
plot_coefficients(coeffs, 'outputs/regression_coefficients.png');

% =========================================================================
% SECTION 6 — Residual error analysis
% Validates the paper's claim that prediction error stays below 5%
% =========================================================================
plot_residuals(rs_measured, rs_predicted, data.experiment, ...
    'outputs/residual_errors.png');

% =========================================================================
% SECTION 7 — Response surface plots
%
% These surfaces show the full parametric landscape — what the regression
% model predicts across the entire range of two parameters simultaneously.
% The experimental points sit on or very close to the surfaces, which
% is a good visual confirmation of model fit.
% =========================================================================
plot_surfaces(b0, b1, b2, b3, data, 'outputs/surface_plots.png');

% =========================================================================
% SECTION 8 — Prediction tool
%
% Applying the published regression model to new parameter combinations.
% Useful for process planning: if you need a component to have surface
% compressive stress above a certain magnitude, what should be the range of the parameters to get there?
% The model answers that question within the validated range.
% =========================================================================
fprintf('=========================================================\n');
fprintf('  PREDICTION TOOL — apply model to new inputs\n');
fprintf('=========================================================\n\n');

predict_residual_stress(b0, b1, b2, b3, 600, 50, 0.35);
predict_residual_stress(b0, b1, b2, b3, 355, 80, 0.30);
predict_residual_stress(b0, b1, b2, b3, 710, 20, 0.20);

fprintf('\nAll charts saved to /outputs\n');
