# Marvel Heroes
The app was created for the tech test for iOS developer position at Wallapop. 
The app communicates with the Public Marvel API lists the Marvel Characters in a collection view,  lets the user search the contents of this list and see the full details of any item from the collection.

# How the app is working
* The app is built on MVC (Model-View-Controller) architecture
* The Model (Character.swift) corresponds to the structure of the json returned by Marvel API
* The CharacterCell view is responsible for structuring and workig of elements for each cell in the collection view
* The CustomImageView fetches the image from the Marvel API, using the URL provided for each character in the API response.
  - Since the collection view cells are reusable, the images are cached so when the user scrolls down and back up, the images can be retrieved from cache rather than downloading them again
  - After the request to fetch the image has been sent and the image data comes back it is checked whether it should be placed in the cell since it may has been already reuse
* The ViewController is the root controller and it presents the user with collection view and the search bar on the top
  - It handels all the user's UI interaction, from searching for characters, through scrolling through the collection view, to showing the user activity indicator when the app is busy or a message when there was no results found
  - Includes search bar listener which fires search request 500 milliseconds after the user stopped typing in the search bar
  - The API can return at most 100 results per request therefore if there exists more characters than what is already downloaded and the user scrolling down reaches the bottom of the collection view, new request is fired to fetch another part of results
  - When user taps on any of the character cells, they are taken to the next view with the details of the selected character
* The DetailVC is a view controller displaying character's image, name and the description (if available)
* The APIRequest is doing all the work related to fetching characters from the Marvel API
  - Constructs the URL with properties, queries and the necessary elements like timestamp, public key and the hash
  - Data is decoded from json to the local character data model
* Extensions is created to hold UIView extension for setting up UI constraints with visual format
  
