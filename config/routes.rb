Rails.application.routes.draw do
  root 'voices#calls'
  get 'receive/' => 'voices#receive'
  get 'forward/' => 'voices#forward'
  post 'plivo_answer' => 'voices#save_call'
  post 'get_recording' => 'voices#get_recording'
  get 'hangup' => 'voices#hangup'
end
