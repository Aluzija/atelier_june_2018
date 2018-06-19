require 'rails_helper'

describe 'AppRouting' do
  it {
    expect(root: 'books', action: 'index')
  }

  it {
    expect(get: 'books/12/reserve').to route_to(
    controller: 'reservations',
    action: 'reserve',
    book_id: '12'
    )
  }

  it {
    expect(get: reserve_book_path(book_id: 12)).to route_to(
    controller: 'reservations',
    action: 'reserve',
    book_id: '12'
    )
  }

  it {
    expect(get: 'books/12/take').to route_to(
    controller: 'reservations',
    action: 'take',
    book_id: '12'
    )
  }

  it {
    expect(get: take_book_path(book_id: 12)).to route_to(
    controller: 'reservations',
    action: 'take',
    book_id: '12'
    )
  }

  it {
    expect(get: 'books/12/give_back').to route_to(
    controller: 'reservations',
    action: 'give_back',
    book_id: '12'
    )
  }

  it {
    expect(get: give_back_book_path(book_id: 12)).to route_to(
    controller: 'reservations',
    action: 'give_back',
    book_id: '12'
    )
  }

  it {
    expect(get: 'books/12/cancel_reservation').to route_to(
    controller: 'reservations',
    action: 'cancel',
    book_id: '12'
    )
  }

  it {
    expect(get: cancel_book_reservation_path(book_id: 12)).to route_to(
    controller: 'reservations',
    action: 'cancel',
    book_id: '12'
    )
  }

  it {
    expect(get: 'users/5/reservations').to route_to(
    controller: 'reservations',
    action: 'users_reservations',
    user_id: '5'
    )
  }

  it {
    expect(get: users_reservations_path(user_id: 5)).to route_to(
    controller: 'reservations',
    action: 'users_reservations',
    user_id: '5'
    )
  }

  it {
    expect(get: 'google-isbn').to route_to(
    controller: 'google_books',
    action: 'show'
    )
  }
end