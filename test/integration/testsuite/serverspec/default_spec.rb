# Encoding: utf-8

require_relative 'spec_helper'

describe 'kvexpress::default' do
  describe package('kvexpress') do
    it { should be_installed }
  end

  describe service('consul') do
    it { should be_running }
  end

  describe file('/usr/local/bin/kvexpress') do
    it { should be_file }
  end

  describe file('/etc/testing-kvexpress/') do
    it { should be_directory }
  end

  describe file('/etc/testing-kvexpress/features-test.ini') do
    it { should be_file }
    it { should be_mode 644 }
    it { should be_owned_by 'dog' }
    it { should be_grouped_into 'dog' }
    it { should contain 'You have 7 unread messages.' }
  end

  describe file('/etc/testing-kvexpress/features-compressed.ini') do
    it { should be_file }
    it { should be_mode 644 }
    it { should be_owned_by 'dog' }
    it { should be_grouped_into 'dog' }
    it { should contain 'You have 7 unread messages.' }
  end

  describe file('/etc/testing-kvexpress/another.ini') do
    it { should be_file }
    it { should be_mode 750 }
    it { should be_owned_by 'dog' }
    it { should be_grouped_into 'dog' }
    it { should contain 'You have 7 unread messages.' }
  end

  files = ['/etc/testing-kvexpress/testing.ini',
           '/etc/kvexpress-test.ini',
           '/etc/kvexpress-test-quoting.ini']

  files.each do |tfile|
    describe file(tfile) do
      it { should be_file }
      it { should be_mode 640 }
      it { should be_owned_by 'root' }
      it { should be_grouped_into 'root' }
      it { should contain 'You have 7 unread messages.' }
    end
  end

  describe file('/etc/consul.d/key-watch-another-one.json') do
    it { should contain "kvexpress out -k features.ini -f /etc/testing-kvexpress/another.ini -l 100 -c 00750 -d true -o dog -e 'w'" }
  end

  describe file('/etc/consul.d/key-watch-etc.json') do
    it { should contain "kvexpress out -k features.ini -f /etc/kvexpress-test.ini -l 10 -c 00640 -d true -e 'uptime'" }
  end

  describe file('/etc/consul.d/key-watch-features.json') do
    it { should contain "kvexpress out -k features.ini -f /etc/testing-kvexpress/features-test.ini -l 100 -c 00644 -d true -o dog -e 'w'" }
  end

  describe file('/etc/consul.d/key-watch-features-compressed.json') do
    it { should contain "kvexpress out -k features-compressed -f /etc/testing-kvexpress/features-compressed.ini -l 10 -c 00644 -d true -o dog -e 'w' -z true" }
  end

  describe file('/etc/consul.d/key-watch-quoting.json') do
    it { should contain "kvexpress out -k features.ini -f /etc/kvexpress-test-quoting.ini -l 10 -c 00640 -d true -e 'consul exec -service consul \\\"sudo w\\\"'" }
  end

  describe file('/etc/consul.d/key-watch-testing.json') do
    it { should contain 'kvexpress out -k features.ini -f /etc/testing-kvexpress/testing.ini -l 10 -c 00640 -d true' }
  end

  describe file('/etc/consul.d/key-watch-features_canary.json') do
    it { should contain '/kvexpress/canary/features.ini/checksum' }
  end

  describe file('/etc/should-never-exist.ini') do
    it { should_not be_file }
  end

  describe file('/etc/consul-is-dead-but-i-am-still-here.ini') do
    it { should be_file }
  end

  describe file('/etc/consul.d/key-watch-failurethree.json') do
    it { should be_file }
  end

  describe file('/etc/consul.d/key-watch-datalayer-raw-test.json') do
    it { should be_file }
  end
end
