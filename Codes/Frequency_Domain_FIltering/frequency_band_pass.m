clc; clear; close all;

% Image and output paths
img_name = 'cologne_000073_000019_leftImg8bit.png';
output_folder = fullfile('outputs', 'frequency_filtered');
if ~exist(output_folder, 'dir')
    mkdir(output_folder);
end

% Step 1: Read and resize image
img = imread(img_name);
gray = rgb2gray(img);

% Step 2: FFT and shift
F = fft2(double(gray));
F_shifted = fftshift(F);

% Step 3: Create Band-Pass mask
[rows, cols] = size(gray);
[X, Y] = meshgrid(1:cols, 1:rows);
center_x = ceil(cols/2); center_y = ceil(rows/2);
D = sqrt((X - center_x).^2 + (Y - center_y).^2);

low_radius = 30;   % inner cutoff (removes low freqs)
high_radius = 80;  % outer cutoff (removes high freqs)

bandpass_mask = (D >= low_radius) & (D <= high_radius);

% Step 4: Apply mask and inverse FFT
F_band = F_shifted .* bandpass_mask;
F_ishift = ifftshift(F_band);
img_bandpass = real(ifft2(F_ishift));
img_bandpass = uint8(mat2gray(img_bandpass) * 255);

% Step 5: Save result
output_name = 'cologne_fft_bandpass.png';
imwrite(img_bandpass, fullfile(output_folder, output_name));

% Step 6: Show results
figure('Name', 'Original Grayscale');
imshow(gray); title('Original (Grayscale)');

figure('Name', 'Band-Pass Filtered Image');
imshow(img_bandpass); title('Band-Pass Filtered (30–80)');
