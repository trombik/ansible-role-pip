require "spec_helper"
require "serverspec"

packages = case os[:family]
           when "freebsd"
             ["py27-pip", "py37-pip"]
           end
pip_executables = case os[:family]
                  when "freebsd"
                    ["/usr/local/bin/pip-2.7", "/usr/local/bin/pip-3.7"]
                  end
pip_packages = ["platformio"]

packages.each do |p|
  describe package(p) do
    it { should be_installed }
  end
end

pip_executables.each do |e|
  describe command("#{e} --version") do
    its(:exit_status) { should eq 0 }
    its(:stderr) { should eq "" }
    its(:stdout) { should match(/^pip\s+\d+\.\d+\.\d+\s/) }
  end
end

pip_packages.each do |p|
  describe package(p) do
    let(:disable_sudo) { true }
    it { should be_installed.by("pip") }
  end
end

pip_packages.each do |p|
  describe package(p) do
    it { should_not be_installed.by("pip") }
  end
end

describe file ".local" do
  it { should exist }
  it { should be_directory }
  it { should be_owned_by "vagrant" }
end

describe file ".local/bin/pio" do
  it { should exist }
  it { should be_file }
  it { should be_owned_by "vagrant" }
end

describe command ".local/bin/pio --version" do
  let(:disable_sudo) { true }
  its(:exit_status) { should eq 0 }
  its(:stderr) { should eq "" }
  its(:stdout) { should match(/PlatformIO,\s+version\s+\d+\.\d+\.\d+/) }
end

describe command "pio --version" do
  its(:exit_status) { should_not eq 0 }
end
