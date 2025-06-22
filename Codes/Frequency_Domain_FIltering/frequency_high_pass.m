clc; clear; close all;

% Image name (in root folder)
img_name = 'cologne_000073_000019_leftImg8bit.png';
output_folder = fullfile('outputs', 'frequency_filtered');
if ~exist(output_folder, 'dir')
    mkdir(output_folder);
end

% Step 1: Load and prepare
img = imread(img_name);
gray = rgb2gray(img);

% Step 2: FFT and shift
F = fft2(double(gray));
F_shifted = fftshift(F);

% Step 3: Create high-pass mask (inverse of low-pass)
radius = 80;  % adjust as needed
[rows, cols] = size(gray);
[X, Y] = meshgrid(1:cols, 1:rows);
center_x = ceil(cols/2); center_y = ceil(rows/2);
lowpass_mask = sqrt((X - center_x).^2 + (Y - center_y).^2) <= radius;
highpass_mask = ~lowpass_mask;  % Invert to get high-pass

% Step 4: Apply mask and inverse FFT
F_high = F_shifted .* highpass_mask;
F_ishift = ifftshift(F_high);
img_highpass = real(ifft2(F_ishift));
img_highpass = uint8(mat2gray(img_highpass) * 255);

% Step 5: Save output
output_name = 'cologne_fft_highpass.png';
imwrite(img_highpass, fullfile(output_folder, output_name));

% Step 6: Display results
figure('Name', 'Original Grayscale');
imshow(gray); title('Original (Grayscale)');

figure('Name', 'FFT Spectrum');
imshow(log(1 + abs(F_shifted)), []); colormap jet; colorbar;
title('FFT Spectrum');

figure('Name', 'High-Pass Filtered Image');
imshow(img_highpass); title('High-Pass Filtered (FFT)');
