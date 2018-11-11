clc
clear all

% img = imread('tomo.jpg'); nIter = 40; sigma=0.5; c=0.000000001;
img = rgb2gray(imread('triangle.jpg')); nIter = 40; sigma=0.5; c=0.00000001;
% img = imread('cameraman.tif'); nIter = 40; sigma=0.5; c=0.00000001;
% img = rgb2gray(imread('starry_night.png')); nIter = 40; sigma=0.5; c=0.00000001;

img = im2double(img); % normalizing the instensity values to lie between o and 1

% imgNoise = imnoise(img,'gaussian',0.1); % adding Gaussian noise of mean zero and variance 0.01
% imgNoise = imnoise(img, 'gaussian', 0.01);
% imgNoise = imnoise(img, 'poisson');
% imgNoise = imnoise(img, 'speckle');
imgNoise = imnoise(img, 'salt & pepper');

timeStep = 0.2; % timestep size used in numerical approximation

imgFiltered = cedfinal(imgNoise, timeStep, nIter, 1, sigma, 4, 0.001, c, 1); 
% cedfinal(u, timeStep, nIter, verbose, sigma, rho, alpha, c, m)
