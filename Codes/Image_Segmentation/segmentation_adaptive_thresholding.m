clc; clear; close all;

% Output folder setup
output_folder = fullfile('outputs', 'segmented');
if ~exist(output_folder, 'dir')
    mkdir(output_folder);
end

% Image file (Cologne)
img_name = 'cologne_000073_000019_leftImg8bit.png';
img = imread(img_name);
gray = rgb2gray(img);

% Compute adaptive threshold map
T = adaptthresh(gray, 0.5);  % Try 0.5; adjust to 0.4 or 0.6 if needed

% Binarize using the adaptive threshold
binary_adaptive = imbinarize(gray, T);

% Save result
imwrite(binary_adaptive, fullfile(output_folder, 'cologne_adaptive_threshold.png'));

% Display results
figure('Name', 'Original Cologne Grayscale');
imshow(gray); title('Original Grayscale');

figure('Name', 'Adaptive Thresholding (Cologne)');
imshow(binary_adaptive); title('Adaptive Thresholding');
