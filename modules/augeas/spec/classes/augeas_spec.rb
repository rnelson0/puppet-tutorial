require 'spec_helper'

describe 'augeas' do

  context 'RHEL Based Distributions - Devel' do

      let(:facts) do
        {'osfamily' => 'RedHat',}
      end

      let(:params) do
        {'devel'    => true,}
      end

      it 'requires stdlib' do
        should contain_class('stdlib')
      end

      it 'requires ygrpms' do
        should contain_class('ygrpms')
      end

      it 'install augeas package' do
        should contain_package('augeas').with({
          'ensure'  => 'installed',
        })
      end

      it 'install augeas-libs package' do
        should contain_package('augeas-libs').with({
          'ensure'  => 'installed',
        })
      end

      it 'install augeas-devel package' do
        should contain_package('augeas-devel').with({
          'ensure'  => 'installed',
        })
      end

  end

  context 'RHEL Based Distributions - Non Devel' do

      let(:facts) do
        {'osfamily' => 'RedHat',}
      end

      let(:params) do
        {'devel'    => false, }
      end

      it 'requires stdlib' do
        should contain_class('stdlib')
      end

      it 'requires ygrpms' do
        should contain_class('ygrpms')
      end

      it 'install augeas package' do
        should contain_package('augeas').with({
          'ensure'  => 'installed',
        })
      end

      it 'install augeas-libs package' do
        should contain_package('augeas-libs').with({
          'ensure'  => 'installed',
        })
      end

      it 'DOES NOT install augeas-devel package' do
        should_not contain_package('augeas-devel').with({
          'ensure'  => 'installed',
        })
      end

  end

end
