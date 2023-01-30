require 'spec_helper'

RSpec.describe Pipedrive::LeadLabel do
  subject { described_class.new('token') }

  describe '#entity_name' do
    subject { super().entity_name }

    it { is_expected.to eq('leadLabels') }
  end
end
