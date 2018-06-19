class ReservationsHandler
  def initialize(user, book)
    @user = user
    @book = book
  end

  def take
    return "Book is not available for borrowing" unless can_take?
    if available_reservation.present?
      available_reservation.update_attributes(status: 'TAKEN')
    else
      book.reservations.create(user: user, status: 'TAKEN')
    end
  end

  def give_back
    return "Can't give back book not borrowed by you" unless can_give_back?
    ActiveRecord::Base.transaction do
      book.reservations.find_by(status: 'TAKEN').update_attributes(status: 'RETURNED')
      next_in_queue.update_attributes(status: 'AVAILABLE') if next_in_queue.present?
    end
  end

  def reserve
    return "Book is not available for reservation" unless can_reserve?
    book.reservations.create(user: user, status: 'RESERVED')
  end

  def cancel_reservation
    book.reservations.where(user: user, status: 'RESERVED').order(created_at: :asc).first.update_attributes(status: 'CANCELED')
  end

  def can_take?
    not_taken? && ( available_for_user? || book.reservations.empty? )
  end

  def can_give_back?
    book.reservations.find_by(user: user, status: 'TAKEN').present?
  end

  def can_reserve?
    book.reservations.find_by(user: user, status: 'RESERVED').nil?
  end

  private
  attr_reader :user, :book

  def next_in_queue
    book.reservations.where(status: 'RESERVED').order(created_at: :asc).first
  end

  def not_taken?
    book.reservations.find_by(status: 'TAKEN').nil?
  end

  def available_for_user?
    if available_reservation.present?
      available_reservation.user == user
    else
      pending_reservations.nil?
    end
  end

  def pending_reservations
    book.reservations.find_by(status: 'PENDING')
  end

  def available_reservation
    book.reservations.find_by(status: 'AVAILABLE')
  end
end