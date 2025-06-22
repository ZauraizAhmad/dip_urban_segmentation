clc; clear; close all;

% Output folder
output_folder = fullfile('outputs', 'segmented');
if ~exist(output_folder, 'dir')
    mkdir(output_folder);
end

% Load image
img_name = 'cologne_000073_000019_leftImg8bit.png';
img = imread(img_name);
gray = rgb2gray(img);

% Adaptive threshold
T = adaptthresh(gray, 0.5);
bw = imbinarize(gray, T);

% Morphological cleanup
bw = imopen(bw, strel('disk', 2));
bw = imclose(bw, strel('disk', 4));
bw = imfill(bw, 'holes');
bw = bwareaopen(bw, 1000);

% Connected components
cc = bwconncomp(bw);
stats = regionprops(cc, 'BoundingBox', 'Area', 'Eccentricity');

% Display image with boxes
figure('Name', 'Connected Components (Cologne)');
imshow(img);
title(['Connected Components: ', num2str(cc.NumObjects), ' (raw count)']);
hold on;

for i = 1:length(stats)
    if stats(i).Area > 1200 && stats(i).Eccentricity < 0.95
        rectangle('Position', stats(i).BoundingBox, 'EdgeColor', 'yellow', 'LineWidth', 2);
    end
end

hold off;
exportgraphics(gca, fullfile(output_folder, 'cologne_connected_components.png'));
