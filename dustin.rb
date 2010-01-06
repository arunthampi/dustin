require 'rubygems'
require 'sinatra'
require 'json'
require 'curb'

@@repo = ENV['repo']
@@username = ENV['username']
@@token = ENV['token']

post '/dustin/hook' do
  body = JSON.parse(params[:body] || '{}')
  
  unless body.empty?
    author = body['author_name']
    issue_body = body['body']
    discussion = body['discussion']
    
    issue_title = discussion['title']
    html_link = discussion['html_href']
    
    # Only post to GitHub if it is a problem
    if html_link =~ /\/discussions\/problems/
      Curl::Easy.http_post("http://github.com/api/v2/yaml/issues/open/#{@@username}/#{@@repo}",
                            Curl::PostField.content('login', @@username),
                            Curl::PostField.content('token', @@token),
                            Curl::PostField.content('title', "[TenderApp Discussion] #{issue_title} - #{html_link}"),
                            Curl::PostField.content('body', issue_body))
    end                                
  end
  
end