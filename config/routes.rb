Rails.application.routes.draw do
  root 'voices#index'

  # GET
  get 'receive' => 'voices#receive'
  get 'forward' => 'voices#forward'
  get 'hangup' => 'voices#hangup'

  # POST
  post 'save_call' => 'voices#save_call'
  post 'get_recording' => 'voices#get_recording'
end
