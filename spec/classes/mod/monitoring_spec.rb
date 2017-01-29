require 'spec_helper'

describe 'icingaweb2::mod::monitoring', :type => :class do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let :facts do
        facts
      end

      let :pre_condition do
        'include ::icingaweb2'
      end

      context 'with default parameters' do
        %w(backends config commandtransports).each do |config_file|
          it do
            mode = '0644'
            mode = '0664' if facts[:osfamily] == 'RedHat'

            should contain_file("/etc/icingaweb2/modules/monitoring/#{config_file}.ini").
              with(
                'owner' => 'icingaweb2',
                'group' => 'icingaweb2',
                'mode'  => mode,
              )
          end
        end

        it { should contain_ini_setting('security settings').with(
            'section' => 'security',
            'setting' => 'protected_customvars',
            'value'   => /community/,
            'path'    => /\/config.ini$/
          )
        }
        it { should contain_ini_setting('backend ido setting').with(
            'section' => 'icinga_ido',
            'setting' => 'type',
            'value'   => 'ido',
            'path'    => /\/backends.ini$/
          )
        }
        it { should contain_ini_setting('backend resource setting').with(
            'section' => 'icinga_ido',
            'setting' => 'resource',
            'value'   => 'icinga_ido',
            'path'    => /\/backends.ini$/
          )
        }
        it { should contain_ini_setting('command transport setting').with(
            'section' => 'icinga2',
            'setting' => 'transport',
            'value'   => 'local',
            'path'    => /\/commandtransports.ini$/
          )
        }
        it { should contain_ini_setting('command transport path setting').with(
            'section' => 'icinga2',
            'setting' => 'path',
            'value'   => '/var/run/icinga2/cmd/icinga2.cmd',
            'path'    => /\/commandtransports.ini$/
          )
        }
      end

      context 'with transport parameters' do
        let :params do
          {
            transport: 'remote',
            transport_host: 'icinga-master1',
            transport_user: 'icingaweb2',
            transport_port: 2222,
            transport_path: '/run/icinga2/icinga2.cmd'
          }
        end

        it do
          should contain_ini_setting('command transport setting').with(
            'section' => 'icinga2',
            'setting' => 'transport',
            'value'   => 'remote',
            'path'    => /\/commandtransports.ini$/
          )
        end
        it do
          should contain_ini_setting('command transport host setting').with(
            'section' => 'icinga2',
            'setting' => 'host',
            'value'   => 'icinga-master1',
            'path'    => /\/commandtransports.ini$/
          )
        end
        it do
          should contain_ini_setting('command transport port setting').with(
            'section' => 'icinga2',
            'setting' => 'port',
            'value'   => '2222',
            'path'    => /\/commandtransports.ini$/
          )
        end
        it do
          should contain_ini_setting('command transport user setting').with(
            'section' => 'icinga2',
            'setting' => 'user',
            'value'   => 'icingaweb2',
            'path'    => /\/commandtransports.ini$/
          )
        end
        it do
          should contain_ini_setting('command transport path setting').with(
            'section' => 'icinga2',
            'setting' => 'path',
            'value'   => '/run/icinga2/icinga2.cmd',
            'path'    => /\/commandtransports.ini$/
          )
        end
      end
    end
  end
end
