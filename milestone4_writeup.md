We've implemented four changes for this milestone.

First, we specified the objective of the app by adding a use case below the title : "Need to encourage mental health check-ups ? Consider these factors". Our goal in doing so was to manage users' expectations before they start exploring the app.

Secondly, we improved the aesthetics of the graphs. We enhanced the readability of the plots titles by removing the borders and the colored background. We also removed the unnecessary extra space between the X-axis and the graphs as we do not have any negative values. 

![Graphs Before](Plots-before.PNG)

![Graphs After](Plots-after.PNG)

Furthermore, we clarified the usage of the filters by making the labels more descriptive. Previously, it was not clear that the `Type` filter only applies to the graphs while the `Country` and `Age` filters apply to both the data and the graphs.  We changed the labels to `Graph` filters and ` Data & Graphs` filters, respectively. 

![Filters Before](Filters-before.PNG)

![Filters After](Filters-after.PNG)

Lastly, we’ve realized that we have the following bug when no data is selected: "An error has occurred. Check your logs or contact the app author for clarification". We were not able to fix it given the time constraint, but we changed the error message to "Please select a country or age group". However, we still have a transition lag that lasts few seconds when switching tabs.
