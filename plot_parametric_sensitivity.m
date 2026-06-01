function plot_parametric_sensitivity(b0, b1, b2, b3, data, save_path)
% PLOT_PARAMETRIC_SENSITIVITY
%
% This plot shows the independent effect of each parameter on predicted residual stress, with the other two held at their mean values.
%
% The actual experimental data points are overlaid to show where the measurements sit relative to the model trend.
%
% The interesting thing in these charts is the feed rate plot —
% the positive coefficient indicates that increasing feed pushes the stress toward zero (less compressive), which is the opposite of the required results.
%
% This was one of the important findings: running at lower feed rates produces a more beneficial compressive stress state at the surface.
%
% Depth of cut shows almost no slope — confirming its statistical insignificance (p = 0.940) within the tested range.
% -------------------------------------------------------------------------

speed_mean = mean(data.speed_rpm);
feed_mean  = mean(data.feed_mm_min);
doc_mean   = mean(data.depth_of_cut_mm);

speed_range = linspace(300, 780, 100);
feed_range  = linspace(15,  90,  100);
doc_range   = linspace(0.15, 0.6, 100);

rs_vs_speed = b0 + b1.*speed_range + b2*feed_mean  + b3*doc_mean;
rs_vs_feed  = b0 + b1*speed_mean   + b2.*feed_range + b3*doc_mean;
rs_vs_doc   = b0 + b1*speed_mean   + b2*feed_mean   + b3.*doc_range;

fig = figure('Visible', 'off', 'Position', [100 100 1200 430]);

colors = [0.18 0.52 0.67;
          0.91 0.28 0.33;
          0.45 0.72 0.50];

% --- Speed ---
ax1 = subplot(1, 3, 1);
hold(ax1, 'on');
plot(ax1, speed_range, rs_vs_speed, '-', 'Color', colors(1,:), 'LineWidth', 2.5);
scatter(ax1, data.speed_rpm, data.residual_stress_MPa, 65, 'k', ...
        'filled', 'MarkerEdgeColor', 'white');
xlabel(ax1, 'Cutting Speed (rpm)',    'FontSize', 11);
ylabel(ax1, 'Residual Stress (MPa)', 'FontSize', 11);
title(ax1, {'Cutting Speed', sprintf('Feed = %.0f, DOC = %.2f (means)', ...
    feed_mean, doc_mean)}, 'FontSize', 10, 'FontWeight', 'bold');
text(ax1, 0.05, 0.95, 'p = 0.050  *significant', 'Units', 'normalized', ...
     'FontSize', 8, 'Color', colors(1,:), 'FontWeight', 'bold', ...
     'VerticalAlignment', 'top');
grid(ax1, 'on'); ax1.Box = 'on';

% --- Feed ---
ax2 = subplot(1, 3, 2);
hold(ax2, 'on');
plot(ax2, feed_range, rs_vs_feed, '-', 'Color', colors(2,:), 'LineWidth', 2.5);
scatter(ax2, data.feed_mm_min, data.residual_stress_MPa, 65, 'k', ...
        'filled', 'MarkerEdgeColor', 'white');
xlabel(ax2, 'Feed Rate (mm/min)',    'FontSize', 11);
ylabel(ax2, 'Residual Stress (MPa)', 'FontSize', 11);
title(ax2, {'Feed Rate', sprintf('Speed = %.0f, DOC = %.2f (means)', ...
    speed_mean, doc_mean)}, 'FontSize', 10, 'FontWeight', 'bold');
text(ax2, 0.05, 0.95, 'p = 0.004  **most significant', 'Units', 'normalized', ...
     'FontSize', 8, 'Color', colors(2,:), 'FontWeight', 'bold', ...
     'VerticalAlignment', 'top');
grid(ax2, 'on'); ax2.Box = 'on';

% --- Depth of cut ---
ax3 = subplot(1, 3, 3);
hold(ax3, 'on');
plot(ax3, doc_range, rs_vs_doc, '-', 'Color', colors(3,:), 'LineWidth', 2.5);
scatter(ax3, data.depth_of_cut_mm, data.residual_stress_MPa, 65, 'k', ...
        'filled', 'MarkerEdgeColor', 'white');
xlabel(ax3, 'Depth of Cut (mm)',     'FontSize', 11);
ylabel(ax3, 'Residual Stress (MPa)', 'FontSize', 11);
title(ax3, {'Depth of Cut', sprintf('Speed = %.0f, Feed = %.0f (means)', ...
    speed_mean, feed_mean)}, 'FontSize', 10, 'FontWeight', 'bold');
text(ax3, 0.05, 0.95, 'p = 0.940  not significant', 'Units', 'normalized', ...
     'FontSize', 8, 'Color', [0.55 0.55 0.55], 'FontWeight', 'bold', ...
     'VerticalAlignment', 'top');
grid(ax3, 'on'); ax3.Box = 'on';

sgtitle({'Parametric Sensitivity — Effect of Each Machining Parameter', ...
         'Black dots = actual XRD measurements from published experiments'}, ...
        'FontSize', 12, 'FontWeight', 'bold');

exportgraphics(fig, save_path, 'Resolution', 150);
close(fig);
fprintf('  -> Saved: %s\n', save_path);
end
