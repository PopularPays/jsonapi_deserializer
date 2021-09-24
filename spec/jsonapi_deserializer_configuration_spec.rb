require 'spec_helper'

describe JSONApi::Deserializer::Configuration do
  let(:payload_with_lids) do
    {
      data: {
        type: 'dogs',
        id: '1',
        lid: '1',
        relationships: {
          owner: {
            data: {
              lid: '1',
              type: 'users',
              color: 'grey'
            }
          }
        }
      },
      included: [
        {
          type: 'users',
          lid: '1',
          attributes: {
            name: 'Amorcito'
          }
        }
      ]
    }
  end

  let(:payload_no_lids) do
    {
      data: {
        type: 'dogs',
        id: '1',
        relationships: {
          owner: {
            data: {
              type: 'users',
              color: 'grey'
            }
          }
        }
      },
      included: [
        {
          type: 'users',
          attributes: {
            id: '1',
            name: 'Amorcito'
          }
        }
      ]
    }
  end

  subject { JSONApi::Deserializer.new(payload_with_lids).deserialized_hash }

  describe 'support_lids option' do
    context 'default option - true' do
      it 'is the default' do
        expect(JSONApi::Deserializer.configuration.support_lids).to eq(true)
      end

      it 'includes lid property deserialized hash' do
        expect(subject.keys).to contain_exactly('id', 'lid', 'owner')
        expect(subject.owner.keys).to contain_exactly('id', 'lid', 'name')

        expect(subject.lid).to eq('1')
        expect(subject.owner.lid).to eq('1')
      end
    end

    context 'option - false' do
      before do
        JSONApi::Deserializer.configure do |config|
          config.support_lids = false
        end
      end

      after do
        JSONApi::Deserializer.configure do |config|
          config.support_lids = true
        end
      end

      it 'does not include lid property in the deserialized hash' do
        expect(subject.keys).to contain_exactly('id', 'owner')
        expect(subject.owner.keys).to contain_exactly('id','name')
      end
    end

    context 'payload without lids' do
      subject { JSONApi::Deserializer.new(payload_no_lids).deserialized_hash }

      it 'includes lid property deserialized hash' do
        expect(subject.keys).to contain_exactly('id', 'lid', 'owner')
        expect(subject.owner.keys).to contain_exactly('id', 'lid', 'name')

        expect(subject.lid).to eq(nil)
        expect(subject.owner.lid).to eq(nil)
      end

      context 'option - false' do
        before do
          JSONApi::Deserializer.configure do |config|
            config.support_lids = false
          end
        end

        after do
          JSONApi::Deserializer.configure do |config|
            config.support_lids = true
          end
        end

        it 'does not include lid property in the deserialized hash' do
          expect(subject.keys).to contain_exactly('id', 'owner')
          expect(subject.owner.keys).to contain_exactly('id','name')
        end
      end
    end
  end
end
