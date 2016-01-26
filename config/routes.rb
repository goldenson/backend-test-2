Rails.application.routes.draw do
  get 'receive/' => 'voices#receive'
  get 'forward/' => 'voices#forward'
end
