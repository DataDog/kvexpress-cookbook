# Encoding: utf-8

describe 'kvexpress::default' do
  let(:chef_run) { ChefSpec::ServerRunner.converge(described_recipe) }

  it 'install apt-transport-https' do
    expect(chef_run).to install_package('apt-transport-https')
  end

  it 'adds the repository' do
    expect(chef_run).to add_apt_repository('kvexpress').with(
     uri: 'https://packagecloud.io/kvexpress/kvexpress/ubuntu',
     key: 'https://packagecloud.io/gpg.key'
    )
  end

  it 'install kvexpress' do
    expect(chef_run).to install_package('kvexpress')
  end
end
