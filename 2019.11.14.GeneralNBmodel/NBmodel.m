%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Author:
%   Darius Adam Rohani et. al.
% Date: 
%   2019.11.13
% Input:
%   Clinicaluser:   Model for a destinct user group [Boolean]
%                   True indicates a cliniacal use case, False indicate a
%                   normal control use case.
%   aText:          Activity text [string], 
%                   A written activity, e.g., "go for a walk"
%   aLabel:         Activity label [1xn vector of strings],
%                   Category label(s) describing the type of activity. 
%                   For clinical use case choose between:
%                   1: Movement, 2: Work, 3: Spare time, 4: Daily living,
%                   5: Practical, 6: Social, 7: Other
%                   e.g.,: ["Social","Movement"]
%                   For non-clinical use case choose between:
%                   1: custom, 2: exercise, 3: food, 4: leisure, 5: other,
%                   6: sleep, 7: social, 8: work
% Requirements:
%   aTextPreprocess.m
%   if Clinicaluser == 1 -> 
%   clinical.mat
%   else 
%   non-clinical.mat                   
% Output:
%   P_post: [1x2 float vector] Relative posterior probability of either
%   class = 1 (Positive), or class = 2 (less Positive)
% Description:
%   Uses a NB model to calculate the relative posterior probability 
%   (P_post) on finding a specific activity positive.
%   See the paper for a description on how the probabilities for the
%   different words, labels and prior probability was calculated.
%   Questions: daroh@dtu.dk   
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


function [P_post] = NBmodel(Clinicaluser,aText,aLabel)
%Example:
%Clinicaluser = false;
%aText = "go for a walk";
%aLabel = ["Social","Movemenst"];

%%%%%% Preamble
class_descr = ["a positive recommendation", "less recommendable"];
P_post = zeros(1,2);
if Clinicaluser
    load clinical.mat...
        bagOfLabels bagOfWords P_A1 P_A1unknown P_A2 P_A2unknown P_prior
else
    load non-clinical.mat...
        bagOfLabels bagOfWords P_A1 P_A1unknown P_A2 P_A2unknown P_prior
end
%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%% Checks
for j = 1:length(aLabel)
    if ~any(strcmpi(aLabel(j),bagOfLabels))
        fprintf('[Warning] The label: "%s" does not exist; typo?\n',...
            aLabel(j));
    end
end

%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%% Preprocess input
aText_processed = aTextPreprocess(aText);
fprintf('[INFO] "%s" modified to the general wording: "%s"\n',...
    aText,aText_processed);
%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%% Get probability based on the text:
SplitAct = strsplit(aText_processed)';
uniqAct = unique(SplitAct);
for m = 1:2
    
   productPA1 = 1;
   for j = 1:length(uniqAct)
         idxAct = strcmpi(uniqAct(j),bagOfWords);
         if any(idxAct)
             val = P_A1(m,idxAct);
         else
             val = P_A1unknown(m);
         end
         productPA1 = productPA1*val;
   end
%%%%%%  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%% Get probability based on label
   uniqLab = unique(aLabel);
   productPA2 = 1;
   for j = 1:length(uniqLab)
         idxAct = strcmpi(uniqLab(j),bagOfLabels);
         if any(idxAct)
             val = P_A2(m,idxAct);
         else
             val = P_A2unknown(m);
         end
         productPA2 = productPA2*val;
   end
%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%% Calculate final relative (ignoring denominator) post. probability
   P_post(m) = P_prior(m) * productPA1 * productPA2;
%%%%%%
end
[~, classRes] = max(P_post);
fprintf('[RESULT] "%s" is %s\n',aText,class_descr(classRes)); 
end

