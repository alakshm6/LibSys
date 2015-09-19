json.array!(@checkout_histories) do |checkout_history|
  json.extract! checkout_history, :id, :email, :ISBN, :checkout_timestamp, :return_timestamp
  json.url checkout_history_url(checkout_history, format: :json)
end
