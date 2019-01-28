# Milestone 3 Writeup

Authors: Patrick Tung, Orphelia Ellogne

### Reflection on App Usability & Feedback Process

We received lots of constructive feedback on the overall usability of our application during the feedback session of the labs. Our peers were able to navigate and utilize every little detail that we included in our app functionalities. They understood from the fly-on-the wall cycle that it was an app that explores factors that lead to employees seeking treatment for a mental illness. This was made easier by the variable descriptions tab that facilitates the interpretability of the plots. The features of the filters were also appreciated. For example, we have a filter sidebar that allows to filter the data on specific variables.

In general, we were told that the app was simple, yet still clear enough to help employers seek information on mental illness. Furthermore, the informed run and written feedback really helped us avoid any misunderstanding of any issues brought up by our peers.

### How has our App changed from Milestone 2

We made quite a few changes coming from our Milestone 2 with the mindset that our visualization app needed to be better and more intuitive for the average users. As said in the proposal, we are creating an application that will facilitate employers to develop effective mental wellness programs. With that objective in mind, we wished that employers will be able to easily use our application to visualize the relationships between different variables and the people who seek treatment for mental illness.
Since Milestone 2, we have made four main changes:

1.	We removed the variable descriptions tab and added the descriptions as tooltips to the data table. This allows the users to understand the column names without going back and forth between tabs.
2.	We used ggplot faceting to fix the y-axis of our plots and removed the repetitive legend. The additional white space makes our app more pleasant and the fixed y-axis facilitates comparisons between subplots.
3.	We made the width of the bars consistent. This makes it easier to identity a missing category.
4.	We made the filters more intuitive by moving the selectInput widgets below their corresponding checkboxes.

In general, we optimized our code to create better aesthetics of the visualization app. Some reviewers suggested changing the y-axis from count to percentage and using stacked bars for comparison. However, we chose not to incorporate this feedback because the former does not add any new information and the latter is not appropriate for our app objective.

To conclude, we feel that we have received valuable suggestions that led to an improved visualization app. We carefully considered each feedback while keeping in mind that visualizations should be simple and meaningful without overshadowing important information.
