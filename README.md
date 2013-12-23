rails_lite
==========


In this exercise I broke down and recreated what a rails does for you under the hood.  This gave me a better understanding of some of the 'magic'.

Some of the components include:



 #Router

The router which consists of a Router Class and Route Class.

A **route** holds a pattern to match to requests, the http verb associated, a controller, and the specific action. The route needs to be able to: 

- to take a request and determine if the pattern and method match

- execute the disired method in an instance of the desired controller with the included parameters

The **router** holds a list of routes which are initialized through the draw method which takes a proc and evaluates the http verb. The router upon request is able to match it to route.

 #Base Controller

The base controller provides access to the session and params and enables rendering.
 
 #Params

This pulls the query and the body from the XMLHttpRequest.  Recursively goes through the body building a potentially nested hash of parameters.  Then merges this data with query string.
The ending result being able to call "params"

 #Session

The session class provides interface with the webrick cookie.
