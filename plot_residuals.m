function plot_residuals(measured, predicted, exp_nums, save_path)
% PLOT_RESIDUALS
%
% This plot is a two-panel residual analysis. Left panel shows absolute prediction error per experiment (predicted minus measured).
% And right panel shows percentage error and validates the paper's claim that all predictions fall within 5%.
%
% Experiment 4 (speed=500, feed=80, doc=0.5) tends to have slightly higher error than the others. The high feed rate combined with moderate speed sits in a region where the linear model is being stretched a little.
% This is expected behaviour for a first-order linear model on a dataset of only 8 points, and is one of the reasons the paper identifies future work as expanding the experimental range.
% -------------------------------------------------------------------------

residuals = predicted - measured;
error_pct = abs(residuals ./ measured) * 100;

fig = figure('Visible', 'off', 'Position', [100 100 1000 450]);

% --- Absolute residuals ---
ax1 = subplot(1, 2, 1);
hold(ax1, 'on');
bar(ax1, exp_nums, residuals, 0.55, 'FaceColor', [0.18 0.52 0.67], ...
    'EdgeColor', 'white');
yline(ax1, 0, 'k-', 'LineWidth', 1.2);
for i = 1:length(residuals)
    text(ax1, exp_nums(i), residuals(i) + sign(residuals(i))*1.8, ...
         sprintf('%.1f', residuals(i)), 'HorizontalAlignment', 'center', ...
         'FontSize', 8);
end
xlabel(ax1, 'Experiment Number',                  'FontSize', 11);
ylabel(ax1, 'Residual — Predicted minus Measured (MPa)', 'FontSize', 11);
title(ax1, 'Absolute Residuals per Experiment',   'FontSize', 11, 'FontWeight', 'bold');
ax1.XTick = exp_nums;
ax1.Box   = 'off';
grid(ax1, 'on');

% --- Percentage error ---
ax2 = subplot(1, 2, 2);
hold(ax2, 'on');
bar(ax2, exp_nums, error_pct, 0.55, 'FaceColor', [0.91 0.28 0.33], ...
    'EdgeColor', 'white');
yline(ax2, 5.0, '--', 'Color', [0.3 0.3 0.3], 'LineWidth', 1.5, ...
      'DisplayName', '5% threshold (paper limit)');
for i = 1:length(error_pct)
    text(ax2, exp_nums(i), error_pct(i) + 0.1, ...
         sprintf('%.2f%%', error_pct(i)), ...
         'HorizontalAlignment', 'center', 'FontSize', 8);
end
xlabel(ax2, 'Experiment Number', 'FontSize', 11);
ylabel(ax2, 'Prediction Error (%)', 'FontSize', 11);
title(ax2, {sprintf('Percentage Error  |  Max = %.2f%%  Mean = %.2f%%', ...
    max(error_pct), mean(error_pct)), ...
    'Paper states all predictions within 5%'}, ...
    'FontSize', 11, 'FontWeight', 'bold');
ax2.XTick = exp_nums;
ax2.YLim  = [0, max(error_pct) * 1.40];
ax2.Box   = 'off';
grid(ax2, 'on');
legend(ax2, 'Location', 'northeast', 'FontSize', 9);

sgtitle('Residual Error Analysis — Model Validation Against XRD Data', ...
        'FontSize', 12, 'FontWeight', 'bold');

exportgraphics(fig, save_path, 'Resolution', 150);
close(fig);
fprintf('  -> Saved: %s\n', save_path);
end
