# frozen_string_literal: true

require 'rails_helper'

describe Utils::RenderableError do
  subject(:error) { described_class.new :spec_status }

  describe '#new' do
    it 'creates an instance of Utils::RenderableError' do
      expect(error).to be_instance_of described_class
    end

    it 'sets status to provided value' do
      expect(error.status).to eq(:spec_status)
    end

    context 'without provided message' do
      it 'sets message to default value' do
        expect(error.message).to eq('Unspecified error')
      end
    end

    context 'with provided message' do
      subject(:error) { described_class.new :spec_status, 'message' }

      it 'sets message to provided value' do
        expect(error.message).to eq('message')
      end
    end
  end

  describe '.to_json' do
    context 'without parameters' do
      it 'generate output with missing code specification' do
        expect(error.to_json).to eq('{"code":null,"status":"spec_status","error":"Unspecified error"}')
      end
    end

    context 'with parameters (with status)' do
      let(:parameters) { { status: 42 } }

      it 'generate output with code specification' do
        expect(error.to_json(parameters)).to eq('{"code":42,"status":"spec_status","error":"Unspecified error"}')
      end
    end

    context 'with parameters (without status)' do
      let(:parameters) { { key: 'value' } }

      it 'generate output with missing code specification' do
        expect(error.to_json(parameters)).to eq('{"code":null,"status":"spec_status","error":"Unspecified error"}')
      end
    end
  end
end
