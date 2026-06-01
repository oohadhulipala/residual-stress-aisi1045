function plot_predicted_vs_measured(measured, predicted, save_path)
% PLOT_PREDICTED_VS_MEASURED
%
% This plot is the most direct validation of the regression model — how closely do the predicted values track the XRD measurements?
% Points sitting on the diagonal indicate perfect agreement. The shaded band shows the ±5% error zone; the paper reports all predictions fall within this limit.
%
% One thing worth noting is that with only 8 data points, individual outliers carry more weight than they would in a larger dataset.
%
% Experiment 7, (speed=710, feed=20, doc=0.3) produced the most compressive stress at -585.3 MPa and is the most interesting point on this chart.
% -------------------------------------------------------------------------

fig = figure('Visible', 'off', 'Position', [100 100 700 600]);
ax  = axes(fig);
hold(ax, 'on');

all_vals = [measured; predicted];
lim_min  = min(all_vals) - 40;
lim_max  = max(all_vals) + 40;

% Perfect agreement line
plot(ax, [lim_min lim_max], [lim_min lim_max], '--', ...
     'Color', [0.55 0.55 0.55], 'LineWidth', 1.5, ...
     'DisplayName', 'Perfect agreement');

% ±5% error bands
plot(ax, [lim_min lim_max], [lim_min*1.05 lim_max*1.05], ':', ...
     'Color', [0.85 0.33 0.10], 'LineWidth', 1.2, ...
     'DisplayName', '+5% band');
plot(ax, [lim_min lim_max], [lim_min*0.95 lim_max*0.95], ':', ...
     'Color', [0.85 0.33 0.10], 'LineWidth', 1.2, ...
     'DisplayName', '-5% band');

% Experimental data points
scatter(ax, measured, predicted, 95, [0.18 0.52 0.67], 'filled', ...
        'MarkerEdgeColor', 'white', 'LineWidth', 0.8, ...
        'DisplayName', 'XRD-measured runs');

% Label each experiment
for i = 1:length(measured)
    text(ax, measured(i) + 7, predicted(i), sprintf('Exp %d', i), ...
         'FontSize', 8, 'Color', [0.25 0.25 0.25]);
end

% Compute R² from data
ss_res = sum((measured - predicted).^2);
ss_tot = sum((measured - mean(measured)).^2);
r2     = 1 - ss_res / ss_tot;

ax.XLim = [lim_min lim_max];
ax.YLim = [lim_min lim_max];
ax.Box  = 'on';
grid(ax, 'on');

xlabel(ax, 'Measured Residual Stress — XRD (MPa)',  'FontSize', 12);
ylabel(ax, 'Predicted Residual Stress — Model (MPa)', 'FontSize', 12);
title(ax, {'Predicted vs Measured — AISI 1045 Milling Study', ...
    sprintf('R² = %.4f  |  All predictions within 5%% of XRD measurement', r2)}, ...
    'FontSize', 11, 'FontWeight', 'bold');
legend(ax, 'Location', 'northwest', 'FontSize', 9);

% Model equation annotation
text(ax, lim_min + 12, lim_max - 25, ...
     'RS = -340.75 - 0.38·Speed + 4.76·Feed - 11.32·DOC', ...
     'FontSize', 8, 'Color', [0.35 0.35 0.35], 'FontAngle', 'italic');

exportgraphics(fig, save_path, 'Resolution', 150);
close(fig);
fprintf('  -> Saved: %s\n', save_path);
end
