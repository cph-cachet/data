%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Author:
%   Darius Adam Rohani et. al.
% Date: 
%   2019.11.13
% Input:
%   aText:          Activity text [string], 
%                   A written activity, e.g., "go for a walk"
% Requirements:
%   Stopwords_EnglishXL.txt                  
% Output:
%   outputText: A preprocessed activity text [string] with stopwords 
%   removed, porter stemming etc...
% Description:
%   A collection of pre-processing steps to reduce the input activity
%   sentence to a more general activity sentence that can be compared
%   across many different text inputs. 
%   Questions: daroh@dtu.dk   
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [outputText] = aTextPreprocess(aText)
%% Load extended stopwords:
stopW = 'Stopwords_EnglishXL.txt';
cur_Path = pwd;
stopwords_english = fullfile(cur_Path,stopW);
%Loading stop words in English:
fid = fopen(stopwords_english);
stopwords_list = textscan(fid,'%s','Delimiter',',','HeaderLines',1); 
stopwords_list = stopwords_list{1};
%Somehow it doesnt take the "a" in the beginning! Manually adding it! :
stopwords_list(end+1) = {'a'};
fclose(fid);


%% Process the text as follows
%Lower case everything:
outputText = lower(aText);
%Removing special characters!
outputText = regexprep(outputText,'[^a-zA-Z0-9Â≈¯ÿÊ∆+-/:\s]','');
%Remove dot and comma: 
outputText = strrep(outputText,'.','');
outputText = strrep(outputText,',','');
%Replace / with a space:
outputText = strrep(outputText,'/',' ');
%Remove whitespaces
outputText = strtrim(outputText);
%Remove stopwords: 
tempTokens = removeWords(tokenizedDocument(outputText),stopwords_list);
%Stemming:
tempTokens = normalizeWords(tempTokens);
%Remove long words:
tempTokens = removeLongWords(tempTokens,15);


outText = char(strjoin(string(tempTokens)));

%Remove whitespaces
outputText = strtrim(outText);

end