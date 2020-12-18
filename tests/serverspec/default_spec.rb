require "spec_helper"
require "serverspec"
require "pathname"

packages = case os[:family]
           when "freebsd"
             ["py37-pip"]
           when "ubuntu"
             ["python3-pip"]
           end
pip_executable = case os[:family]
                  when "freebsd"
                    "/usr/local/bin/pip-3.7"
                  when "ubuntu"
                    "/usr/bin/pip3"
                  end
pip_packages = ["platformio"]

packages.each do |p|
  describe package(p) do
    it { should be_installed }
  end
end

describe command("#{pip_executable} --version") do
  its(:exit_status) { should eq 0 }
  its(:stderr) { should eq "" }
  its(:stdout) { should match(/^pip\s+\d+\.\d+\.\d+\s/) }
end

pip_packages.each do |p|
  describe package(p) do
    let(:disable_sudo) { true }
    it { should be_installed.by(os[:family] == "ubuntu" ? "pip3" : "pip") }
  end
end

pip_packages.each do |p|
  describe package(p) do
    it { should_not be_installed.by(os[:family] == "ubuntu" ? "pip3" : "pip") }
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
