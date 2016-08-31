# RedditTest
1- At the beginning I have created the models, first in the RedditTest.xcdatamodeld and after that I create the managed 
object (Feed).
2- I Have Started working with managers. at first time I made the CoreDataManager, this class initialises CoreData and
I Have made some methods for creating, getting, deleting, and saving data.
3- The second was ConnectionManager. I make the request and I get the data from the server and I created other method
for downloading images and I Have added another method to verify de connection.
4- The FeedManager uses the ConnectionManager for requesting data and CoreDataManager for storing the data. This Manager
will be used for the controllers for requesting data.
5- After that I Have Started with the controllers, I made a TableViewController and CollectionViewController, 
both inherited from BaseViewController. In the BaseViewController I put the common methods of both Controllers and 
in Table I put the related with the Tables and in the Collection all the related with the Collections.
From the  BaseViewController I use the FeedManager to get data or reset the data.
6- After all this I create the FullScreenViewController with the functions to see a full pic from an url and save it 
a picture.
7- While I was making the Controllers I was creating the layout in the Storyboard and making structs, protocols
and extensions.
