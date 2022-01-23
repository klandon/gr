title 'app'

control 'app-test' do
  title 'Ensure webserver is working'
  desc  "The server should return 200"
  impact 1.0

  describe http('http://localhost') do
    its('status') {should cmp 200}
  end

end