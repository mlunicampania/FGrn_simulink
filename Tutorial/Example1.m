% Example Asbestos-Smoking-Cancer
% Complete Observations (look at §9.3 in Barber, "Bayesian Reasoning and
% Machine Learning", 2012)
clear;clc;close all;

if (exist('initialGuess.mat','file') ~= 0)
    delete initialGuess.mat;
end
%a s c
trainingSet = [ 1 1 1; 1 0 0; 0 1 1; 0 1 0; 1 1 1; 0 0 0; 1 0 1];

UsingLibrary

disp ('INFERENCE')
Inference