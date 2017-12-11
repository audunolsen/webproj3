# webproj3
IMT3891 Webproject III – Group assignment

![Image of proposed solution](webcap.png)

**This repository houses Group 1's solution to "Webproject 3", an assignment at NTNU** (Norwegian University of Science and Technology).

### Group members
@audunolsen, @susannews, @SiljeLien87 & @MartineJacobsen

### About our codebase
To view/work on this codebase locally, you'll need *Node*, *npm*, *Bower* and *GruntJS* installed. 

1. Clone the repository
1. Run ```npm install``` from the where you cloned the directory to
1. Run grunt
	* ```$ grunt``` to compile code once, making it browser compatible
	* ```$ grunt env``` to compile first if needed, followed by a watch event listening for changes. BrowserSync will also start, launching the project in your default browser.
	
### Deployed version
Our web solution is available at http://web3.graknitstudio.no
**NOTE!** This webpage interacts with an apache SOLR core through ajax. when entering a search query, the browser will prompt for login credentials. We were unable to fix this due to time constraints. 
Credentials:
* User: *user*
* Password: *cnzyCXC2XAdV*
*No harm can be done with these login credentials alone, so including them in a github README isn't as stupid as it looks.*