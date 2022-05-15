# frozen_string_literal: true

RSpec.describe Ksql::Error do
  it 'is an OpenStruct' do
    error = Ksql::Error.new({ status: 400, message: 'ksqlDB Error' })
    expect(error.class).to eq(Ksql::Error)
    expect(error.status).to eq(400)
    expect(error.message).to eq('ksqlDB Error')
  end
end
