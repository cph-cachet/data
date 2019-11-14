## Recommending Activities for Mental Health and Well-being: Insights from Two User Studies
# Supplimentary files

The folder contains the Naive Bayes model pooled for all participants.
The model is written in Matlab R2018B.
It provides a recommendation whether a given activity would be positive for a general (non-personalized) user. 

The main file is: NBmodel.m
Descriptions are given inside the file. 

For a fast example:
1. Download the folder
2. Open Matlab and go into the folder location
3. Define following variables in the command window: 
	aText = "go for a walk";
	aLabel = "Movement";
	Clinicaluser = true;
4. Run the following command:
	[P_post] = NBmodel(Clinicaluser,aText,aLabel);
5. The NBmodel will display whether the given activity is a positive recommendation, 
   and output a relative posterior probability of that recommendation.