require "spec_helper"
require "serverspec"
require "pathname"

packages = case os[:family]
           when "freebsd"
             ["py38-pip"]
           when "ubuntu"
             ["python3-pip"]
           when "openbsd"
             ["py3-pip"]
           end
pip_executable = case os[:family]
                 when "freebsd"
                   "/usr/local/bin/pip-3.8"
                 when "ubuntu"
                   "/usr/bin/pip3"
                 when "openbsd"
                   "/usr/local/bin/pip3.8"
                 end
pip_packages = ["platformio"]
pip3_file = case os[:family]
            when "openbsd", "freebsd"
              "/usr/local/bin/pip3"
            else
              "/usr/bin/pip3"
            end

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

describe file pip3_file do
  it { should exist }
  case os[:family]
  when "openbsd", "freebsd"
    it { should be_symlink }
  else
    it { should be_file }
  end
end

describe command("pip3 --version") do
  its(:exit_status) { should eq 0 }
  its(:stderr) { should eq "" }
  its(:stdout) { should match(/^pip\s+\d+\.\d+\.\d+\s/) }
end

pip_packages.each do |p|
  describe command("pip3 list") do
    let(:disable_sudo) { true }
    its(:exit_status) { should eq 0 }
    its(:stderr) { should eq "" }
    its(:stdout) { should match(/#{p}/) }
  end

  describe package(p) do
    let(:disable_sudo) { true }
    it do
      pending "does not work on OpenBSD" if os[:family] == "openbsd"
      should be_installed.by("pip3")
    end
  end
end

pip_packages.each do |p|
  describe package(p) do
    it { should_not be_installed.by("pip3") }
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
  its(:stdout) { should match(/PlatformIO( Core)?,\s+version\s+\d+\.\d+\.\d+/) }
end

describe command "pio --version" do
  its(:exit_status) { should_not eq 0 }
end
