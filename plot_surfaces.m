function plot_surfaces(b0, b1, b2, b3, data, save_path)
% PLOT_SURFACES
%
% These surface plots show the residual stress dependency on parameters in pairs with the third held at its mean.
% 
%The colour scale runs from deep blue (highly compressive, beneficial) to warm red (less compressive or tensile, detrimental).
% 
% The experimental points are overlaid as black markers.
%
% The Speed x Feed surface is the most informative: the steep gradient
% in the feed direction shows that the feed is the dominant lever, confirming what the sensitivity analysis shows.
%
% The Speed x DOC and Feed x DOC surfaces are comparatively flat in the DOC direction, consistent with its statistical insignificance.
% -------------------------------------------------------------------------

doc_mean   = mean(data.depth_of_cut_mm);
speed_mean = mean(data.speed_rpm);
feed_mean  = mean(data.feed_mm_min);

speed_vec = linspace(300, 780, 50);
feed_vec  = linspace(15,  90,  50);
doc_vec   = linspace(0.15, 0.6, 50);

fig = figure('Visible', 'off', 'Position', [100 100 1300 480]);

% --- Speed x Feed ---
ax1 = subplot(1, 3, 1);
[S1, F1] = meshgrid(speed_vec, feed_vec);
RS1 = b0 + b1.*S1 + b2.*F1 + b3*doc_mean;
surf(ax1, S1, F1, RS1, 'EdgeColor', 'none', 'FaceAlpha', 0.88);
colormap(ax1, cool); hold(ax1, 'on');
scatter3(ax1, data.speed_rpm, data.feed_mm_min, data.residual_stress_MPa, ...
         65, 'k', 'filled', 'MarkerEdgeColor', 'white');
xlabel(ax1, 'Speed (rpm)',    'FontSize', 10);
ylabel(ax1, 'Feed (mm/min)', 'FontSize', 10);
zlabel(ax1, 'RS (MPa)',      'FontSize', 10);
title(ax1, sprintf('Speed x Feed\nDOC = %.2f mm (mean)', doc_mean), ...
      'FontSize', 10, 'FontWeight', 'bold');
colorbar(ax1); view(ax1, [-40 30]);

% --- Speed x DOC ---
ax2 = subplot(1, 3, 2);
[S2, D2] = meshgrid(speed_vec, doc_vec);
RS2 = b0 + b1.*S2 + b2*feed_mean + b3.*D2;
surf(ax2, S2, D2, RS2, 'EdgeColor', 'none', 'FaceAlpha', 0.88);
colormap(ax2, cool); hold(ax2, 'on');
scatter3(ax2, data.speed_rpm, data.depth_of_cut_mm, data.residual_stress_MPa, ...
         65, 'k', 'filled', 'MarkerEdgeColor', 'white');
xlabel(ax2, 'Speed (rpm)',       'FontSize', 10);
ylabel(ax2, 'Depth of Cut (mm)', 'FontSize', 10);
zlabel(ax2, 'RS (MPa)',          'FontSize', 10);
title(ax2, sprintf('Speed x DOC\nFeed = %.0f mm/min (mean)', feed_mean), ...
      'FontSize', 10, 'FontWeight', 'bold');
colorbar(ax2); view(ax2, [-40 30]);

% --- Feed x DOC ---
ax3 = subplot(1, 3, 3);
[F3, D3] = meshgrid(feed_vec, doc_vec);
RS3 = b0 + b1*speed_mean + b2.*F3 + b3.*D3;
surf(ax3, F3, D3, RS3, 'EdgeColor', 'none', 'FaceAlpha', 0.88);
colormap(ax3, cool); hold(ax3, 'on');
scatter3(ax3, data.feed_mm_min, data.depth_of_cut_mm, data.residual_stress_MPa, ...
         65, 'k', 'filled', 'MarkerEdgeColor', 'white');
xlabel(ax3, 'Feed (mm/min)',     'FontSize', 10);
ylabel(ax3, 'Depth of Cut (mm)', 'FontSize', 10);
zlabel(ax3, 'RS (MPa)',          'FontSize', 10);
title(ax3, sprintf('Feed x DOC\nSpeed = %.0f rpm (mean)', speed_mean), ...
      'FontSize', 10, 'FontWeight', 'bold');
colorbar(ax3); view(ax3, [-40 30]);

sgtitle({'Response Surfaces — Machining-Induced Residual Stress, AISI 1045', ...
         'Black dots = XRD-measured experimental data  |  Blue = more compressive'}, ...
        'FontSize', 12, 'FontWeight', 'bold');

exportgraphics(fig, save_path, 'Resolution', 150);
close(fig);
fprintf('  -> Saved: %s\n', save_path);
end
