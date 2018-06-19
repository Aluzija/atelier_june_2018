class BookDecorator < Draper::Decorator
  delegate_all

  def can_take?
    reservation_handler.can_take?
  end

  def can_give_back?
    reservation_handler.can_give_back?
  end

  def can_reserve?
    reservation_handler.can_reserve?
  end

  private

  def reservation_handler
    @reservation_handler ||= ::ReservationsHandler.new(h.current_user, self)
  end
end
