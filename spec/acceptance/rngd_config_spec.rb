describe 'rngd::config class', :unless => UNSUPPORTED_PLATFORMS.include?(fact('osfamily')) do
  it 'sets up rngd' do
    apply_manifest(%{
      class { 'rngd': }
    }, :catch_failures => true)
  end

  describe file("#{config}") do
    it { should be_file }
    its(:content) { should match line }
  end
end
