# Milestone 4 Writeup

Authors: Patrick Tung, Orphelia Ellogne

## What changes did we make?

We've implemented four changes for this milestone.

First, we specified the objective of the app by adding a use case below the title : "Need to encourage mental health check-ups ? Consider these factors". Our goal in doing so was to manage users' expectations before they start exploring the app.

![](img/use_case.PNG)

Secondly, we improved the aesthetics of the graphs. We enhanced the readability of the plots titles by removing the borders and the colored background. We also removed the unnecessary extra space between the X-axis and the graphs as we do not have any negative values. 

**Before**

![Graphs Before](img/Plots-before.PNG)

**After**

![Graphs After](img/Plots-after.PNG)

Furthermore, we clarified the usage of the filters by making the labels more descriptive. Previously, it was not clear that the `Type` filter only applies to the graphs while the `Country` and `Age` filters apply to both the data and the graphs.  We changed the labels to `Graph` filters and ` Data & Graphs` filters, respectively. 

**Before**

![Filters Before](img/Filters-before.PNG)

**After**

![Filters After](img/Filters-after.PNG)

Lastly, we’ve realized that we have the following bug when no data is selected: "An error has occurred. Check your logs or contact the app author for clarification". We were not able to fix it given the time constraint, but we changed the error message to "Please select a country or age group". However, we still have an error that shows up when transitioning between tabs upon starting the app.

## What would we do differently?

If we were to make the app again we would change the creation process. First, when we were assigned this project, we put a heavy emphasis on fancy designs instead of focusing on meaningful features that are aligned with our app's objective . Since this was our first visualization app, we wanted to develop an application that was fancy and “cool-looking”. For example, we envisioned maps and other features that were “cool” to have. However, as the project progressed, we realized that many of these features were simply for show and provided little to no meaning to the application. This ended up wasting some of our time that could have been spent on other essential functions. The second thing that we would change builds off of this idea. We would get feedback from our peers and/or TAs on our app sketch before implementing our ideas. Talking through our plan with a third party would help us identify the disconnect between the end goal and the product features. This was one of the main insights of the fly-on-the-wall and informed-run cycles of the feedback session.

## What challenges did we face?

To be honest, while developing our visualization app, we did not really encounter any really large problems. However, we did have some small obstacles every here and there. For example, we noticed that `ggplotly` and `ggplot` did not really work with each other really well. When we converted our graphs from `ggplot` to utilize `ggplotly`, the positioning of our legend labels moved. After a long time of Googling and reading the documentations, we realized that `ggplotly` had some issues when dealing with legend positions from `ggplot`. It ended up taking us a couple of hours to finally resolve this issue using a workaround. Ultimately, the problems that we encountered when developing the app were not difficult. However, they were definitely time consuming as they all required extensive research. These issues only occurred because we were unfamiliar with developing Shiny Apps. I am sure that the next time we create something like this, the process will be much smoother.
