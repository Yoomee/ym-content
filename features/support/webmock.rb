require 'webmock/cucumber'
WebMock.disable_net_connect!(:allow_localhost => true)


WebMock.stub_request(:get, /.*api.twitter.com\/1.1\/search\/tweets.json.*/).
  to_return(:status => 200, :body => "{}", :headers => { :content_type => 'json' })
