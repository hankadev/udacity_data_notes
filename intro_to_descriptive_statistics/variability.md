# Variability
__Range__ is the difference between the maximum value and the minimum value observed. It helps us to measure how spread out the distribution is. It is easy to compute and understand. It changes only when we add value lower that the current minimum or higher than the current maximum. Especially when outliers are present, the range therefore does not accurately represent the variability of data.

__Interquartile range:__ IQR = Q1 - Q3
* about 50 % of the data falls within the IQR
* IQR is not affected by every value in dataset
* IQR is not affected by outliers

__Outliers__ are compute by cutting off the tails (lower 25 % and upper 25 %). \
outlier < Q1 - 1.5 * IQR \
ourlier > Q3 + 1.5 * IQR

We can use __boxplot__ to visualize minimum, maximum, Q1 and Q3. Outliers are represented as dots. Boxplots can be  drawn as below or also sideways (shifted by 90 degrees).

![boxplot](https://github.com/hanny21/udacity_data_notes/blob/master/intro_to_descriptive_statistics/img/boxplot.PNG)

__Deviations from mean__ - calculating the distances of each value from the mean (value - mean).
__Average deviation__ is the average of the deviations from the mean. The value is zero, so the solution is either to use absolute values to calculate deviations or to square each deviation.
__Variance__ is mean of squared deviations (the sum of squared deviations divided by n).
__Standard deviation__ is the square root of the variance. It is the most common measure of spread. The symbol is lower case greek sigma.

![deviations](https://github.com/hanny21/udacity_data_notes/blob/master/intro_to_descriptive_statistics/img/deviations.PNG)
