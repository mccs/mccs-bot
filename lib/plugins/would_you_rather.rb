require 'net/http'
require 'cinch'
require 'json'

class WouldYouRather
  include Cinch::Plugin

  @@api_key = 'tEtPzUcEVQ6dcKwCrEmsxwcBNrgKRMZQ9F7tHEXJ'

  match /wyr$/, :method => :on_question_request
  match /wyrd$/, :method => :on_dirty_question_request
  match /vote (\d*) ([0|1])/, :method => :vote

  def on_question_request(m)
    handle_question_request(m, 1)
  end

  def on_dirty_question_request(m)
    handle_question_request(m, 2)
  end

  def handle_question_request(m, category)
    # get a random question
    response = Net::HTTP.get_response('wouldyouratherapp.com',
      '/api/questions/random?category=' + category.to_s + '&get_comments=0&X-API-KEY=' +
      @@api_key)
    # parse the json and output it
    json = JSON.parse(response.body)
    m.reply('Would YOU Rather ' + json['data']['question']['part0'] +
      ' OR ' + json['data']['question']['part1'])
    m.reply('To vote reply with ?vote ' + json['data']['question']['id'] +
      ' (0 or 1)!')
  end

  def vote(m, q_id, choice)
    # Send in the vote!
    response = Net::HTTP.get_response('wouldyouratherapp.com',
      '/api/vote?q_id=' + q_id.to_s + '&choice=' + choice.to_s + '&X-API-KEY=' + @@api_key)
    json = JSON.parse(response.body)
    # Check to make sure that it worked
    if json['status'] == 'success'
      # We do some fancy stuff with the API which is why we have to make a second
      # call in order to get the vote counts
      response = Net::HTTP.get_response('wouldyouratherapp.com',
      '/api/questions/?q_id=' + q_id.to_s + '&get_comments=0&X-API-KEY=' + @@api_key)
      json = JSON.parse(response.body)
      # Add up the total amount of votes
      total_votes = (json['data']['results']['votes0'].to_i + json['data']['results']['votes1'].to_i)
      # Calculate the percentages of each
      vote_0_percentage = ((json['data']['results']['votes0'].to_i / total_votes.to_f) * 100).to_i
      vote_1_percentage = (100 - vote_0_percentage).to_i
      # Output the results!
      m.reply('Vote counted! First option had ' + json['data']['results']['votes0'] +
        ' votes (' + vote_0_percentage.to_s + '%) and the second option had ' +
        json['data']['results']['votes1'] + ' votes (' + vote_1_percentage.to_s + '%)!')
    else
      # There was a server error. Most likely someone didn't use the vote command properly
      m.reply('Error while casting vote.')
    end
  end
end
