require "rails_helper"

RSpec.describe ReservationsHandler, type: :service do
  let(:user) { User.new }
  let(:book) { Book.new }
  subject { described_class.new(user, book) }

  describe '#reserve' do
    before {
      expect(subject).to receive(:can_reserve?).and_return(can_be_reserved)
    }

    context 'without available book' do
      let(:can_be_reserved) { false }

      it {
        expect(subject.reserve).to eq('Book is not available for reservation')
      }
    end

    context 'with available book' do
      let(:can_be_reserved) { true }

      before {
        expect(book).to receive_message_chain(:reservations, :create).with(no_args).
        with(user: user, status: 'RESERVED').and_return(true)
      }

      it {
        expect(subject.reserve).to be_truthy
      }
    end
  end

  describe '#take' do
    before {
      expect(subject).to receive(:can_take?).and_return(can_be_taken)
    }

    context 'cannot be taken' do
      let(:can_be_taken) { false }

      it {
        expect(subject.take).to eq('Book is not available for borrowing')
      }
    end

    context 'can be taken' do
      let(:can_be_taken) { true }

      before {
        expect(subject).to receive_message_chain(:available_reservation, :present?).
        and_return(reservation_made)
      }

      context 'book was reserved' do
        let(:reservation_made) { true }
        let(:reservation) { Reservation.new }

        before {
          expect(subject).to receive(:available_reservation).and_return(reservation)

          expect(reservation).to receive(:update_attributes).
          with(status: 'TAKEN').and_return(true)
        }

        it {
          expect(subject.take).to be_truthy
        }
      end

      context 'book was not reserved' do
        let(:reservation_made) { false }

        before {
          expect(book).to receive_message_chain(:reservations, :create).with(no_args).
          with(user: user, status: 'TAKEN').and_return(true)
        }

        it {
          expect(subject.take).to be_truthy
        }
      end
    end
  end
end