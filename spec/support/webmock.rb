require 'webmock/rspec'
WebMock.disable_net_connect!

#Stub API requests
RSpec.configure do |config|
  config.before(:each) do
    google_json = <<-JSON
    {
      "status": "OK",
      "results": [ {
                     "geometry": {
                       "location": {
                         "lat": 53.38112899999999,
                         "lng": -1.470085
                       }
                     }
      } ]
    }
    JSON
    stub_request(:get, %r|http://maps\.googleapis\.com/maps/api/geocode|).
      with(:headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'User-Agent'=>'Ruby'}).
      to_return(:status => 200, :body => google_json, :headers => {})

    stub_request(:get, "http://www.youtube.com/oembed?format=json&url=http://www.youtube.com/watch?v=qvmc9d0dlO").
      with(:headers => {'Accept'=>'*/*'}).
      to_return(:status => 404, :body => "", :headers => {})

  end
end
