clear; close all;
AssertOpenGL;
KbName('UnifyKeyNames');
Screen('Preference','SkipSyncTests',1); % Skip PTB splash screen
Screen('Preference','VisualDebugLevel',0); % Skip PTB splash screen
rng('shuffle');

subjInfo = inputdlg({'Initials (FirstLast):','Participant ID (Assigned by Experimenters):','Gender:','Age:'});
subjID = subjInfo{2};
subjID = str2num(subjID);

question_files = dir('Problems/*.png'); % Collect all image file names from Problems folder
nQuestions = size(question_files,1); % Find total number of images (should be 30)
question_array = cell(nQuestions,1); % Create array to store images

for q = 1:nQuestions
    question_array{q} = double(imread(['Problems/' question_files(q).name]));
end % Store all images into array

present_order = randperm(nQuestions);

% Load in variables used for experiment
load ('vars.mat');
if mod(subjID,2) == 0
    condition = 'congruent';
    correct = audioread('sound1.mp3');
    incorrect = audioread('sound2.mp3');
else
    condition = 'incongruent';
    correct = audioread('sound2.mp3');
    incorrect = audioread('sound1.mp3');
end

soundArray = {correct incorrect};

instructionsFile = importdata('instructions.txt');
initial_instructions = instructionsFile{1};
if_correct_instructions = instructionsFile{2};
if_incorrect_instructions = instructionsFile{3};

try
    scrNum = max(Screen('Screens'));
    [win, scrRect] = Screen('OpenWindow',scrNum,white);
    [cx, cy] = RectCenter(scrRect);
    [width, height] = RectSize(scrRect);
    Screen('TextSize', win, 30);
    Screen('TextFont',win,'Arial',0);

    answer_array = NaN(1,nQuestions);
    submission_timeout = true(1,nQuestions);
    correct = NaN(1,nQuestions);
    RT = NaN(1,nQuestions);
    soundsEnabled = false;

    WaitSecs(0.5);

    DrawFormattedText(win,initial_instructions,'center','center',black,75,0,0,1);
    Screen('Flip',win);

    KbWait;
    KbReleaseWait;

    for current = 1:nQuestions

        if current == 11
            soundsEnabled = true;
            DrawFormattedText(win,'This is a designated rest period. After 30 seconds you can continue.','center','center',black);
            Screen('Flip',win);
            WaitSecs(30);
            DrawFormattedText(win,'Press any key to continue','center','center',black);
            Screen('Flip',win);
            KbWait;
            KbReleaseWait;
        elseif current == 21
            DrawFormattedText(win,if_correct_instructions,'center','center',black,75,0,0,1);
            Screen('Flip',win);
            WaitSecs(1);
            soundsc(soundArray{1},sr);
            WaitSecs(3);
            DrawFormattedText(win,if_incorrect_instructions,'center','center',black,75,0,0,1);
            Screen('Flip',win);
            WaitSecs(1);
            soundsc(soundArray{2},sr);
            WaitSecs(3);
            DrawFormattedText(win,'Press any key to continue','center','center',black);
            Screen('Flip',win);
            KbWait;
            KbReleaseWait;
        end

        start_time = GetSecs;
        exp_duration = 60;
        recorded_submission = false;
        current_submission = NaN;
        counter = 0;

        while (GetSecs - start_time) < exp_duration
            Screen('PutImage',win,question_array{present_order(current)},image_dimensions);
            if recorded_submission
                Screen('FrameRect',win,red,input_rects{current_submission},10);
                DrawFormattedText(win,'Press Enter to submit your answer','center',900,black);
            end
            Screen('Flip',win);

            [x,y,buttons] = GetMouse;
            for selected_answer = 1:12
                if any(buttons)
                    if IsInRect(x,y,input_rects{selected_answer})
                        current_submission = selected_answer;
                        counter = counter + 1;
                        recorded_submission = true;
                        break;
                    end
                end
            end % Check if click is within possible answer dimensions

            [keyIsDown,secs,keyCode] = KbCheck;
            if keyIsDown && recorded_submission && strcmpi(KbName(keyCode),'Return')
                RT(current) = GetSecs - start_time;
                submission_timeout(current) = false;
                answer_array(current) = current_submission;
                if (answer_array(current) == solutions(present_order(current)))
                    correct(current) = 1;
                    if soundsEnabled
                        soundsc(soundArray{1},sr);
                        WaitSecs(2);
                    end
                else
                    correct(current) = 0;
                    if soundsEnabled
                        soundsc(soundArray{2},sr);
                        WaitSecs(2);
                    end
                end
                break;
            end

        end % Loop until time runs out

        if submission_timeout(current) && soundsEnabled
            soundsc(soundArray{2},sr);
            WaitSecs(2);
        end

    end % Loop through all questions

    save(['ExperimentData_' subjID '.mat'],'subjInfo','condition','correct','RT','answer_array','present_order','submission_timeout');

    sca;
catch
    sca;
    psychrethrow(psychlasterror);
end
