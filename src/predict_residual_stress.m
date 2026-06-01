function rs = predict_residual_stress(b0, b1, b2, b3, speed, feed, doc)
% PREDICT_RESIDUAL_STRESS
%
% Applying the regression model from Eq. 1 of the published paper to
% predict surface residual stress for any combination of machining
% parameters.

% This is useful for process planning when you need a specific residual stress, for example, ensuring compressive stress above a minimum threshold for fatigue-critical components.
%
% The model is valid within the experimental parameter space. Outside
% this range, the linear model may not capture the real behaviour
% accurately and predictions should be treated with caution.
%
% Experimental bounds from the published study:
%   Speed:         355 to 710 rpm
%   Feed:           20 to  80 mm/min
%   Depth of cut: 0.20 to 0.50 mm
%
% Inputs
% ------
%   b0, b1, b2, b3 : regression coefficients from paper
%   speed          : cutting speed (rpm)
%   feed           : feed rate (mm/min)
%   doc            : depth of cut (mm)
%
% Output
% ------
%   rs : predicted residual stress (MPa)
%        negative = compressive (beneficial for fatigue)
%        positive = tensile (detrimental)
% -------------------------------------------------------------------------

rs = b0 + b1*speed + b2*feed + b3*doc;

% Flag if inputs are outside the validated experimental range
warn = '';
if speed < 355 || speed > 710
    warn = [warn 'Speed outside validated range (355-710 rpm). '];
end
if feed < 20 || feed > 80
    warn = [warn 'Feed outside validated range (20-80 mm/min). '];
end
if doc < 0.20 || doc > 0.50
    warn = [warn 'DOC outside validated range (0.20-0.50 mm). '];
end

if rs < 0
    nature = 'compressive -- beneficial for fatigue resistance';
else
    nature = 'tensile -- detrimental to fatigue performance';
end

fprintf('Input  : Speed = %d rpm  |  Feed = %d mm/min  |  DOC = %.2f mm\n', ...
        speed, feed, doc);
fprintf('Output : Predicted RS = %.1f MPa  (%s)\n', rs, nature);
if ~isempty(warn)
    fprintf('Warning: %s\n', strtrim(warn));
end
fprintf('\n');
end
