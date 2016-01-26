Rails.application.routes.draw do
  get 'receive/' => 'voices#receive'
  get 'forward/' => 'voices#forward'
  post 'plivo_answer' => 'voices#save_call'
  post 'get_recording' => 'voices#get_recording'
end
