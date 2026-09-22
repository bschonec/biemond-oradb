# frozen_string_literal: true

require 'spec_helper'

describe 'oradb::tnsnames' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }
      let(:title) { 'test' }
      let(:params) do
        {
          oracle_home: '/tmp',
          user: 'oracle',
          group: 'dba',
          connect_service_name: 'service_name',
        }
      end

      it { is_expected.to compile }

      context 'with default parameters' do
        it {
          is_expected.to contain_concat('/tmp/network/admin/tnsnames.ora').with(
            owner: 'oracle',
            group: 'dba',
            ensure: 'present',
            mode: '0774'
          )
          is_expected.to contain_concat_fragment('test').with(
            target: '/tmp/network/admin/tnsnames.ora',
            content: %r{
            ^test =$
            ^\s{2} \(DESCRIPTION =$
            }
          )
        }
      end

      context 'with custom parameters' do
        let(:params) do
          {
            oracle_home: '/tmp',
            user: 'user',
            group: 'group',
            mode: '1654',
            connect_service_name: 'service_name',
          }
        end

        it {
          is_expected.to contain_concat('/tmp/network/admin/tnsnames.ora').with(
            owner: 'user',
            group: 'group',
            ensure: 'present',
            mode: '1654'
          )
        }
      end
    end
  end
end
