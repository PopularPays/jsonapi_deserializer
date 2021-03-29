require 'spec_helper'

describe JSONApi::Deserializer do
  context 'identification by id' do
    context 'collection responses' do
      it 'are turned into a collection of Hashies' do
        response = {
          data: [
            {
              type: 'dogs',
              id: 1,
              attributes: {
                name: 'fluffy'
              }
            },
            {
              type: 'dogs',
              id: 2,
              attributes: {
                name: 'spot'
              }
            }
          ]
        }

        hash = JSONApi::Deserializer.new(response).deserialized_hash
        expect(hash[0].id).to eq('1')
      end

      it 'with a has-one relationship is represented as a Hashie at the relationship key' do
        response = {
          data: [
            {
              type: 'dogs',
              id: 1,
              relationships: {
                owner: {
                  data: {
                    id: 41,
                    type: 'users'
                  }
                }
              }
            }
          ]
        }

        hash = JSONApi::Deserializer.new(response).deserialized_hash
        one_deserialized = hash[0]
        expect(one_deserialized.owner.id).to eq('41')
      end

      it 'with a has-one relationship is represented as a Hashie at the relationship key' do
        response = {
          data: [
            {
              type: 'dogs',
              id: 1,
              relationships: {
                owner: {
                  data: {
                    id: 2,
                    type: 'users'
                  }
                }
              }
            }
          ]
        }

        one_deserialized = JSONApi::Deserializer.new(response).deserialized_hash[0]
        expect(one_deserialized.owner.id).to eq('2')
      end

      it 'with a has-many relationship are represented as an array of Hashies at the relationship key' do
        response = {
          data: [
            {
              type: 'dogs',
              id: '1',
              relationships: {
                favorite_parks: {
                  data: [{
                    id: '11',
                    type: 'parks'
                  }]
                }
              },
              attributes: {
                name: 'fluffy'
              }
            }
          ]
        }

        one_deserialized = JSONApi::Deserializer.new(response).deserialized_hash[0]
        expect(one_deserialized.favorite_parks[0].id).to eq('11')
      end

      it 'with a embedded has-one relationship is represented as a Hashie with attributes at the relationship key' do
        response = {
          data: [{
            type: 'dogs',
            id: '1',
            relationships: {
              owner: {
                data: {
                  id: '1',
                  type: 'users'
                }
              }
            }
          }],
          included: [
            {
              type: 'users',
              id: '1',
              attributes: {
                name: 'Justin'
              }
            }
          ]
        }

        one_deserialized = JSONApi::Deserializer.new(response).deserialized_hash[0]
        expect(one_deserialized.owner.name).to eq('Justin')
      end

      it 'with a has-many embedded relationship are represented as an array of Hashies at the relationship key' do
        response = {
          data: [{
            type: 'dogs',
            id: '1',
            relationships: {
              favorite_parks: {
                data: [{
                  id: '11',
                  type: 'parks'
                }
              ]}
            }
          }],
          included: [
            {
              type: 'parks',
              id: '11',
              attributes: {
                name: 'Vista Calma'
              }
            }
          ]
        }

        one_deserialized = JSONApi::Deserializer.new(response).deserialized_hash[0]
        expect(one_deserialized.favorite_parks[0].name).to eq('Vista Calma')
      end
    end

    context 'member responses' do
      it 'are turned into a single Hashie' do
        response = {
          data:
            {
              type: 'dogs',
              id: '1',
              attributes: {
                name: 'fluffy'
              }
            }
        }

        one_deserialized = JSONApi::Deserializer.new(response).deserialized_hash
        expect(one_deserialized.id).to eq('1')
        expect(one_deserialized.name).to eq('fluffy')
      end

      it 'with a has-one relationship is represented as a Hashie at the relationship key' do
        response = {
          data:
            {
              type: 'dogs',
              id: '1',
              relationships: {
                owner: {
                  data: {
                    id: '1',
                    type: 'users'
                  }
                }
              },
              attributes: {
                name: 'fluffy'
              }
            }
        }

        one_deserialized = JSONApi::Deserializer.new(response).deserialized_hash
        expect(one_deserialized.owner.id).to eq('1')
      end

      it 'with a has-many relationship are represented as an array of Hashies at the relationship key' do
        response = {
          data:
            {
              type: 'dogs',
              id: '1',
              relationships: {
                favorite_parks: {
                  data: [{
                    id: '11',
                    type: 'parks'
                  }]
                }
              },
              attributes: {
                name: 'fluffy'
              }
            }
        }

        one_deserialized = JSONApi::Deserializer.new(response).deserialized_hash
        expect(one_deserialized.favorite_parks[0].id).to eq('11')
      end

      it 'with a embedded has-one relationship is represented as a Hashie with attributes at the relationship key' do
        response = {
          data: {
            type: 'dogs',
            id: '1',
            relationships: {
              owner: {
                data: {
                  id: '1',
                  type: 'users'
                }
              }
            }
          },
          included: [
            {
              type: 'users',
              id: '1',
              attributes: {
                name: 'Justin'
              }
            }
          ]
        }

        one_deserialized = JSONApi::Deserializer.new(response).deserialized_hash
        expect(one_deserialized.owner.name).to eq('Justin')
      end

      it 'with a has-many embedded relationship are represented as an array of Hashies at the relationship key' do
        response = {
          data: {
            type: 'dogs',
            id: '1',
            relationships: {
              favorite_parks: {
                data: [{
                  id: '11',
                  type: 'parks'
                }]
              }
            }
          },
          included: [
            {
              type: 'parks',
              id: '11',
              attributes: {
                name: 'Vista Calma'
              }
            }
          ]
        }

        one_deserialized = JSONApi::Deserializer.new(response).deserialized_hash
        expect(one_deserialized.favorite_parks[0].name).to eq('Vista Calma')
      end

      it 'with a embedded has-one relationship with its own relationships create deeply nested Hashies' do
        response = {
          data: {
            type: 'dogs',
            id: '1',
            relationships: {
              owner: {
                data: {
                  id: '1',
                  type: 'users'
                }
              }
            }
          },
          included: [
            {
              type: 'users',
              id: '1',
              relationships: {
                photos: {
                  data: [{id: 1, type: 'photos'}, {id:2, type: 'photos'}]
                }
              }
            }
          ]
        }

        one_deserialized = JSONApi::Deserializer.new(response).deserialized_hash
        expect(one_deserialized.owner.photos[1].id).to eq('2')
      end

      it 'with a embedded has-one relationship with its own relationships create deeply nested Hashies with data' do
        response = {
          data: {
            type: 'dogs',
            id: '1',
            relationships: {
              owner: {
                data: {
                  id: '1',
                  type: 'users'
                }
              }
            }
          },
          included: [
            {
              type: 'users',
              id: '1',
              relationships: {
                photos: {
                  data: [{id: 1, type: 'photos'}, {id:2, type: 'photos'}]
                }
              }
            },
            {
              id: 1,
              type: 'photos',
              size: 'large'
            },
            {
              id: 2,
              type: 'photos',
              size: 'small'
            }
          ]
        }

        one_deserialized = JSONApi::Deserializer.new(response).deserialized_hash
        expect(one_deserialized.owner.photos[1].id).to eq('2')
      end

    end

    it 'relationships can be nil' do
      response = {
        data: {
          type: 'dogs',
          id: '1',
          relationships: {
            owner: {
              data: nil
            }
          }
        }
      }

      one_deserialized = JSONApi::Deserializer.new(response).deserialized_hash
      expect(one_deserialized.owner).to be_nil
    end

    it 'can be referenecd by lid' do
        response = {
          data: {
            type: 'dogs',
            id: '1',
            relationships: {
              owner: {
                data: {
                  lid: '1',
                  type: 'users'
                }
              }
            }
          },
          included: [
            {
              type: 'users',
              lid: '1',
              attributes: {
                name: 'Justin'
              }
            }
          ]
        }

        one_deserialized = JSONApi::Deserializer.new(response).deserialized_hash
        expect(one_deserialized.owner.name).to eq('Justin')
    end

    context 'nested assocation' do
      let(:response) do
        {
          data: {
            type: 'dogs',
            id: '1',
            relationships: {
              owner: {
                data: {
                  type: 'owner',
                  id: '3'
                }
              }
            }
          }
        }
      end
      let(:record) { JSONApi::Deserializer.new(response).deserialized_hash }

      it 'allows the initialization of a Record with another Record' do
        expect(record.to_hash).to eq(JSONApi::Deserializer::Record.new(record).to_hash)
      end
    end
  end
  
  context 'identification by lid' do
    context 'collection responses' do
      it 'are turned into a collection of Hashies' do
        response = {
          data: [
            {
              type: 'dogs',
              lid: 'temp-1',
              attributes: {
                name: 'fluffy'
              }
            },
            {
              type: 'dogs',
              lid: 'temp-2',
              attributes: {
                name: 'spot'
              }
            }
          ]
        }

        hash = JSONApi::Deserializer.new(response).deserialized_hash
        expect(hash[0].lid).to eq('temp-1')
      end

      it 'with a has-one relationship is represented as a Hashie at the relationship key' do
        response = {
          data: [
            {
              type: 'dogs',
              lid: 1,
              relationships: {
                owner: {
                  data: {
                    lid: 41,
                    type: 'users'
                  }
                }
              }
            }
          ]
        }

        hash = JSONApi::Deserializer.new(response).deserialized_hash
        one_deserialized = hash[0]
        expect(one_deserialized.owner.lid).to eq('41')
      end

      it 'with a has-one relationship is represented as a Hashie at the relationship key' do
        response = {
          data: [
            {
              type: 'dogs',
              lid: 1,
              relationships: {
                owner: {
                  data: {
                    lid: 2,
                    type: 'users'
                  }
                }
              }
            }
          ]
        }

        one_deserialized = JSONApi::Deserializer.new(response).deserialized_hash[0]
        expect(one_deserialized.owner.lid).to eq('2')
      end

      it 'with a has-many relationship are represented as an array of Hashies at the relationship key' do
        response = {
          data: [
            {
              type: 'dogs',
              lid: '1',
              relationships: {
                favorite_parks: {
                  data: [{
                    lid: '11',
                    type: 'parks'
                  }]
                }
              },
              attributes: {
                name: 'fluffy'
              }
            }
          ]
        }

        one_deserialized = JSONApi::Deserializer.new(response).deserialized_hash[0]
        expect(one_deserialized.favorite_parks[0].lid).to eq('11')
      end

      it 'with a embedded has-one relationship is represented as a Hashie with attributes at the relationship key' do
        response = {
          data: [{
            type: 'dogs',
            lid: '1',
            relationships: {
              owner: {
                data: {
                  lid: '1',
                  type: 'users'
                }
              }
            }
          }],
          included: [
            {
              type: 'users',
              lid: '1',
              attributes: {
                name: 'Justin'
              }
            }
          ]
        }

        one_deserialized = JSONApi::Deserializer.new(response).deserialized_hash[0]
        expect(one_deserialized.owner.name).to eq('Justin')
      end

      it 'with a has-many embedded relationship are represented as an array of Hashies at the relationship key' do
        response = {
          data: [{
            type: 'dogs',
            lid: '1',
            relationships: {
              favorite_parks: {
                data: [{
                  lid: '11',
                  type: 'parks'
                }
              ]}
            }
          }],
          included: [
            {
              type: 'parks',
              lid: '11',
              attributes: {
                name: 'Vista Calma'
              }
            }
          ]
        }

        one_deserialized = JSONApi::Deserializer.new(response).deserialized_hash[0]
        expect(one_deserialized.favorite_parks[0].name).to eq('Vista Calma')
      end
    end

    context 'member responses' do
      it 'are turned into a single Hashie' do
        response = {
          data:
            {
              type: 'dogs',
              lid: '1',
              attributes: {
                name: 'fluffy'
              }
            }
        }

        one_deserialized = JSONApi::Deserializer.new(response).deserialized_hash
        expect(one_deserialized.lid).to eq('1')
        expect(one_deserialized.name).to eq('fluffy')
      end

      it 'with a has-one relationship is represented as a Hashie at the relationship key' do
        response = {
          data:
            {
              type: 'dogs',
              id: '1',
              relationships: {
                owner: {
                  data: {
                    lid: '1',
                    type: 'users'
                  }
                }
              },
              attributes: {
                name: 'fluffy'
              }
            }
        }

        one_deserialized = JSONApi::Deserializer.new(response).deserialized_hash
        expect(one_deserialized.owner.lid).to eq('1')
      end

      it 'with a has-many relationship are represented as an array of Hashies at the relationship key' do
        response = {
          data:
            {
              type: 'dogs',
              id: '1',
              relationships: {
                favorite_parks: {
                  data: [{
                    lid: '11',
                    type: 'parks'
                  }]
                }
              },
              attributes: {
                name: 'fluffy'
              }
            }
        }

        one_deserialized = JSONApi::Deserializer.new(response).deserialized_hash
        expect(one_deserialized.favorite_parks[0].lid).to eq('11')
      end

      it 'with a embedded has-one relationship is represented as a Hashie with attributes at the relationship key' do
        response = {
          data: {
            type: 'dogs',
            id: '1',
            relationships: {
              owner: {
                data: {
                  lid: '1',
                  type: 'users'
                }
              }
            }
          },
          included: [
            {
              type: 'users',
              lid: '1',
              attributes: {
                name: 'Justin'
              }
            }
          ]
        }

        one_deserialized = JSONApi::Deserializer.new(response).deserialized_hash
        expect(one_deserialized.owner.name).to eq('Justin')
      end

      it 'with a has-many embedded relationship are represented as an array of Hashies at the relationship key' do
        response = {
          data: {
            type: 'dogs',
            id: '1',
            relationships: {
              favorite_parks: {
                data: [{
                  lid: '11',
                  type: 'parks'
                }]
              }
            }
          },
          included: [
            {
              type: 'parks',
              lid: '11',
              attributes: {
                name: 'Vista Calma'
              }
            }
          ]
        }

        one_deserialized = JSONApi::Deserializer.new(response).deserialized_hash
        expect(one_deserialized.favorite_parks[0].name).to eq('Vista Calma')
      end

      it 'with a embedded has-one relationship with its own relationships create deeply nested Hashies' do
        response = {
          data: {
            type: 'dogs',
            id: '1',
            relationships: {
              owner: {
                data: {
                  id: '1',
                  type: 'users'
                }
              }
            }
          },
          included: [
            {
              type: 'users',
              id: '1',
              relationships: {
                photos: {
                  data: [{id: 1, type: 'photos'}, {lid:2, type: 'photos'}]
                }
              }
            }
          ]
        }

        one_deserialized = JSONApi::Deserializer.new(response).deserialized_hash
        expect(one_deserialized.owner.photos[1].lid).to eq('2')
      end

      it 'with a embedded has-one relationship with its own relationships create deeply nested Hashies with data' do
        response = {
          data: {
            type: 'dogs',
            id: '1',
            relationships: {
              owner: {
                data: {
                  lid: '1',
                  type: 'users'
                }
              }
            }
          },
          included: [
            {
              type: 'users',
              lid: '1',
              relationships: {
                photos: {
                  data: [{id: 1, type: 'photos'}, { lid:2, type: 'photos'}]
                }
              }
            },
            {
              id: 1,
              type: 'photos',
              size: 'large'
            },
            {
              lid: 2,
              type: 'photos',
              size: 'small'
            }
          ]
        }

        one_deserialized = JSONApi::Deserializer.new(response).deserialized_hash
        expect(one_deserialized.owner.photos[1].lid).to eq('2')
      end

    end

    it 'relationships can be nil' do
      response = {
        data: {
          type: 'dogs',
          id: '1',
          relationships: {
            owner: {
              data: nil
            }
          }
        }
      }

      one_deserialized = JSONApi::Deserializer.new(response).deserialized_hash
      expect(one_deserialized.owner).to be_nil
    end

    context 'nested assocation' do
      let(:response) do
        {
          data: {
            type: 'dogs',
            id: '1',
            relationships: {
              owner: {
                data: {
                  type: 'owner',
                  id: '3'
                }
              }
            }
          }
        }
      end
      let(:record) { JSONApi::Deserializer.new(response).deserialized_hash }

      it 'allows the initialization of a Record with another Record' do
        expect(record.to_hash).to eq(JSONApi::Deserializer::Record.new(record).to_hash)
      end
    end
  end
end
