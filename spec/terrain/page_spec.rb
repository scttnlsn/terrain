require 'spec_helper'

describe Terrain::Page do
  let!(:records) { create_list(:example, 10) }
  let(:scope) { Example.all }
  let(:empty_scope) { Example.where('1 = 0') }
  let(:range) { '0-4' }
  let(:page) { described_class.new(scope, range) }

  describe '#bounds' do
    subject { page.bounds }

    it { is_expected.to eq [0, 4] }

    context 'with empty range' do
      let(:range) { '5-5' }

      it { is_expected.to eq [5, 5] }
    end

    context 'with no upper bound' do
      let(:range) { '5-' }

      it { is_expected.to eq [5, 9] }
    end

    context 'with no lower bound' do
      let(:range) { '-5' }

      it { is_expected.to eq [0, 5] }
    end

    context 'with invalid range' do
      let(:range) { '3-2' }

      it { expect { subject }.to raise_error described_class::RangeError }
    end

    context 'with invalid upper bound' do
      let(:range) { '5-x' }

      it { expect { subject }.to raise_error described_class::RangeError }
    end
  end

  describe '#count' do
    subject { page.count }

    it { is_expected.to eq 10 }

    context 'with no records' do
      let(:scope) { empty_scope }

      it { is_expected.to eq 0 }
    end
  end

  describe '#records' do
    subject { page.records }

    it { is_expected.to eq records[0..4] }

    context 'with fewer records than requested range' do
      let(:range) { '5-14' }

      it { is_expected.to eq records[5..-1] }
    end
  end

  describe '#content_range' do
    subject { page.content_range }

    it { is_expected.to eq '0-4/10' }

    context 'with fewer records than requested range' do
      let(:range) { '5-14' }

      it { is_expected.to eq '5-9/10' }
    end

    context 'with no records' do
      let(:scope) { empty_scope }

      it { is_expected.to eq '*/0' }
    end
  end
end
