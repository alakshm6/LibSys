json.array!(@admins) do |admin|
  json.extract! admin, :id, :email, :name, :encrypted_password, :salt, :pre_configured
  json.url admin_url(admin, format: :json)
end
