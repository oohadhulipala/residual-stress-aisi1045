function plot_coefficients(coeffs, save_path)
% PLOT_COEFFICIENTS
%
% Bar chart of the three regression coefficients with ANOVA significance
% flags. The error bars show ±1 standard error from Table 3 of the paper.
%
% The feed coefficient (+4.76) being positive and the speed coefficient
% (-0.38) being negative shows a clear picture: more feed pushes stress
% toward zero, more speed pushes it more compressive. The large standard
% error on depth of cut (141 vs a coefficient of -11.3) is what drives
% its statistical insignificance — there is simply too much uncertainty
% relative to the effect size within the tested range.
% -------------------------------------------------------------------------

params  = coeffs.parameter(2:end);
coef    = coeffs.coefficient(2:end);
pvals   = coeffs.p_value(2:end);
std_err = coeffs.std_error(2:end);

n      = numel(params);
colors = [0.18 0.52 0.67;
          0.91 0.28 0.33;
          0.75 0.75 0.75];

fig = figure('Visible', 'off', 'Position', [100 100 720 520]);
ax  = axes(fig);
hold(ax, 'on');

for i = 1:n
    bar(ax, i, coef(i), 0.5, 'FaceColor', colors(i,:), ...
        'EdgeColor', 'white', 'LineWidth', 0.8);
    errorbar(ax, i, coef(i), std_err(i), 'k', 'LineWidth', 1.5, ...
             'CapSize', 10);
end

sig_labels = {'p = 0.050  *', 'p = 0.004  **', 'p = 0.940  n.s.'};
sig_colors = {[0.18 0.52 0.67], [0.91 0.28 0.33], [0.5 0.5 0.5]};
for i = 1:n
    y_pos = sign(coef(i)) * (abs(coef(i)) + std_err(i) + 0.5);
    text(ax, i, y_pos, sig_labels{i}, 'HorizontalAlignment', 'center', ...
         'FontSize', 9, 'Color', sig_colors{i}, 'FontWeight', 'bold');
end

ax.XTick      = 1:n;
ax.XTickLabel = params;
ax.Box        = 'off';
ax.YGrid      = 'on';
yline(ax, 0, 'k-', 'LineWidth', 0.8);

xlabel(ax, 'Machining Parameter', 'FontSize', 12);
ylabel(ax, 'Regression Coefficient', 'FontSize', 12);
title(ax, {'Regression Coefficients — ANOVA Significance', ...
    'Error bars = ±1 standard error  |  AISI 1045 milling study'}, ...
    'FontSize', 12, 'FontWeight', 'bold');

text(ax, 0.70, 0.97, '**  p < 0.01  highly significant', ...
     'Units', 'normalized', 'FontSize', 8, 'Color', [0.91 0.28 0.33]);
text(ax, 0.70, 0.91, '*   p < 0.05  significant', ...
     'Units', 'normalized', 'FontSize', 8, 'Color', [0.18 0.52 0.67]);
text(ax, 0.70, 0.85, 'n.s.  p > 0.05  not significant', ...
     'Units', 'normalized', 'FontSize', 8, 'Color', [0.5 0.5 0.5]);

exportgraphics(fig, save_path, 'Resolution', 150);
close(fig);
fprintf('  -> Saved: %s\n', save_path);
end
