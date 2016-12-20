% This file is not directly used in the experiment. I used it to keep track
% of which variables I was storing into the vars.mat file. Keeping it here
% just in case the variables need to be reviewed or quickly modified.


% RGB Values 
white = [255 255 255];
black = [0 0 0];
red = [255 0 0];

% Answers are assigned indices with ordering schema:
% 1   2   3   4
% 5   6   7   8
% 9   10  11  12 
% Refer to png files in Problems folder 
%
% First row (L T R B) 
index01 =    [910  105 1135 300];
index02 =   [1135 105 1365 300];
index03 =    [1365 105 1590 300];
index04 =   [1590 105 1815 300];
% Second row
index05 =    [910  300 1135 500];
index06 =    [1135 300 1365 500];
index07 =  [1365 300 1590 500];
index08 =    [1590 300 1815 500];
% Third row
index09 =    [910  500 1135 695];
index10 =    [1135 500 1365 695];
index11 = [1365 500 1590 695];
index12 =  [1590 500 1815 695];

% Store all indices for easy access 
input_rects = {index01,index02,index03,index04,index05,...
    index06,index07,index08,index09,index10,index11,index12};

% Used to place image onto screen
image_dimensions = [100 100 1820 705];

% Vector of all solutions, assuming order is unchanged
solutions = [8,5,11,7,3,6,4,10,5,8,8,1,8,2,5,12,10,3,1,5,8,6,11,8,2,7,11,2,8,3];

% Frequency for audio playback 
sr = 48000;