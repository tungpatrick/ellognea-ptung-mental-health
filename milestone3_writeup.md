# Milestone 3 Writeup


### Reflection on Usability
Reflect on the usability of your app. How easy or hard was it for your peers to use your app? Did you expect them to use the app in they way they did?

We received lots of feedback, both positive and negative, during the feedback session of the labs regarding the overall usability of our application. In general, much of the feedback was that it was quite easy to use as everything is labeled neatly and there is not much ambiguity in the features/functionalities of our app. Our peers were able to navigate and utilize every little detail that we included in our app functionalities. The applications were not used in ways that we did not intend it to, and therefore we think that it was quite easy for them to use. This may be the case because our functionalities are quite simple. For example, we have a filter sidebar by where you can select what you would like to filter the data with, and we have different tabs that show different information. We do believe that the simpleness to our project was deliberately designed, so that there would be no confusion. 


### How has our App from Milestone 2
We actually made quite a few changes coming from our Milestone 2. Similar to our ideology from last time, we made changes with the mindset that our visualization app needed to be better and more intuitive for the average users. As we have said in the proposal, we are creating an application that will facilitate employers to develop effective mental wellness programs. With that objective in our mind, we wished that employers will be able to easily use our application to visualize the relationships between the people who seek treatment against different variable. 

In general, since we optimized our code to create better aesthetics of the visualization app. The biggest changes we have made are the ways the graphs are portrayed. For example, we have removed the need of using multiple legends which allowed us to clear up some clutter. We also managed to fix the width of the bins for each bar chart even when there is no data that could be shown. **Don't really know how to explain this** Another big change we made was the placement of the contents in our sidebar. After moving the `selectInput` widgets to show up right underneath their corresponding checkbox, the filters became much more intuitive to use.

# MY SUGGESTION

### Usability of the feedback received and changed in project since Milestone 2

Our reviewers used the mental health explorer app as intended. They understood from the fly-on-the wall cycle that it was an app that explores factors that lead to employees seeking treatment for a mental illness. As per their feedback, this was made easier by the variable descriptions tab that facilitates the interpretability of the plots. The features of the filters were also appreciated.
Some reviewers suggested changing the y-axis from count to percentage and using stacked bars for comparison. However, we chose not to incorporate this feedback because the former does not add any new information and the latter is not appropriate for our app objective.
We, however, made four main changes:

1.	We removed the variable descriptions tab and added the descriptions as tooltips to the data table. This allows the users to understand the column names without going back and forth between tabs. 
2.	We used ggplot faceting to fix the y-axis of our plots and removed the repetitive legend. The additional white space makes our app more pleasant and the fixed y-axis facilitates comparisons between subplots.
3.	We made the width of the bars consistent. This makes it easier to identity a missing category.
4.	We made the filters more intuitive by moving the selectInput widgets below their corresponding checkboxes. 

Overall, we have received valuable suggestions that led to an improved app. We carefully considered each feedback while keeping in mind that visualizations should be simple and meaningful without overshadowing important information.
The fly-on-the-wall experience reiterated the importance of making an appealing standalone app that is easy to use.
