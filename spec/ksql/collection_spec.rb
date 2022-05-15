# frozen_string_literal: true

RSpec.describe Ksql::Collection do
  it 'Acts as Enumerable' do
    res = described_class.new({
      'queryId' => 'foo',
      'columnNames' => ['foo', 'bar']
    }, [ ['foo', 'bar'], [ 'bar', 'foo' ] ])
    expect(res.class).to eq(Ksql::Collection)
    expect(res.rows.class).to eq(Array)
    expect(res.methods.include? :each).to eq(true)
  end
end
