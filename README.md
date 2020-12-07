# README

The framework used for the assignment is Ruby on Rails. The business logic of the implementation of the core functionalities is found under `app/lib` directory. The fetching of the data can be found under directory `app/services`. The controllers are inside `app/controllers/v1` directory.

`RewardsSchema` class is the main class which accepts the input, validates it and organizes it into a hash called `customers` which contains `key - value` pairs where `key` is represented as the identifier and the value is an object of type `Customer`. `Customer` class is a class that I used to present the customers it has the following attributes: `identifier, recommended_by, accepted and points`, this class as well has the logic to add points to the customers that made the recommendation. Besides those classes there is an `Input` class which validates the input. There are two classes which can be used to present the data `Default` and `CalculatedPoints`. As well as a support module I added `RewardCalculator` where the logic of how to calculate the reward lives. 

For testing I have used rspec gem.

### Requirements:
 - `Ruby version 2.5.0p0`
 - `Bundler version 1.16.5`

### Installation:
 - `bundle install`

### Running Tests:
 - `bundle exec rspec`

### Run:
 - `rails s`
 
### Api endpoint for test
 - `curl -X POST localhost:3000/v1/rewards/calculate --data-binary @input.txt`
