//
//  JokeViewModel.swift
//  IOS_Test
//
//  Created by Prasoon Tiwari on 06/06/23.
//

import Foundation

class JokeViewModel {
    
    private var jokes: [Joke] = []
    let httpUtility:JokeServiceDelegate?
    
    init(httpUtility:JokeServiceDelegate?) {
        self.httpUtility = httpUtility
    }
    
    func getSavedJokes(completion:(_ jokes:[Joke]?) -> Void) {
        if let storedJokes = UserDefaultsManager.loadJokes() {
            self.jokes = storedJokes
            completion(self.jokes)
        }
        else
        {
            completion(nil)
        }
    }
    
    func fetchJoke(completion: @escaping (Result<[Joke], Error>) -> Void) {
        let jokeUrl = URL(string: ApiEndpoints.joke)!
        httpUtility?.fetchResponse(apiURL: jokeUrl) { (result: Result<String, Error>) in
            switch result {
            case .success(let resultString):
                let joke = Joke(joke: resultString)
                self.addJoke(joke)
                completion(.success(self.jokes))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    private func addJoke(_ joke: Joke) {
        jokes.append(joke)
        //replacing older joke with new one if more than 10
        //Required Jokes limit is 10
        if jokes.count > Constants.JokesLimit {
            jokes.removeFirst(jokes.count - Constants.JokesLimit)
        }
        // Save jokes in user defaults
        UserDefaultsManager.saveJokes(jokes)
    }
    
    func getJokes() -> [Joke] {
        return jokes
    }
}


