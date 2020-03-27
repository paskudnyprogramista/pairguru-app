# frozen_string_literal: true

require 'rails_helper'

describe Clients::Apis::V1::Pairguru do
  subject { described_class.get_movie_by_title(movie_title) }

  let(:movie_title) { 'Some Title' }
  let(:failure_class) { Dry::Monads::Result::Failure }
  let(:success_class) { Dry::Monads::Result::Success }
  let(:expected_response_code) { 200 }
  let(:expected_response_body) { { data: {} }.to_json }
  let(:http_client_return_value) do
    OpenStruct.new(
      code: expected_response_code,
      body: expected_response_body
    )
  end

  describe '.get_movie_by_title' do
    before do
      allow_any_instance_of(HTTP::Client).to receive(:get).and_return(http_client_return_value)
    end

    context 'when response code is 200' do
      let(:expected_response_code) { 200 }

      it { expect(subject).to be_a(success_class) }
    end

    context 'when response code is not 200' do
      let(:expected_response_code) { 404 }

      it { expect(subject).to be_a(failure_class) }

      describe 'if response code is 301' do
        let(:failure_message) { 'Redirect' }
        let(:expected_response_code) { 301 }

        it 'returns redirect message' do
          _code, message = subject.failure

          expect(message).to eq(failure_message)
        end
      end

      describe 'if response code is 401' do
        let(:failure_message) { 'Unauthorized' }
        let(:expected_response_code) { 401 }

        it 'returns unauthorized message' do
          _code, message = subject.failure

          expect(message).to eq(failure_message)
        end
      end

      describe 'if response code is 429' do
        let(:failure_message) { 'Rate limit exceeded' }
        let(:expected_response_code) { 429 }

        it 'returns rate limit exceeded message' do
          _code, message = subject.failure

          expect(message).to eq(failure_message)
        end
      end

      describe 'if response code is 404' do
        let(:failure_message) { 'Invalid request' }
        let(:expected_response_code) { 404 }

        it 'returns invalid request message' do
          _code, message = subject.failure

          expect(message).to eq(failure_message)
        end
      end

      describe 'if response code is 500' do
        let(:failure_message) { 'Server error' }
        let(:expected_response_code) { 500 }

        it 'returns server error message' do
          _code, message = subject.failure

          expect(message).to eq(failure_message)
        end
      end

      describe 'if response code is 1000' do
        let(:failure_message) { 'Unknown error' }
        let(:expected_response_code) { 1000 }

        it 'returns unknown error message' do
          _code, message = subject.failure

          expect(message).to eq(failure_message)
        end
      end
    end

    context 'when cconnection failed' do
      let(:failure_message) { 'Could not fetch data from external service' }

      context 'when HTTP::ConnectionError occurred' do
        before do
          allow_any_instance_of(HTTP::Client).to receive(:get).and_raise(HTTP::ConnectionError)
        end

        it { expect(subject).to be_a(failure_class) }
        it { expect(subject.failure).to eq(failure_message) }
      end

      context 'when HTTP::TimeoutError occurred' do
        before do
          allow_any_instance_of(HTTP::Client).to receive(:get).and_raise(HTTP::TimeoutError)
        end

        it { expect(subject).to be_a(failure_class) }
        it { expect(subject.failure).to eq(failure_message) }
      end
    end
  end
end
