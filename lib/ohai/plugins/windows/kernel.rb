#
# Author:: James Gartrell (<jgartrel@gmail.com>)
# Copyright:: Copyright (c) 2009 Opscode, Inc.
# License:: Apache License, Version 2.0
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

require 'ohai/mixin/wmi_metadata'

extend Ohai::Mixin::WmiMetadata

WIN32OLE.codepage = WIN32OLE::CP_UTF8

def machine_lookup(sys_type)
  return "i386" if sys_type.eql?("X86-based PC")
  return "x86_64" if sys_type.eql?("x64-based PC")
  sys_type
end

def os_lookup(sys_type)
  return "Unknown" if sys_type.to_s.eql?("0")
  return "Other" if sys_type.to_s.eql?("1")
  return "MSDOS" if sys_type.to_s.eql?("14")
  return "WIN3x" if sys_type.to_s.eql?("15")
  return "WIN95" if sys_type.to_s.eql?("16")
  return "WIN98" if sys_type.to_s.eql?("17")
  return "WINNT" if sys_type.to_s.eql?("18")
  return "WINCE" if sys_type.to_s.eql?("19")
  return nil
end

host = WMI::Win32_OperatingSystem.find(:first)
kernel[:os_info] = extract_wmi_properties_to_mash(host)

kernel[:name] = "#{kernel[:os_info][:caption]}"
kernel[:release] = "#{kernel[:os_info][:version]}"
kernel[:version] = "#{kernel[:os_info][:version]} #{kernel[:os_info][:csd_version]} Build #{kernel[:os_info][:build_number]}"
kernel[:os] = os_lookup(kernel[:os_info][:os_type]) || languages[:ruby][:host_os]

host = WMI::Win32_ComputerSystem.find(:first)
kernel[:cs_info] = extract_wmi_properties_to_mash(host)

kernel[:machine] = machine_lookup("#{kernel[:cs_info][:system_type]}")
