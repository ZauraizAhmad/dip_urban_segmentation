clc; clear; close all;

% Image file in root folder
img_name = 'cologne_000073_000019_leftImg8bit.png';  % change this as needed
image_path = img_name;

% Output folder path (still inside 'outputs/frequency_filtered')
output_folder = fullfile('outputs', 'frequency_filtered');
if ~exist(output_folder, 'dir')
    mkdir(output_folder);
end

% Read and resize image
img = imread(image_path);
gray = rgb2gray(img);

% FFT and shift
F = fft2(double(gray));
F_shifted = fftshift(F);

% Create low-pass filter mask
radius = 80;
[rows, cols] = size(gray);
[X, Y] = meshgrid(1:cols, 1:rows);
center_x = ceil(cols/2); center_y = ceil(rows/2);
mask = sqrt((X - center_x).^2 + (Y - center_y).^2) <= radius;

% Apply mask
F_filtered = F_shifted .* mask;

% Inverse FFT
F_ishift = ifftshift(F_filtered);
img_filtered = real(ifft2(F_ishift));
img_filtered = uint8(mat2gray(img_filtered) * 255);

% Save result
output_filename = [img_name(1:end-4) '_fft_filtered.png'];
imwrite(img_filtered, fullfile(output_folder, output_filename));

% Show outputs in separate figures (MATLAB Online friendly)
figure('Name', 'Original Grayscale');
imshow(gray); title('Original Grayscale');

figure('Name', 'FFT Spectrum');
imshow(log(1 + abs(F_shifted)), []); colormap jet; colorbar;
title('FFT Magnitude Spectrum');

figure('Name', 'Low-Pass Filtered Image');
imshow(img_filtered); title('Filtered (Low-Pass FFT)');
