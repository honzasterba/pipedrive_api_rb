# frozen_string_literal: true

require 'spec_helper'

RSpec.describe ::Pipedrive::Person do
  subject { described_class.new('token') }

  describe '#entity_name' do
    subject { super().entity_name }

    it { is_expected.to eq('persons') }
  end

  describe '#search' do
    it 'calls #make_api_call with term' do
      expect(subject).to receive(:make_api_call).with(:get, 'search', { term: 'term', :start=>0 })
      expect { |b| subject.search('term', &b) }.to yield_successive_args
    end

    it 'calls #make_api_call with term and search_by_email' do
      expect(subject).to receive(:make_api_call).with(:get, 'search', { term: 'term', fields: "email", :start=>0 })
      expect { |b| subject.search('term', "email", &b) }.to yield_successive_args
    end

    it 'yields results' do
      expect(subject).to receive(:make_api_call).with(:get, 'search', { term: 'term', start: 0 }).
        and_return(::Hashie::Mash.new(data: [1, 2], success: true))
      expect { |b| subject.search('term', &b) }.to yield_successive_args(1, 2)
    end
  end
end
